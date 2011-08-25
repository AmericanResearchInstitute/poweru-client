package net.poweru.delegates
{
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;

	public class CurriculumManagerDelegate extends BaseDelegate
	{
		public function CurriculumManagerDelegate(responder:IResponder)
		{
			super(responder, 'CurriculumManager');
		}
		
		public function adminCurriculumsView(authToken:String):void
		{
			var token:AsyncToken = remoteObject.getOperation('admin_curriculums_view').send(authToken);
			token.addResponder(responder);
		}
		
	}
}