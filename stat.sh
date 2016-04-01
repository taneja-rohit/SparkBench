echo "Running IOSTAT"
iostat -m 1 >iostat-stdout.txt 2>iostat-stderr.txt &
echo "Running MPSTAT"
mpstat 1 >mpstat-stdout.txt 2>mpstat-stderr.txt &
echo "Running VMSTAT"
vmstat -S M 1 >vmstat-stdout.txt 2>vmstat-stderr.txt &
echo "Running executable"
#./bin/run
/usr/bin/time -v ./run.sh 2>&1 | tee logres_time
echo "Filtering data"
tr -s ' ' ',' <mpstat-stdout.txt >mpstat-stdout_inter.txt
awk -F',' '{print " "$4" "$6" "$7""}' mpstat-stdout_inter.txt > mpstat_final.txt
awk '/sda/' iostat-stdout.txt  > iostat-inter1.out
tr -s ' ' ',' <iostat-inter1.txt >iostat-stdout_inter.txt
awk -F',' '{print " "$1" "$3" "$4""}' iostat-stdout_inter.txt > iostat_final.txt
sed -i 's/^ *//' vmstat-stdout.txt > vmstat_inter1.txt
tr -s ' ' ',' <vmstat-inter1.txt >vmstat-stdout_inter2.txt
awk -F',' '{print " "$4" "$5" "$6""}' vmstat-stdout_inter2.txt > vmstat_final.txt
#/usr/bin/time -v ./bin/run 2>&1 | tee open_jdk_time_scala_count_performance
#kill $(ps -e | grep operf | awk '{print $1}') // to kill the operf running in background
