package net.poweru.delegates
{
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;

	public class GroupManagerDelegate extends BaseDelegate
	{
		public function GroupManagerDelegate(responder:IResponder)
		{
			super(responder, 'GroupManager');
		}
		
		public function vodAdminGroupsView(authToken:String):void
		{
			var token:AsyncToken = remoteObject.getOperation('vod_admin_groups_view').send(authToken);
			token.addResponder(responder);
		}
		
	}
}