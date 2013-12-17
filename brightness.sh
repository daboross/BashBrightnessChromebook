#!/bin/bash
declare -ri MAX=2800
declare -ri MIN=100
declare -r BR_PATH="/sys/devices/platform/s3c24xx-pwm.0/pwm-backlight.0/backlight/pwm-backlight.0/brightness"
declare -ri CURRENT="`cat $BR_PATH`"

do_set() {
    local -i NEXT="$1"
    if [[ "$((NEXT < MIN))" == "1" ]]; then
        NEXT="$MIN"
    elif [[ "$(($NEXT > $MAX))" == "1" ]]; then
        NEXT="$MAX"
    fi
    echo "(${CURRENT} -> ${NEXT})"
    echo "$NEXT" > "$BR_PATH"
}

up() {
    [[ -z "$1" ]] && local -ri INC="25" || local -ri INC="$1"
    local -ri NEXT="$((CURRENT + INC))"
    do_set "$NEXT"
}

down() {
    [[ -z "$1" ]] && local -ri INC="25" || local -ri INC="$1"
    local -ri NEXT="$((CURRENT - INC))"
    do_set "$NEXT"
}

main() {
    case "$1" in
        up)
            up "$2" ;;
        down)
            down "$2" ;;
        *)
            echo "Usage: $0 <UP|DOWN>" ;;
    esac
}

main "$@"
