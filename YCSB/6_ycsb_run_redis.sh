workloads="a b c d e f"
#workloads="a"
master_port="80"
master_host="127.0.0.1"
DIR="result_over_the_network_ycsb_test_200814"

mode="standard clockdown"
#mode="clockdown"
###
#if [[ $# -lt 1 ]] ; then
#    echo "./$0 clockdown | standard"
#    exit
#fi
###

mkdir $DIR
for md in $mode; do    
    for wl in $workloads ; do
        ../../scripts/1_run_redis.sh "$md"
        sleep 4s
        ./bin/ycsb load redis -s -P workloads/workload"$wl" -p "redis.host=220.149.85.17" -p "redis.port=80" | tee "$DIR"/"$md"_outputLoad_"$wl".txt
        ./bin/ycsb run redis -s -P workloads/workload"$wl" -p "redis.host=220.149.85.17" -p "redis.port=80" | tee "$DIR"/"$md"_outputRun_"$wl".txt
    done
done
