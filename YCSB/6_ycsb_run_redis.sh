workloads="a b c d e f"
#workloads="c"
master_port="8000"
master_host="127.0.0.1"
DIR="result_local_ycsb_test8_201006"

mode="standard clockdown"
#mode="clockdown"
###
#if [[ $# -lt 1 ]] ; then
#    echo "./$0 clockdown | standard"
#    exit
#fi
###

num=0;
max=1;
mkdir $DIR
while [[ $num -lt $max ]]; do
    for md in $mode; do    
        for wl in $workloads ; do
            ../../scripts/1_run_redis.sh "$md"
            sleep 15s
            ./bin/ycsb load redis -s -P workloads/workload"$wl" -p "redis.host=127.0.0.1" -p "redis.port=8000" | tee "$DIR"/"$md"_outputLoad_"$wl".txt
            ./bin/ycsb run redis -s -P workloads/workload"$wl" -p "redis.host=127.0.0.1" -p "redis.port=8000" | tee "$DIR"/"$md"_outputRun_"$wl".txt
        done
    done
    num=$num+1
done
