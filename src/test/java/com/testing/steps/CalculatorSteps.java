package com.testing.steps;

import com.testing.calculator.Calculator;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import lombok.extern.slf4j.Slf4j;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;

@Slf4j
public class CalculatorSteps {

    private Calculator calculator;
    private int result;
    private Exception exception;

    @Given("I have a calculator")
    public void iHaveACalculator() {
        calculator = new Calculator();
        log.info("Calculator initialized");
    }

    @When("I add {int} and {int}")
    public void iAddAnd(int first, int second) {
        result = calculator.add(first, second);
        log.info("Addition: {} + {} = {}", first, second, result);
    }

    @When("I subtract {int} from {int}")
    public void iSubtractFrom(int second, int first) {
        result = calculator.subtract(first, second);
        log.info("Subtraction: {} - {} = {}", first, second, result);
    }

    @When("I multiply {int} and {int}")
    public void iMultiplyAnd(int first, int second) {
        result = calculator.multiply(first, second);
        log.info("Multiplication: {} * {} = {}", first, second, result);
    }

    @When("I divide {int} by {int}")
    public void iDivideBy(int first, int second) {
        try {
            result = calculator.divide(first, second);
            log.info("Division: {} / {} = {}", first, second, result);
        } catch (ArithmeticException e) {
            exception = e;
            log.warn("Division by zero attempted: {} / {}", first, second);
        }
    }

    @Then("the result should be {int}")
    public void theResultShouldBe(int expected) {
        assertThat(result, equalTo(expected));
        log.info("Assertion passed: result = {}", result);
    }

    @Then("an ArithmeticException should be thrown")
    public void anArithmeticExceptionShouldBeThrown() {
        assertThat(exception instanceof ArithmeticException, equalTo(true));
        log.info("ArithmeticException caught: {}", exception.getMessage());
    }
}
