@regression
Feature: Calculator Multiplication
  As a user
  I want to multiply two numbers
  So that I can get the correct product

  Scenario: Multiply two positive numbers
    Given I have a calculator
    When I multiply 5 and 4
    Then the result should be 20

  Scenario: Multiply by zero
    Given I have a calculator
    When I multiply 10 and 0
    Then the result should be 0

  Scenario: Multiply positive and negative numbers
    Given I have a calculator
    When I multiply 6 and -3
    Then the result should be -18

  Scenario: Multiply two negative numbers
    Given I have a calculator
    When I multiply -4 and -5
    Then the result should be 20

  Scenario Outline: Multiply multiple number combinations
    Given I have a calculator
    When I multiply <first> and <second>
    Then the result should be <expected>

    Examples:
      | first | second | expected |
      |    10 |     10 |      100 |
      |     7 |      8 |       56 |
      |    -3 |      4 |      -12 |
      |     0 |    100 |        0 |
