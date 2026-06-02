# Keep $SONIC_ROOT_CACHING_DIR in sync with the worktree branch as you move
# around: re-derive base + ".<branch>" whenever the directory changes.
# (Initial value is set in conf.d/path.fish at startup.)

function _sonic_caching_dir_on_pwd --on-variable PWD
    _sonic_set_caching_dir
end
