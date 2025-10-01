@regression
Feature: Calculator Subtraction
  As a user
  I want to subtract two numbers
  So that I can get the correct difference

  Scenario: Subtract two positive numbers
    Given I have a calculator
    When I subtract 3 from 10
    Then the result should be 7

  Scenario: Subtract resulting in negative number
    Given I have a calculator
    When I subtract 15 from 5
    Then the result should be -10

  Scenario: Subtract negative numbers
    Given I have a calculator
    When I subtract -5 from 10
    Then the result should be 15

  Scenario: Subtract zero from a number
    Given I have a calculator
    When I subtract 0 from 20
    Then the result should be 20

  Scenario Outline: Subtract multiple number combinations
    Given I have a calculator
    When I subtract <second> from <first>
    Then the result should be <expected>

    Examples:
      | first | second | expected |
      |   100 |     50 |       50 |
      |     0 |     10 |      -10 |
      |   -10 |     -5 |       -5 |
      |    25 |     25 |        0 |
