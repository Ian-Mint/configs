function __gs_complete_gcs_path
    set -l token (commandline -ct)
    if string match -q 'gs://*' -- $token
        set -l prefix (string replace -r '[^/]*$' '' -- $token)
        gcloud storage ls $prefix 2>/dev/null
    end
end

complete -c gs -f -a '(__gs_complete_gcs_path)'
