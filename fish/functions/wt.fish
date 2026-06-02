# Wrapper around `wt` (worktrunk) that cleans up the matching Bazel
# output_base after a successful `wt remove`.
#
# Replaces the stock shell integration (see `wt config shell init fish`)
# while preserving its directive-file protocol so `wt switch` etc. still
# change directory.

function wt
    set -l subcmd
    set -l skip_next 0
    for arg in $argv
        if test $skip_next -eq 1
            set skip_next 0
            continue
        end
        switch $arg
            case '-C' '--config'
                set skip_next 1
                continue
            case '-*'
                continue
        end
        set subcmd $arg
        break
    end

    set -l before
    if test "$subcmd" = remove
        set before (_bazel_wt_list_worktrees)
    end

    set -l directive_file (mktemp)
    WORKTRUNK_DIRECTIVE_FILE=$directive_file command wt $argv
    set -l exit_code $status

    if test -s $directive_file
        source $directive_file
    end
    rm -f $directive_file

    # Any command that moved us (switch/new/...) lands in a worktree; point
    # the Sonic cache at the branch we ended up on.
    if test $exit_code -eq 0
        _sonic_set_caching_dir
    end

    if test "$subcmd" = remove -a $exit_code -eq 0
        set -l after_paths (_bazel_wt_list_worktree_paths)
        for entry in $before
            set -l parts (string split \t $entry)
            set -l path $parts[1]
            set -l branch $parts[2]
            if not contains -- $path $after_paths
                _bazel_wt_cleanup_output_base $path
                _sonic_cleanup_caching_dir $branch
            end
        end
    end

    return $exit_code
end
