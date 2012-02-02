package net.poweru.delegates
{
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	
	public class AssignmentManagerDelegate extends BaseDelegate
	{
		public function AssignmentManagerDelegate(responder:IResponder)
		{
			super(responder, 'AssignmentManager');
			getFilteredMethodName = 'detailed_view';
		}
		
		public function bulkCreate(authToken:String, taskID:Number, userIDs:Array):AsyncToken
		{
			var token:AsyncToken = remoteObject.getOperation('bulk_create').send(authToken, taskID, userIDs);
			token.addResponder(responder);
			return token;
		}
	}
}