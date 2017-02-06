[ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ] || return

if [ -z "$FNDGREP_COLOR" ]; then
    FNDGREP_COLOR=true
fi

function fndgrep {
    extension=""
    pattern=""
    directory="./"
    cores="-P0"

    if [ "`uname`" == "Darwin" ]; then
        cores="-P4"
    fi

    echo "$@"

    # TODO find a better way that isn't order dependent for opts
    consumedops=0
    while getopts ":e:d:p:h" opt; do
        echo "opt: $opt"
        case $opt in
            p)
                consumedops=$((consumedops+2))
                pattern="$OPTARG"
                ;;
            e)
                consumedops=$((consumedops+2))
                extension="$OPTARG"
                ;;
            d)
                consumedops=$((consumedops+2))
                directory="$OPTARG"
                ;;
            h)
                echo "Usage: fndgrep [options] 'search term'" >&2
                echo "  -e: Search by extension"
                echo "  -p: Search by file pattern"
                echo "  -d: Directory to search"
                return
            ;;
        esac
    done
    shift $((consumedops))

    echo "$# $@"

    if [ -n "$1" ]; then
        fndgrepcolor=""
        if [ "true" == "$FNDGREP_COLOR" ]; then
            fndgrepcolor="--color=always"
        fi

        # Really ugly way of handling this and doesn't support multiple patterns, but it will do for now
        if [ -n "$pattern" ] && [ -n "$extension" ]; then
            echo "Please use either a pattern or an extension not both at the same time." >&2
        elif [ -n "$pattern" ]; then
            find "$directory" -type f -iname "$pattern" -print0 | xargs -0 $cores grep $grepSwitches $fndgrepcolor $FNDGREP_DEFOPTS $@
        elif [ -n "$extension" ]; then
            find "$directory" -type f -iname "*.$extension" -print0 | xargs -0 $cores grep $fndgrepcolor $FNDGREP_DEFOPTS $@
        else
            find "$directory" -type f -print0 | xargs -0 $cores grep $grepSwitches $fndgrepcolor $FNDGREP_DEFOPTS $@
        fi
    else
        fndgrep -h
    fi
}

function fndgrepr {
    extension=""
    pattern=""
    directory=""
    grepSwitches=""

    while getopts ":e:d:p:g:" opt; do
        case $opt in
            p)
                pattern="-p"
                patternArg="$OPTARG"
                ;;
            e)
                extension="-e"
                extensionArg="$OPTARG"
                ;;
            d)
                directory="$OPTARG"
                ;;
            g)
                grepSwitches="$OPTARG"
                ;;
            \?)
                fndgrep -h
                return
            ;;
        esac
    done
    shift $((OPTIND-1))

    while [ $# != 0 ]; do
        if [ $# -gt 1 ]; then
            fndgrep $extension $pattern $directory -l $1 | while read file; do
                echo "Found Match in $file"
            done
        else
            if [ -n "$grepSwitches" ]; then
                grepSwitches = "-g '$grepSwitches'"
            fi
            fndgrep -d "$directory" $extension $extensionArg $pattern $patternArg $grepSwitches $1
        fi
        shift
    done
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

if [[ "bash" != "$0" ]]; then
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
