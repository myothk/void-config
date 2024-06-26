#!/bin/bash
#
# Change or display the "intel" CPU power saving mode according to the values of files
# located at /sys/devices/system/cpu/cpu[1-n]/power/energy_perf_bias. It also
# turn on and off the intel turbo boost based on 3 switchable CPU power modes.
# 
# EPB values = CPU mode
# 0 = performance
# 4 = performace-balance
# 6 = balance
# 8 = balance-powersave
# 15 = powersave
# Only 3 switches (0,6,15) are used in this script.

# change all CPU's max scaling frequency to the value of the file name passed.
# file name is cpu max,min.base frequencies info located at scaling_dir.
change_scaling_freq(){
    scaling_freq=$1
    if [ -z "$scaling_freq" ];then
        return 1
    fi
    for scaling_dir in /sys/devices/system/cpu/cpu*/cpufreq/; do
        echo $(cat $scaling_dir/$scaling_freq) > $scaling_dir/scaling_max_freq
    done
}

CPU_FILE=/sys/devices/system/cpu/cpu0/power/energy_perf_bias
GPU_FILE=/sys/bus/pci/devices/0000\:01\:00.0/power_state
# Check file existence.
if [ ! -e $CPU_FILE ] || [ ! -e $GPU_FILE ];then
    exit 1
fi

# If a single argument passed is show,
# display the CPU and GPU power mode and do nothing.
if [ "$1" == "show" ];then
    EPB=$(cat $CPU_FILE)
    D3D=$(cat $GPU_FILE)
    CPU=""
    GPU=""
    case $EPB in
        0) CPU="";;
        6) CPU="";;
        15) CPU="";;
    esac
    case $D3D in
        "D3cold") GPU="";;
        "D0") GPU="";;
    esac
    echo -e "$CPU $GPU"
fi

# If a single argument passed is toggle, change CPU mode and
# send signal to immediate update waybar.
if [ "$1" == "toggle" ];then
    EPB=$(cat $CPU_FILE)
    CPU_PERF=/sys/devices/system/cpu/cpu*/power/energy_perf_bias
    case $EPB in
        0) echo "15" | tee $CPU_PERF
            echo "1" > /sys/devices/system/cpu/intel_pstate/no_turbo
            change_scaling_freq cpuinfo_min_freq
            ;;
        6) echo "0" | tee $CPU_PERF
            echo "0" > /sys/devices/system/cpu/intel_pstate/no_turbo
            change_scaling_freq cpuinfo_max_freq
            ;;
        15) echo "6" | tee $CPU_PERF
            echo "1" > /sys/devices/system/cpu/intel_pstate/no_turbo
            change_scaling_freq base_frequency
            ;;
    esac
    echo "$(cat $CPU_PERF)"
    pkill -SIGRTMIN+1 waybar
fi
