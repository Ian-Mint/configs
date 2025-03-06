function cd --wraps=cd
    builtin cd $argv
    vs
    set_ti_pythonpath
end
