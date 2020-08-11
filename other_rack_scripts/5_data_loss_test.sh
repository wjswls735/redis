
DIR="result_data_loss_200811"
if [[ $# -lt 3 ]]; then
    echo "./$0 clockdown | standard"
    echo "./$0 thread"
    echo "./$0 ops"
    exit
fi
num=0
conf="8002.conf"
nd_n="8002"
unset GREP_OPTIONS
pkill redis
sleep 2s

find /home/jslee/redis/ -name "*.rdb" -exec rm {} \;
find /home/jslee/redis/ -name "*.aof" -exec rm {} \;

for nd in $conf; do
    /home/jslee/redis/src/redis-server /home/jslee/redis/cpu_freq_test/$nd
done

sleep 2s
mkdir $DIR

if [[ $1 == "clockdown" ]]; then 
    mkdir $DIR/clockdown
    pid=`ps -ef | grep "redis-server" | grep "$nd_n" | awk '{print $2}'`
    taskset -cp $num $pid

    cpupower -c 0 frequency-set -u 1000MHz
    
    ../src/redis-cli -p 8002 monitor > $DIR/clockdown/thread_"$2"_ops_"$3".txt

fi

if [[ $1 == "standard" ]]; then
    mkdir $DIR/standard
    pid=`ps -ef | grep "redis-server" | grep "$nd_n" | awk '{print $2}'`
    taskset -cp $num $pid

#    cpupower -c $num frequency-set -u 1000MHz
    ../src/redis-cli -p 8002 monitor > $DIR/standard/thread_"$2"_ops_"$3".txt
fi

