package com.example;

/**
 * This is a class.
 */
public class Greeter {

  /**
   * This is a constructor.
   */
  public Greeter() {

  }

  /**
   * Greets a person by name.
   *
   * @param someone person name
   * @return greeting message
   */
  public String greet(String someone) {
    return String.format("Hello, %s!", someone);
  }
}
