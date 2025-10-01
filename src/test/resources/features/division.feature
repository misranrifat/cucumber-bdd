@regression
Feature: Calculator Division
  As a user
  I want to divide two numbers
  So that I can get the correct quotient

  Scenario: Divide two positive numbers
    Given I have a calculator
    When I divide 20 by 4
    Then the result should be 5

  Scenario: Divide by one
    Given I have a calculator
    When I divide 15 by 1
    Then the result should be 15

  Scenario: Divide positive by negative number
    Given I have a calculator
    When I divide 30 by -5
    Then the result should be -6

  Scenario: Divide two negative numbers
    Given I have a calculator
    When I divide -20 by -4
    Then the result should be 5

  Scenario: Divide by zero throws exception
    Given I have a calculator
    When I divide 10 by 0
    Then an ArithmeticException should be thrown

  Scenario Outline: Divide multiple number combinations
    Given I have a calculator
    When I divide <first> by <second>
    Then the result should be <expected>

    Examples:
      | first | second | expected |
      |   100 |     10 |       10 |
      |    81 |      9 |        9 |
      |   -50 |      5 |      -10 |
      |     0 |      5 |        0 |
