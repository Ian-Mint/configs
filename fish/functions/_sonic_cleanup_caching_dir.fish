# Delete the Sonic caching dir for the given branch. Safe no-op if the
# branch is empty, resolves to the bare base, or the dir is absent.

function _sonic_cleanup_caching_dir --argument-names branch
    if test -z "$branch"
        return 0
    end
    set -l dir (_sonic_caching_dir $branch)
    if test -z "$dir"; or test "$dir" = "$SONIC_ROOT_CACHING_DIR_BASE"
        return 0
    end
    if not test -d $dir
        return 0
    end

    set -l size (du -sh $dir 2>/dev/null | string split -f1 \t)
    printf '[sonic-wt-gc] removing %s (%s) for %s\n' $dir $size $branch
    chmod -R u+w -- $dir 2>/dev/null
    rm -rf -- $dir
end
