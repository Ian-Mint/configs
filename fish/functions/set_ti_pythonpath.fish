function set_ti_pythonpath
    set current_dir (pwd)
    set ti_pythonpath $HOME/titanium/src/python
    if string match -qr "^$HOME/titanium(/|\$)" $current_dir
        set -gx PYTHONPATH $ti_pythonpath
    else if set -q PYTHONPATH and test $PYTHONPATH = $ti_pythonpath
        set -e PYTHONPATH
    end
    set -g prev_dir $current_dir
end
