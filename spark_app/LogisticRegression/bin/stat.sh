echo "Running IOSTAT"
iostat -m 1 >iostat-stdout_24x8x5.txt 2>iostat-stderr.txt &
echo "Running MPSTAT"
mpstat 1 >mpstat-stdout_24x8x5.txt 2>mpstat-stderr.txt &
echo "Running VMSTAT"
vmstat -S M 1 >vmstat-stdout_24x8x5.txt 2>vmstat-stderr.txt &
echo "Running executable"
#./bin/run
/usr/bin/time -v ./run.sh | tee logres_time
#/usr/bin/time -v ./bin/run 2>&1 | tee open_jdk_time_scala_count_performance
#kill $(ps -e | grep operf | awk '{print $1}') // to kill the operf running in background
