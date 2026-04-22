function _bazel_wt_list_worktree_paths
    git worktree list --porcelain 2>/dev/null | awk '/^worktree /{print substr($0, 10)}'
end
