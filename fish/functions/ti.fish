function ti
    set -l ti_root (git rev-parse --show-toplevel 2>/dev/null)
    if test -z "$ti_root"
        set ti_root $HOME/titanium
    end
    $ti_root/titanium $argv
end
