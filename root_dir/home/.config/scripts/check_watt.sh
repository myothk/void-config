awk '{print int($1*1e-6) "W"}' /sys/class/power_supply/BAT0/power_now
