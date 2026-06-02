# Point $SONIC_ROOT_CACHING_DIR at the cache dir for the branch in the
# current working directory (base + ".<branch>").

function _sonic_set_caching_dir
    set -l branch (git branch --show-current 2>/dev/null)
    set -l dir (_sonic_caching_dir $branch)
    if test -n "$dir"
        set -gx SONIC_ROOT_CACHING_DIR $dir
    end
end
