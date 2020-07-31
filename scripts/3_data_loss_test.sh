data=1024
threads="1 4"
port=8000
ops="1000 10000 100000"
RDIR="result_data_loss_200722"
CDIR="clockdown_test"
SDIR="standard_test"
mkdir $RDIR
mkdir $RDIR/$CDIR
mkdir $RDIR/$SDIR
if [[ $# -lt 1 ]]; then
    echo "./$0 clockdown | standard"
    exit
fi
for th in $threads ; do
    for n in $ops ; do
        port=8000
        if [[ $1 == "clockdown" ]] ; then
            ./1_run_redis.sh clockdown
            
            mkdir $RDIR/$CDIR/thread_"$th"_ops_"$n"
            while [[ $port -le 8002 ]] ; do
            
                if [[ $port == "8000" ]] ; then
                    redis-cli -p $port monitor >$RDIR/$CDIR/thread_"$th"_ops_"$n"/master &
                elif [[ $port == "8001" ]] ; then
                    redis-cli -p $port monitor >$RDIR/$CDIR/thread_"$th"_ops_"$n"/slave_1 &
                else
                    redis-cli -p $port monitor >$RDIR/$CDIR/thread_"$th"_ops_"$n"/slave_2 &
                fi
                port=$((port+1))
            done
            master_pid=`ps -ef | grep "redis-server" | grep "8000" | awk '{print $2}'`

            ../memtier_benchmark/memtier_benchmark -p 8000 -t $th --ratio=100:0 -d $data -c 1 -n $n

            kill -9 $master_pid

            slave1_pid=`ps -ef | grep "redis" | grep "monitor" | grep "8001" | awk '{print $2}'`
            slave2_pid=`ps -ef | grep "redis" | grep "monitor" | grep "8002" | awk '{print $2}'`
            kill -9 $slave1_pid
            kill -9 $slave2_pid
        fi


        if [[ $1 == "standard" ]] ; then
            ./1_run_redis.sh standard
            mkdir $RDIR/$SDIR/thread_"$th"_ops_"$n"
            while [[ $port -le 8002 ]]; do
                if [[ $port == "8000" ]] ; then
                    redis-cli -p $port monitor >$RDIR/$SDIR/thread_"$th"_ops_"$n"/master &
                elif [[ $port == "8001" ]] ; then
                    redis-cli -p $port monitor >$RDIR/$SDIR/thread_"$th"_ops_"$n"/slave_1 &
                else
                    redis-cli -p $port monitor >$RDIR/$SDIR/thread_"$th"_ops_"$n"/slave_2 &
                fi
                port=$((port+1))
            done
            master_pid=`ps -ef | grep "redis-server" | grep "8000" | awk '{print $2}'`

            ../memtier_benchmark/memtier_benchmark -p 8000 -t $th --ratio=100:0 -d $data -c 1 -n $n

            kill -9 $pid

            slave1_pid=`ps -ef | grep "redis" | grep "monitor" | grep "8001" | awk '{print $2}'`
            slave2_pid=`ps -ef | grep "redis" | grep "monitor" | grep "8002" | awk '{print $2}'`
            kill -9 $slave1_pid
            kill -9 $slave2_pid
        fi
    done
done

