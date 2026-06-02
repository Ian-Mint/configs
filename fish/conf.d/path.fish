# My stuff
set -x EDITOR nvim
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x PATH $PATH $HOME/.local/bin /usr/local/bin

# GO settings
set -x GOBIN "$HOME/go/bin"
set -x PATH $PATH $GOBIN /usr/local/go/bin

# add Pulumi to the PATH
set -x PATH $PATH /home/ian.pegg/.pulumi/bin

# titanium
set -gx SONIC_ROOT_CACHING_DIR_BASE "$HOME/.cache/sonic"
# Track the worktree branch in the cache dir (base + ".<branch>"). Updated
# on `wt switch`; derived here too so fresh shells match the current branch.
_sonic_set_caching_dir
set -x SONIC_ENABLE_RAW_LOGGING 1
set -x TARGET_BRANCH env-nonprod-ian
set -x TI_ENV ian.brainos.dev
set -x SONIC_ENABLE_STITCHING_BLENDING 1

# pyenv
set -x PYENV_ROOT "$HOME/.pyenv"
if test -d $PYENV_ROOT/bin
    set -x PATH $PYENV_ROOT/bin $PATH
end

