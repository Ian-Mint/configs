# List worktrees as "<path>\t<branch>", one per line. Branch is empty for
# detached-HEAD worktrees.

function _bazel_wt_list_worktrees
    git worktree list --porcelain 2>/dev/null | awk '
        /^worktree /{ if (p != "") print p "\t" b; p = substr($0, 10); b = "" }
        /^branch /  { b = substr($0, 8); sub("^refs/heads/", "", b) }
        END         { if (p != "") print p "\t" b }
    '
end
