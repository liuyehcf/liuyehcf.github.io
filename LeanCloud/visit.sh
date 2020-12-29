#!/bin/bash

function getJobIds() {
    jobIds=()
    i=1

    jobs > tmp.txt

    while read line
    do
        jobId=${line}
        jobId=${jobId#*\[}
        jobId=${jobId%\]*}
        jobIds[${i}]=${jobId}
        ((i++))
    done < tmp.txt

    rm -f tmp.txt

    echo ${jobIds[*]}
}

URLS=$(cat /root/url.list)
TOTAL=$(cat /root/url.list | wc -l)
JOB_COUNT=0
URL_COUNT=0
rm -f log.log

for URL in $URLS
do
    ((URL_COUNT++))
    echo "------------------------------------------------------"
    echo "Total: ${TOTAL}, Current: ${URL_COUNT}"
    echo "Url: ${URL}"
    for i in $(seq 1 $(($RANDOM%20)));
    do
            echo "times: ${i}"
            google-chrome --headless --disable-gpu --no-sandbox $URL >> log.log 2>&1 &
            ((JOB_COUNT++))

            # 当后台进程多余10个时，全部杀掉，等待3秒，然后杀掉
            if [ $JOB_COUNT -ge 10 ];
            then
                sleep 3

                jobIds=$(getJobIds)
                echo "jobIds: $jobIds"

                for jobId in ${jobIds}
                do
                    kill -9 %${jobId}
                done

                JOB_COUNT=0
            fi
    done
done