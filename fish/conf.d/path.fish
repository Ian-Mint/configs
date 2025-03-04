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
set -x SONIC_ROOT_CACHING_DIR "$HOME/.cache/sonic"
set -x SONIC_ENABLE_RAW_LOGGING 1
set -x TARGET_BRANCH env-nonprod-ian
set -x TI_ENV ian.brainos.dev
set -x SONIC_ENABLE_STITCHING_BLENDING 1

# pyenv
set -x PYENV_ROOT "$HOME/.pyenv"
if test -d $PYENV_ROOT/bin
    set -x PATH $PYENV_ROOT/bin $PATH
end

