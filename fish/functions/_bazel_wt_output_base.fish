# Derive the Bazel output_base for a given workspace path.
# Bazel hashes the workspace path with MD5 and stores the output_base at
# $HOME/.cache/bazel/_bazel_<user>/<md5>.

function _bazel_wt_output_base --argument-names workspace_path
    set -l hash (printf '%s' $workspace_path | md5sum | string split -f1 ' ')
    echo $HOME/.cache/bazel/_bazel_(id -un)/$hash
end
