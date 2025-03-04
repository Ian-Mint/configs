function cd --wraps=cd
    builtin cd $argv
    vs

    # Ti
    # set and unset PYTHONPATH for titanium
    set current_dir (command pwd)
    if string match -qr "^$HOME/titanium(/|\$)" $current_dir
        set -gx PYTHONPATH $HOME/titanium/src/python
    else if string match -qr "^$HOME/titanium(/|\$)" $prev_dir
        set -e PYTHONPATH
    end
    set -g prev_dir $current_dir
end
