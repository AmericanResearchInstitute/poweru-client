package net.poweru.delegates
{
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	
	public class ExamManagerDelegate extends BaseDelegate
	{
		public function ExamManagerDelegate(responder:IResponder)
		{
			super(responder, 'ExamManager');
		}
		
		public function createFromXML(authToken:String, xml:String):AsyncToken
		{
			var token:AsyncToken = remoteObject.getOperation('create_from_xml').send(authToken, xml);
			token.addResponder(responder);
			return token;
		}
	}
}