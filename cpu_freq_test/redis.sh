num=0
conf="master.conf slave_1.conf slave_2.conf"
node_number="8000 8001 8002 8100"

if [[ $# -lt 1 ]]; then
    echo "./$0 clockdown | standard"
    exit
fi

unset GREP_OPTIONS
pkill redis

sleep 2s
find /home/jinsu/redis-6.0.5/ -name "*dump.rdb" -exec rm {} \;
find /home/jinsu/redis-6.0.5/ -name "*appendonly.aof" -exec rm {} \;

#redis turn on
for nd in $conf; do
    /home/jinsu/redis-6.0.5/src/redis-server /home/jinsu/redis-6.0.5/cpu_freq_test/$nd
done
/home/jinsu/redis-6.0.5/src/redis-sentinel /home/jinsu/redis-6.0.5/cpu_freq_test/sentinel.conf

##cpu_freq setting low 
if [[ $1 == "clockdown" ]]; then
    for nd_n in $node_number; do
        pid=`ps -ef | grep "redis" | grep "$nd_n" | awk '{print $2}'`
        taskset -cp $num $pid
        if [[ $nd_n == "8001" ]]; then
            cpupower -c $num frequency-set -u 1000MHz
        elif [[ $nd_n == "8002" ]]; then
            cpupower -c $num frequency-set -u 1000MHz
        fi
        num=$((num+1))
    done
    cpupower -c 0 frequency-set -u 2500MHz
fi

if [[ $1 == "standard" ]]; then
    for nd_n in $node_number; do
        pid=`ps -ef | grep "redis" | grep "$nd_n" | awk '{print $2}'`
        taskset -cp $num $pid
        cpupower -c $num frequency-set -u 2500MHz
        num=$((num+1))
    done
fi
        



