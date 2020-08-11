workload="sw sr"
redis_mode="standard"
threads="4"
ops=1000000
client=1
mport=8000
data=1024
RDIR="result_cpu_freq_200708"
mkdir $RDIR
num=0
max=10

for mode in $redis_mode ; do
    while [[ $num -lt $max ]]; do
        for wo in $workload; do
            fname=thread_"$threads"_"$wo"_"$mode"_aofoff_$num.txt

            if [[ $wo == "sw" ]] ; then
                if [[ $redis_mode = "clockdown" ]] ; then
                    /home/jinsu/scripts/1_run_redis.sh $mode
                    sleep 15s
                elif [[ $redis_mode = "stardard" ]] ; then
                    /home/jinsu/scripts/1_run_redis.sh $mode
                    sleep 15s
                fi
            fi
            
            echo "----doing $wo load----"
            case $wo in
                sr) ../memtier_benchmark/memtier_benchmark -p $mport -t $threads --ratio=0:100 -d $data -c $client -n $ops > "$RDIR"/"$fname" ;;
                sw) ../memtier_benchmark/memtier_benchmark -p $mport -t $threads --ratio=100:0 -d $data -c $client -n $ops > "$RDIR"/"$fname" ;;
            esac
            echo "----done $wo load----"
        done
        num=$((num+1))
    done
done
