
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package src.main.scala
import org.apache.spark.{SparkContext,SparkConf, Logging}
import org.apache.spark.SparkContext._
import org.apache.spark.graphx._
import org.apache.spark.graphx.lib._
import org.apache.spark.graphx.util.GraphGenerators
import org.apache.spark.rdd._
import org.apache.spark.storage.StorageLevel

 object StronglyConnectedComponentApp {
  
  def main(args: Array[String]) {
    if (args.length < 3) {
      println("usage: <input> <output> <minEdge> ")      
      System.exit(0)
    }
    val conf = new SparkConf
    conf.setAppName("Spark StronglyConnectedComponent Application")
    val sc = new SparkContext(conf)
    
	val input = args(0) 
    val output = args(1)
	val minEdge= args(2).toInt

	val graph = GraphLoader.edgeListFile(sc, input, true, minEdge, StorageLevel.MEMORY_AND_DISK, StorageLevel.MEMORY_AND_DISK)	
	val res = graph.stronglyConnectedComponents(3).vertices
	res.saveAsTextFile(output);
    sc.stop();
  }
}
