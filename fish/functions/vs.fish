function vs
    set -l roots $PWD

    set -l gt (git rev-parse --show-toplevel 2>/dev/null)
    set -l gt_status $status
    if test $gt_status -eq 0; and test "$gt" != "$PWD"
        set -a roots $gt
    end

    if test $gt_status -eq 0
        set -l gc (git rev-parse --git-common-dir 2>/dev/null)
        if test $status -eq 0
            set -l main_root (path dirname $gc)
            if test "$main_root" != "$PWD"; and test "$main_root" != "$gt"
                set -a roots $main_root
            end
        end
    end

    for root in $roots
        for dir in venv .venv
            if test -f $root/$dir/bin/activate.fish
                source $root/$dir/bin/activate.fish
                return
            end
        end
    end
end
