package net.poweru.delegates
{
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.remoting.RemoteObject;
	
	import net.poweru.utils.RemoteObjectFactory;
	
	public class UtilsManagerDelegate
	{
		protected var responder:IResponder;
		protected var remoteObject:RemoteObject;
		
		public function UtilsManagerDelegate(responder:IResponder)
		{
			init(responder);
		}
		
		private function init(responder:IResponder):void
		{
			this.responder = responder;
			remoteObject = RemoteObjectFactory.getInstance().getRemoteObject('UtilsManager');
		}
		
		public function getChoices(modelName:String, attributeName:String):AsyncToken
		{
			var token:AsyncToken = remoteObject.getOperation('get_choices').send(modelName, attributeName);
			token.addResponder(responder);
			return token;
		}

	}
}