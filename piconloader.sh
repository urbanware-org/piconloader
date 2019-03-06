#!/bin/sh

# ============================================================================
# PiconLoader - Vu+ Duo2 picon loader
# Copyright (C) 2018 by Ralf Kilian
# Distributed under the MIT License (https://opensource.org/licenses/MIT)
#
# GitHub: https://github.com/urbanware-org/piconloader
# GitLab: https://gitlab.com/urbanware-org/piconloader
# ============================================================================

version="1.0.3"

dir_source=$(dirname $(readlink -f ${0}))
dir_daily="${dir_source}/daily"
dir_monthly="${dir_source}/monthly"
dir_qhourly="${dir_source}/qhourly"
dir_target="/usr/share/enigma2/picon"
file_temp="/tmp/piconloader.tmp"

current_month=$(date "+%m")
current_day=$(date "+%d")
current_hour=$(date "+%H")
current_min=$(date "+%M")
next_hour=$(( current_hour + 1 ))

mkdir -p "${dir_monthly}"
mkdir -p "${dir_qhourly}"

# Functions

check_daily() {
    # Check picons depending on a certain day
    if [ -d "${dir_daily}/${current_month}-${current_day}" ]; then
        copy_picons "${dir_daily}/${current_month}-${current_day}" \
                    "${dir_target}/"
    fi
}

check_monthly() {
    # Check picons depending on a certain month
    if [ -d "${dir_monthly}/${current_month}" ]; then
        copy_picons "${dir_monthly}/${current_month}" "${dir_target}/"
    fi
}

check_qhourly() {
    # Check picons depending on a certain time (quarter-hourly)
    if [ $next_hour != 24 ]; then
        loop_hours $next_hour 23
    fi

    loop_hours 0 $current_hour
}

loop_hours() {
    for hour in $(seq ${1} ${2}); do
        if [ $hour -lt 10 ]; then
            temp="0${hour}"
            hour=$temp
        fi

        for qhour in $(seq 0 3); do
            if [ $qhour == 0 ]; then
                minutes=00
            else
                temp=$(( 15 * qhour ))
                minutes=$temp
            fi

            if [ $hour == $current_hour ]; then
                if [ $minutes -gt $current_min ]; then
                    break
                fi
            fi

            qdir="${dir_qhourly}/${hour}-${minutes}"
            if [ -d "$qdir" ]; then
                copy_picons "${qdir}" "${dir_target}/"
            fi
        done
    done
}

copy_picons() {
    for f in $(ls "${1}"); do
        cp -f "${1}/${f}" "${2}"
    done
}

# Main entry point

if [ -e "$file_temp" ]; then
    for min in 00 15 30 45; do
        if [ $current_min == $min ]; then
            check_monthly
            check_qhourly
        fi
    done
else
    check_monthly
    check_daily
    check_qhourly
    date > $file_temp
fi

# EOF
