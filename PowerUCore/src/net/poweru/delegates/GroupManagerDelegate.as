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
	}
}