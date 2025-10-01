@regression
Feature: Calculator Addition
  As a user
  I want to add two numbers
  So that I can get the correct sum

  Scenario: Add two positive numbers
    Given I have a calculator
    When I add 5 and 3
    Then the result should be 8

  Scenario: Add a positive and a negative number
    Given I have a calculator
    When I add 10 and -4
    Then the result should be 6

  Scenario: Add two negative numbers
    Given I have a calculator
    When I add -7 and -3
    Then the result should be -10

  Scenario: Add zero to a number
    Given I have a calculator
    When I add 15 and 0
    Then the result should be 15

  Scenario Outline: Add multiple number combinations
    Given I have a calculator
    When I add <first> and <second>
    Then the result should be <expected>

    Examples:
      | first | second | expected |
      |   100 |    200 |      300 |
      |    50 |     50 |      100 |
      |   -25 |     25 |        0 |
      |     0 |      0 |        0 |
