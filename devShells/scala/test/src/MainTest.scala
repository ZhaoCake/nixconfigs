package myproject

class MainTest extends munit.FunSuite {
  test("greet should return correct greeting") {
    val result = Main.greet("World")
    assertEquals(result, "Hello, World!")
  }
  
  test("greet with empty string") {
    val result = Main.greet("")
    assertEquals(result, "Hello, !")
  }
}
