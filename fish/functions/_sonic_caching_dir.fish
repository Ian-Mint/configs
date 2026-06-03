# Derive the Sonic caching dir for a given branch by appending the branch
# name to $SONIC_ROOT_CACHING_DIR_BASE. Slashes in the branch name are
# flattened to "-" so the cache stays a single directory. With no branch
# (detached HEAD, not a git repo) it falls back to the bare base.

function _sonic_caching_dir --argument-names branch
    if test -z "$SONIC_ROOT_CACHING_DIR_BASE"
        return 1
    end
    if test -n "$branch"
        echo "$SONIC_ROOT_CACHING_DIR_BASE."(string replace -a / - $branch)
    else
        echo "$SONIC_ROOT_CACHING_DIR_BASE"
    end
end
