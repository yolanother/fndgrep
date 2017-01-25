[ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ] || return

if [ -z "$FNDGREP_COLOR" ]; then
    FNDGREP_COLOR=true
fi

function fndgrep {
    if [ -d "$1" ]; then
        path="$1"
        shift
    else
        path="./"
    fi

    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: fndgrep (directory) file_pattern expression (grep params ...) "
    else
        pattern="$1"
        expression="$2"
        shift
        shift
        fndgrepcolor=""
        if [ "true" == "$FNDGREP_COLOR" ]; then
            fndgrepcolor="--color=always"
        fi
        if [ " " == "$pattern" ]; then
            find "$path" -type f -print0 | xargs -0 -P0 grep $fndgrepcolor $FNDGREP_DEFOPTS $@ "$expression"
        else
            find "$path" -type f -iname "$pattern" -print0 | xargs -0 -P0 grep $fndgrepcolor $FNDGREP_DEFOPTS $@ "$expression"
        fi
    fi
}

function efndgrep {
    ext="$1"
    shift
    if [ -d "$1" ]; then
        path="$1"
        shift
    else
        path="./"
    fi
    fndgrep "$path" "$ext" "$@"
}

function fndagrep {
    efndgrep " " "$@"
}

function fndjgrep {
    efndgrep "*.java" "$@"
}

function fndjsgrep {
    efndgrep "*.js" "$@"
}

function fndxgrep {
    efndgrep "*.xml" "$@"
}

function fndcgrep {
    efndgrep "*.c" "$@"
}

function fndcppgrep {
    efndgrep "*.cpp" "$@"
}

function fndhgrep {
    efndgrep "*.h" "$@"
}

function fndmkgrep {
    efndgrep "*.mk" "$@"
}


