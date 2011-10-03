package net.poweru.delegates
{
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	
	public class SessionUserRoleRequirementManagerDelegate extends BaseDelegate
	{
		public function SessionUserRoleRequirementManagerDelegate(responder:IResponder)
		{
			super(responder, 'SessionUserRoleRequirementManager');
			getFilteredMethodName = 'surr_view';
		}
	}
}