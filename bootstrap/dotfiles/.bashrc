# detect arch
read -r __OSTYPE __ARCH <<< "$(uname -sm)"
export __OSTYPE __ARCH

# __LOCAL_ROOT <- arch-indep software prefix
export __LOCAL_ROOT="${HOME}/.local"
# __OPT_ROOT <- arch-dep software prefix
export __OPT_ROOT="${__LOCAL_ROOT}/opt/${__OSTYPE}-${__ARCH}";

export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${__LOCAL_ROOT}/share"

export MAMBA_ROOT_PREFIX="${__OPT_ROOT}/miniforge3"
export MAMBA_EXE="${MAMBA_ROOT_PREFIX}/condabin/mamba"

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
    . <(mamba shell hook --shell bash)
    export PATH="${__SAVED_PATH__}"
    unset __SAVED_PATH__
fi

conda_envs_path_prepend "${XDG_DATA_HOME}/conda/envs"
conda_envs_path_prepend "${__OPT_ROOT}"

command -v direnv > /dev/null 2>&1 && eval "$(direnv hook bash)"
command -v starship > /dev/null 2>&1 && eval "$(starship init bash)"
