# Turn off the fish greeting
set -g fish_greeting

# activate a virtual env if there is one
vs
set_ti_pythonpath

# conda initialize >>>
set miniconda_home $HOME/miniconda3
if test -f $miniconda_home/bin/conda
    eval $miniconda_home/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "$miniconda_home/etc/fish/conf.d/conda.fish"
        . "$miniconda_home/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "$miniconda_home/bin" $PATH
    end
end
# <<< conda initialize <<<

