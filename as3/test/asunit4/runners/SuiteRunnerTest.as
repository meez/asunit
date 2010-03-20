package asunit4.runners {

	import asunit.framework.TestCase;

	import asunit4.framework.Result;
	import asunit4.support.DoubleFailSuite;
    import asunit4.support.InjectionVerification;

	import flash.events.Event;

	public class SuiteRunnerTest extends TestCase {

		private var runnerResult:Result;
		private var suiteRunner:SuiteRunner;

		public function SuiteRunnerTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
            super.setUp();
			suiteRunner = new SuiteRunner();
			runnerResult = new Result();
		}

		protected override function tearDown():void {
            super.tearDown();
			suiteRunner = null;
			runnerResult = null;
		}
		
		public function testRunTriggersCompleteEvent():void {
			suiteRunner.addEventListener(Event.COMPLETE, addAsync(checkResultWasNotSuccessful, 500));
			suiteRunner.run(DoubleFailSuite, runnerResult);
		}
        
		private function checkResultWasNotSuccessful(event:Event):void {
			assertFalse(runnerResult.wasSuccessful);
		}

        public function testCanHandATestToSuiteRunner():void {
            suiteRunner.run(InjectionVerification, runnerResult);
            assertFalse(runnerResult.wasSuccessful);
        }
	}
}

