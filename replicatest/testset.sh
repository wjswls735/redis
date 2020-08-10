#master set
taskset -cp 1 14830

#replica set
taskset -cp 2 14836
taskset -cp 3 14843

#sentinel set
taskset -cp 4 14849


cpupower -c 2 frequency-set -u 2500MHz
cpupower -c 3 frequency-set -u 2500MHz

