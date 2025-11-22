package myproject

object Main {
  def main(args: Array[String]): Unit = {
    println("Hello, Scala!")
    println(s"Running Scala ${util.Properties.versionNumberString}")
    
    if (args.nonEmpty) {
      println(s"Arguments: ${args.mkString(", ")}")
    }
  }
  
  def greet(name: String): String = {
    s"Hello, $name!"
  }
}
