#!/bin/bash
# Usage $0 
sparkSbin=/home/hduser/spark-1.3.1-openjdk/sbin
#sparkSbin=/home/hduser/spark-1.4.0/sbin
sparkBenchLoc=/home/hduser/SparkBench/spark_app
logdir=$1

rm $logdir/$3

 # pm_bandwidth PM_MEM_READ PM_MEM_PREF PM_MEM_RWITM PM_MEM_CO  
 e[191]=r0000010056,r000002C058,r000003C05E,r000004C058,r500fa,r600f4
 

 echo " Running nmon"
 nmon -F $2 -s 5 -c 7200
 #./run.sh 2>&1 | tee lets_see &
 #echo "starting perf in 12 seconds"
 #sleep 12
 echo using set 191 
 echo ${estr[191]} >> $logdir/$3
 perf stat -a -I 1000 -e ${e[191]}  >> $logdir/$3 2>&1  &
 echo "Running script"
 /usr/bin/time -v ./run.sh 2>&1 | tee lets_see 
 #(perf stat -ecache-misses -I 1000 ls > /dev/null ) > stat.log 2>&1
 #killall perf
 sleep 10
 killall nmon
 killall /usr/lib/linux-tools/3.19.0-15-generic/perf
 echo "Done with it"
 exit 0
# cd $sparkSbin 
# ./stop-all.sh
# mv start-slave.sh start-slave-ori.sh
# mv start-slave-numa.sh start-slave.sh
# ./start-all.sh
# cd $sparkBenchLoc/LogisticRegression/bin
# echo "Running script"
# ./run.sh 2>&1 | tee lets_see &
# echo "starting perf in 12 seconds"
# sleep 12
# echo using set 191 
# echo ${estr[191]} >> $logdir/bw_counts_numa.out
# perf stat -a -A -e ${e[191]}  >> $logdir/bw_counts_numa_all.out  2>&1

