# Shut down any Bazel server rooted at the output_base for the given
# workspace path, then delete the output_base. Safe no-op if nothing is
# there.

function _bazel_wt_cleanup_output_base --argument-names workspace_path
    set -l base (_bazel_wt_output_base $workspace_path)

    if not test -d $base
        return 0
    end

    set -l pid_file $base/server/server.pid.txt
    if test -f $pid_file
        set -l pid (cat $pid_file 2>/dev/null)
        if test -n "$pid"; and kill -0 $pid 2>/dev/null
            kill $pid 2>/dev/null
            for i in (seq 10)
                if not kill -0 $pid 2>/dev/null
                    break
                end
                sleep 1
            end
            if kill -0 $pid 2>/dev/null
                kill -9 $pid 2>/dev/null
            end
        end
    end

    set -l size (du -sh $base 2>/dev/null | string split -f1 \t)
    printf '[bazel-wt-gc] removing %s (%s) for %s\n' $base $size $workspace_path
    rm -rf -- $base
end
