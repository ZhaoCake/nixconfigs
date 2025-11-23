package app

@main def hello(): Unit = {
  println("Hello, Scala World!")
  println(s"Running on Scala ${util.Properties.versionNumberString}")
}
