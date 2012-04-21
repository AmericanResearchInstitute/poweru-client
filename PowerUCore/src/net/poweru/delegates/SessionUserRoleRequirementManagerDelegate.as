package net.poweru.delegates
{
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	
	public class SessionUserRoleRequirementManagerDelegate extends BaseDelegate
	{
		public function SessionUserRoleRequirementManagerDelegate(responder:IResponder)
		{
			super(responder, 'SessionUserRoleRequirementManager');
			init();
		}
		
		private function init():void
		{
			getFilteredMethodName = 'surr_view';
			mangleMap = {
				'session' : mangleForeignKey,
				'session_user_role' : mangleForeignKey
			};
		}
	}
}