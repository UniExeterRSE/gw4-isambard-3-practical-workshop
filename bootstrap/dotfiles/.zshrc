path_prepend() {
    if [[ -d $1 ]]; then
        case ":${PATH}:" in
            *":$1:"*) : ;;
            *) export PATH="${1}${PATH:+:${PATH}}" ;;
        esac
    fi
}

conda_envs_path_prepend() {
    if [[ -d $1 ]]; then
        case ":${CONDA_ENVS_PATH}:" in
            *":$1:"*) : ;;
            *) export CONDA_ENVS_PATH="${1}${CONDA_ENVS_PATH:+:${CONDA_ENVS_PATH}}" ;;
        esac
    fi
}

# just put conda and mamba in the PATH
path_prepend "${MAMBA_ROOT_PREFIX}/condabin"

if command -v mamba > /dev/null 2>&1; then
    # * this source the conda functions but not changing the PATH directly
    # it allows you to put the conda function available without letting it
    # changing your PATH
    __SAVED_PATH__="${PATH}"
    # shellcheck disable=SC1091,SC2312
    . <(mamba shell hook --shell zsh)
    export PATH="${__SAVED_PATH__}"
    unset __SAVED_PATH__
fi

conda_envs_path_prepend "${XDG_DATA_HOME}/conda/envs"
conda_envs_path_prepend "${__OPT_ROOT}"

command -v direnv > /dev/null 2>&1 && eval "$(direnv hook zsh)"
command -v starship > /dev/null 2>&1 && eval "$(starship init zsh)"
