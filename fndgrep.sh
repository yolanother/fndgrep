[ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ] || return

if [ -z "$FNDGREP_COLOR" ]; then
    FNDGREP_COLOR=true
fi

function fndgrep {
    extension=""
    pattern=""
    directory="./"
    cores="-P0"
    recursive=false

    if [ "`uname`" == "Darwin" ]; then
        cores="-P4"
    fi

    local params=""

    local OPTIND opt
    while getopts ":e:d:p:hr" opt; do
        case "$opt" in
            p)
                if [ -n "$params" ]; then
                    params="$params -o"
                fi
                params="$params -iname '*$OPTARG*'"
                ;;
            e)
                if [ -n "$params" ]; then
                    params="$params -o"
                fi
                params="$params -type f -iname '*.$OPTARG'"
                ;;
            d)
                directory="$OPTARG"
                ;;
            r)
                recursive=true
                ;;
            h)
                echo "Usage: fndgrep [options] 'search term'" >&2
                echo "  -e: Search by extension"
                echo "  -p: Search by file pattern"
                echo "  -d: Directory to search"
                echo "  -r: Each query is run on the previous"
                return
            ;;
        esac
    done
    shift $((OPTIND-1))

    if [ -n "$1" ]; then
        fndgrepcolor=""
        if [ "true" == "$FNDGREP_COLOR" ]; then
            fndgrepcolor="--color=always"
        fi

        local ignore=""
        if [ -f "$HOME/.fndgrepignore" ]; then
            while read file; do
                ignore="$ignore -name $file -prune -o"
            done < "$HOME/.fndgrepignore"
        fi

        if [ -n "$params" ]; then
            findcmd="find \"$directory\" $ignore -type f \( $params \) -print0"
        else
            findcmd="find \"$directory\" $ignore -type f $params -print0"
        fi

        if $recursive; then
            grepcmd=""
            firstgrep="$1"
            shift
            while [ $# -gt 0 ]; do
                if [ -n "$grepcmd" ]; then
                    grepcmd="$grepcmd | "
                fi
                grepcmd="grep $grepSwitches $fndgrepcolor $FNDGREP_DEFOPTS \"$1\""
                shift
            done

            eval $findcmd | xargs -0 $cores grep $grepSwitches $fndgrepcolor $FNDGREP_DEFOPTS "$firstgrep" | eval $grepcmd
        else
            eval $findcmd | xargs -0 $cores grep $grepSwitches $fndgrepcolor $FNDGREP_DEFOPTS $@
        fi
    else
        fndgrep -h
    fi
}

function fndjgrep {
    efndgrep -e "java" "$@"
}

function fndjsgrep {
    efndgrep -e "js" "$@"
}

function fndxgrep {
    efndgrep -e "xml" "$@"
}

function fndcgrep {
    efndgrep -e "c" "$@"
}

function fndcppgrep {
    efndgrep -e "cpp" "$@"
}

function fndhgrep {
    efndgrep -e "h" "$@"
}

function fndmkgrep {
    efndgrep -e "mk" "$@"
}

if [[ "bash" != "$0" ]] && [[ "-bash" != "$0" ]]; then
    fn="fndgrep"
    extension="*"
    path="./"

    if [ "$1" == "r" ]; then
        shift
        fndgrepr "$@"
    else
        fndgrep "$@"
    fi
fi
