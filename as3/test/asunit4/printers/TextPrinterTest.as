package asunit4.printers {
    
    import asunit.framework.Test;
    import asunit.framework.TestCase;
    import asunit4.framework.ITestSuccess;
    import asunit4.framework.TestSuccess;
    import asunit.framework.ITestFailure;
    import asunit4.framework.TestFailure;
    import asunit4.framework.IResult;
    import asunit4.framework.Result;

    public class TextPrinterTest extends TestCase {

        private var printer:FakeTextPrinter;
        private var test:Test;
        private var success:ITestSuccess;
        private var failure:ITestFailure;
        private var testResult:IResult;

        public function TextPrinterTest(method:String=null) {
            super(method);
        }

        override protected function setUp():void {
            super.setUp();
            printer    = new FakeTextPrinter();
            printer.backgroundColor = 0xffcc00;
            printer.textColor = 0x000000;

            testResult = new Result();
            test       = new TestCase();
            failure    = new TestFailure(test, 'testSomethingThatFails', new Error('Fake Failure'));
            success    = new TestSuccess(test, 'testSomethingThatSucceeds');
            testResult.addListener(printer);
        }

        override protected function tearDown():void {
            super.tearDown();
            removeChild(printer);
            failure    = null;
            printer    = null;
            testResult = null;
            success    = null;
            test       = null;
        }

        private function executeASucceedingTest():void {
            testResult.onRunStarted();
            testResult.onTestStarted(test);
            testResult.onTestSuccess(success);
            testResult.onTestCompleted(test);
            testResult.onRunCompleted(null);
        }

        private function executeAFailingTest():void {
            testResult.onRunStarted();
            testResult.onTestStarted(test);
            testResult.onTestFailure(failure);
            testResult.onTestCompleted(test);
            testResult.onRunCompleted(null);
        }

        public function testPrinterOnTestSuccess():void {
            executeASucceedingTest();
            var actual:String = printer.toString();
            assertTrue("Printer should print OK", actual.indexOf('OK') > -1);
            assertTrue("Printer should include Test count: ", actual.match(/\nOK \(1 test\)/));
        }

        public function testPrinterFailure():void {
            executeAFailingTest();
            var expected:String = "testSomethingThatFails : Error: Fake Failure";
            var actual:String = printer.toString();
            assertTrue("Printer should fail", actual.indexOf(expected) > -1);
            assertTrue("Printer should include Test Duration: ", actual.match(/\nTotal Time: \d/));
        }

        public function testPrinterWithNoTests():void {
            testResult.onRunStarted();
            testResult.onRunCompleted(null);
            assertTrue("Printer should include Warning for no tests", printer.toString().indexOf("[WARNING]") > -1);
        }

        public function testPrinterDisplayed():void {
            addChild(printer);
            executeASucceedingTest();
            assertTrue("The output was displayed.", printer.getTextDisplay().text.indexOf('Time Summary:') > -1);
        }
    }
}

import asunit4.printers.TextPrinter;
import flash.text.TextField;

class FakeTextPrinter extends TextPrinter {

    // Prevent the printer from tracing results:
    override protected function logResult():void {
    }

    public function getTextDisplay():TextField {
        return textDisplay;
    }
}

