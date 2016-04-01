#!/bin/bash

echo "========== preparing SVM data =========="
# configuration
bin=`dirname "$0"`
bin=`cd "$bin"; pwd`
DIR=`cd $bin/../; pwd`
. "${DIR}/../bin/config.sh"
. "${DIR}/bin/config.sh"



JAR="${MllibJarDir}/spark-mllib_2.10-1.3.0.jar"
#JAR="/home/hduser/SparkBench/spark_app/SVM/target/SVM-project-1.0.jar"
CLASS="org.apache.spark.mllib.util.SVMDataGenerator"
OPTION=" ${APP_MASTER} ${INPUT_HDFS} ${NUM_OF_EXAMPLES} ${NUM_OF_FEATURES}  ${NUM_OF_PARTITIONS} "
#${HADOOP_HOME}/bin/hadoop fs -rm -r ${INPUT_HDFS}
${HADOOP_HOME}/bin/hdfs dfs -rm -r ${INPUT_HDFS}
genOpt="large"

# paths check
if [ $genOpt == "large" ];then
	#tmp_dir=${APP_DIR}/tmp
	echo $tmp_dir	
	${HADOOP_HOME}/bin/hdfs dfs -rm -r $tmp_dir
	${HADOOP_HOME}/bin/hdfs dfs -mkdir -p ${APP_DIR}
	${HADOOP_HOME}/bin/hdfs dfs -mkdir -p $tmp_dir
	#srcf=/mnt/nfs_dir/sperf/data_set/tmp-10k
	srcf=/home/hduser/SparkBench/enwiki-doc
	#srcf=/home/hduser/SparkBench/spark_app/ECT/text8
	${HADOOP_HOME}/bin/hdfs dfs -copyFromLocal $srcf $tmp_dir

	JAR="${DIR}/target/scala-2.10/svmapp_2.10-1.0.jar"
	CLASS="src.main.scala.DocToTFIDF"
	OPTION="${tmp_dir} ${INPUT_HDFS} ${NUM_OF_PARTITIONS} "
fi

START_TIME=`timestamp`
START_TS=`ssh ${master} "date +%F-%T"`

echo ${SPARK_HOME}/bin/spark-submit --class $CLASS --master ${APP_MASTER} ${YARN_OPT} ${SPARK_OPT}  $JAR ${OPTION} 2>&1|tee ${BENCH_NUM}/SVM_gendata_${START_TS}.dat
exec ${SPARK_HOME}/bin/spark-submit --class $CLASS --master ${APP_MASTER} ${YARN_OPT} ${SPARK_OPT}  $JAR ${OPTION} 2>&1|tee ${BENCH_NUM}/SVM_gendata_${START_TS}.dat

END_TIME=`timestamp`

SIZE=`$HADOOP_HOME/bin/hadoop fs -du -s ${INPUT_HDFS} | awk '{ print $1 }'`
gen_report "SVM-gendata" ${START_TIME} ${END_TIME} ${SIZE} ${START_TS}>> ${BENCH_REPORT}
print_config ${BENCH_REPORT}
exit 0



