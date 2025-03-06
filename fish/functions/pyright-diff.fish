function pyright-diff
    set diff_files (git diff --diff-filter=d --name-only origin/env-nonprod -- '*.py')
    set untracked_files (git ls-files --others --exclude-standard -- '*.py')
    set all_files $diff_files $untracked_files
    set dependent_files (echo $all_files | xargs go run /home/ian.pegg/titanium/cmd/python-tools/find-dependents.go)
    pyright $dependent_files
end
