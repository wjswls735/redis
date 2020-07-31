node="master slave_1 slave_2"
mode="clockdown standard"
thread="1 4"
ops="1000 10000 100000"
if [[ $# -lt 1 ]]; then
    echo "./$0 File path ex) result_data_loss_200721/"
    exit
fi
rm "$1"result*

for n in $ops ; do
    for md in $mode ; do
        for th in $thread ; do 
            for nd in $node ; do
                if [[ $md == "clockdown" ]] ; then
                    if [[ $nd == "master" ]] ; then
                        m=`grep "SET" "$1""$md"_test/thread_"$th"_ops_"$n"/"$nd" | awk '{print NR }' | tail -1`
                        echo "$md ,thread_$th ,ops_$n ,$nd = $m" >>"$1"result_$md 
                    elif [[ $nd == "slave_1" ]] ; then
                        s_1=`grep "SET" "$1""$md"_test/thread_"$th"_ops_"$n"/"$nd" | awk '{print NR}' | tail -1`
                        echo "$md ,thread_$th ,ops_$n ,$nd = $s_1" >>"$1"result_$md
                    else
                        s_2=`grep "SET" "$1""$md"_test/thread_"$th"_ops_"$n"/"$nd" | awk '{print NR}' | tail -1`
                        echo "$md ,thread_$th ,ops_$n ,$nd = $s_2" >>"$1"result_$md
                    fi
                else
                    if [[ $nd == "master" ]] ; then
                        m=`grep "SET" "$1""$md"_test/thread_"$th"_ops_"$n"/"$nd" |  awk '{print NR}' | tail -1`
                        echo "$md ,thread_$th ,ops_$n ,$nd = $m" >>"$1"result_$md 
                    elif [[ $nd == "slave_1" ]] ; then
                        s_1=`grep "SET" "$1""$md"_test/thread_"$th"_ops_"$n"/"$nd" | awk '{print NR}' | tail -1`
                        echo "$md ,thread_$th ,ops_$n ,$nd = $s_1" >>"$1"result_$md
                    else
                        s_2=`grep "SET" "$1""$md"_test/thread_"$th"_ops_"$n"/"$nd" | awk '{print NR}' | tail -1`
                        echo "$md ,thread_$th ,ops_$n ,$nd = $s_2" >>"$1"result_$md
                    fi
                fi
            done
            echo -e "\n">>"$1"result_$md
        done
    done
done


