#!/bin/bash
#===overall config===
this="${BASH_SOURCE-$0}"
bin=$(cd -P -- "$(dirname -- "$this")" && pwd -P)
script="$(basename -- "$this")"
this="$bin/$script"

#SPARK_VERSION=1.3.1
SPARK_VERSION=1.4.0
master=cit928
MC_LIST="localhost"
SPARK_MASTER="spark://${master}:7077"
HDFS_URL="hdfs://${master}:8020"

export BENCH_VERSION="1.0"

###################### Global Paths ##################
if [ -z "$MllibJarDir" ]; then
	export MllibJarDir=/home/hduser/SparkBench
fi
if [ -z "$BENCH_HOME" ]; then
    export BENCH_HOME=`dirname "$this"`/..
fi

if [ -z "$BENCH_CONF" ]; then
    export BENCH_CONF=${BENCH_HOME}/bin
fi

if [ -f "${BENCH_CONF}/funcs.sh" ]; then
    . "${BENCH_CONF}/funcs.sh"
fi

if [ -z "$SPARK_HOME" ]; then
    export SPARK_HOME=/home/hduser/spark-1.4.0
    #export SPARK_HOME=/home/hduser/spark-1.3.1-openjdk
fi

if [ -z "$HADOOP_HOME" ]; then
    export HADOOP_HOME=/usr/local/hadoop
fi
subApp=
if [ -z "$HIVE_HOME" ]; then
    export HIVE_HOME=${BENCH_HOME}/common/hive-0.9.0-bin
fi





if [ $# -gt 1 ]
then
    if [ "--hadoop_config" = "$1" ]
          then
              shift
              confdir=$1
              shift
              HADOOP_CONF_DIR=$confdir
    fi
fi

#HADOOP_CONF_DIR="${HADOOP_CONF_DIR:-$HADOOP_HOME/conf}"
HADOOP_CONF_DIR="${HADOOP_CONF_DIR:-$HADOOP_HOME/etc/hadoop.dn2}"

# base dir HDFS
#export DATA_HDFS=/Bench
export DATA_HDFS=/data2/hadoopfs/dfs/data/Bench


export BENCH_NUM=${BENCH_HOME}/num;
if [ ! -d ${BENCH_NUM} ]; then
	mkdir -p ${BENCH_NUM};
	mkdir -p ${BENCH_NUM}/old;
fi 

# local report
#export EXECUTOR_GLOBAL_MEM=40g
#export EXECUTOR_GLOBAL_MEM=16g
#export EXECUTOR_GLOBAL_MEM=6g
export EXECUTOR_GLOBAL_MEM=16g
#export STORAGE_LEVEL=MEMORY_AND_DISK_SER
export STORAGE_LEVEL=MEMORY_AND_DISK
#export executor_cores=6
export MEM_FRACTION_GLOBAL=0.6
#export MEM_FRACTION_GLOBAL=0.005

################# Compress Options #################
# swith on/off compression: 0-off, 1-on
export COMPRESS_GLOBAL=0
export COMPRESS_CODEC_GLOBAL=org.apache.hadoop.io.compress.DefaultCodec
#export COMPRESS_CODEC_GLOBAL=com.hadoop.compression.lzo.LzoCodec
#export COMPRESS_CODEC_GLOBAL=org.apache.hadoop.io.compress.SnappyCodec


#if [ -z "$MAHOUT_HOME" ]; then
#    export MAHOUT_HOME=${BENCH_HOME}/common/mahout-distribution-0.7
#fi
