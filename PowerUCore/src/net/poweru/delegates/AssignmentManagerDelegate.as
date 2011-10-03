package net.poweru.delegates
{
	import mx.rpc.IResponder;
	
	public class AssignmentManagerDelegate extends BaseDelegate
	{
		public function AssignmentManagerDelegate(responder:IResponder)
		{
			super(responder, 'AssignmentManager');
			getFilteredMethodName = 'detailed_user_view';
		}
	}
}