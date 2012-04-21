package net.poweru.proxies
{
	import mx.rpc.events.ResultEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.delegates.ExamSessionManagerDelegate;
	import net.poweru.utils.PowerUResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class ExamSessionProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'ExamSessionProxy';
		public static const FIELDS:Array = ['exam', 'passing_score', 'passed', 'score', 'response_questions'];
		
		// number of responses to addResponse() calls that we are still waiting to receive.
		protected var responseResponsesOutstanding:Number = 0;
		protected var currentAssignment:Number;
		
		public function ExamSessionProxy()
		{
			super(NAME, ExamSessionManagerDelegate, NotificationNames.UPDATEEXAMSESSIONS, FIELDS, 'ExamSession', []);
			init();
		}
		
		private function init():void
		{
			createArgNamesInOrder = ['assignment', 'fetch_all', 'resume'];
		}
		
		override public function create(argDict:Object, batchID:String=null):void
		{
			currentAssignment = argDict['assignment'];
			super.create(argDict, batchID);
		}
		
		public function addResponse(examSessionID:Number, questionID:Number, optionalParameters:Object):void
		{
			responseResponsesOutstanding += 1;
			new ExamSessionManagerDelegate(new PowerUResponder(onAddResponseSuccess, onAddResponseError, onFault)).addResponse(loginProxy.authToken, examSessionID, questionID, optionalParameters);
		}
		
		public function finish(examSessionID:Number):void
		{
			new ExamSessionManagerDelegate(new PowerUResponder(onFinishSuccess, onFinishError, onFault)).finish(loginProxy.authToken, examSessionID);
		}
		
		public function resume(examSessionID:Number):void
		{
			new ExamSessionManagerDelegate(new PowerUResponder(onResumeSuccess, onResumeError, onFault)).resume(loginProxy.authToken, examSessionID);
		}
		
		protected function onFinishSuccess(event:ResultEvent):void
		{
			sendNotification(NotificationNames.EXAMSESSIONFINISHED, event.result.value);
		}
		
		protected function onFinishError(event:ResultEvent):void
		{
			trace(NAME + ' error calling finish()');
		}
		
		protected function onResumeSuccess(event:ResultEvent):void
		{
			sendNotification(NotificationNames.EXAMSESSIONFINISHED, event.result.value);
		}
		
		protected function onResumeError(event:ResultEvent):void
		{
			trace(NAME + ' error calling finish()');
		}
		
		protected function onAddResponseSuccess(event:ResultEvent):void
		{
			if (responseResponsesOutstanding > 0)
				responseResponsesOutstanding -= 1;
			if (responseResponsesOutstanding == 0)
				sendNotification(NotificationNames.SHOWDIALOG, [Places.ADMINISTEREXAMSESSION, currentAssignment]);
			
			sendNotification(NotificationNames.EXAMRESPONSEADDED, event.result.value);
		}
		
		protected function onAddResponseError(event:ResultEvent):void
		{
			trace(NAME + ' error calling addResponse()');
		}
		
		override protected function onCreateSuccess(data:ResultEvent):void
		{
			var questionPools:Array = data.result.value.question_pools as Array;
			// more questions to answer
			if (questionPools != null && questionPools.length > 0)
				sendNotification(NotificationNames.EXAMSESSIONCREATED, data.result.value);
			// done answering questions
			else
				finish(data.result.value.id);
		}
	}
}