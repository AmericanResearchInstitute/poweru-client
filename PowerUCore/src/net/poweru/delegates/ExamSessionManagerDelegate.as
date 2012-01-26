package net.poweru.delegates
{
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	
	public class ExamSessionManagerDelegate extends BaseDelegate
	{
		public function ExamSessionManagerDelegate(responder:IResponder)
		{
			super(responder, 'ExamSessionManager');
		}
		
		public function addResponse(authToken:String, examSessionID:Number, questionID:Number, optionalParameters:Object):AsyncToken
		{
			var token:AsyncToken = remoteObject.getOperation('add_response').send(authToken, examSessionID, questionID, optionalParameters);
			token.addResponder(responder);
			return token;
		}
		
		public function finish(authToken:String, examSessionID:Number):AsyncToken
		{
			var token:AsyncToken = remoteObject.getOperation('finish').send(authToken, examSessionID);
			token.addResponder(responder);
			return token;
		}
		
		public function resume(authToken:String, examSessionID:Number):AsyncToken
		{
			var token:AsyncToken = remoteObject.getOperation('resume').send(authToken, examSessionID);
			token.addResponder(responder);
			return token;
		}
	}
}