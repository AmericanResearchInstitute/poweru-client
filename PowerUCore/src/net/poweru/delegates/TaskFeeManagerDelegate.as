package net.poweru.delegates
{
	import mx.rpc.IResponder;
	
	public class TaskFeeManagerDelegate extends BaseDelegate
	{
		public function TaskFeeManagerDelegate(responder:IResponder)
		{
			super(responder, 'TaskFeeManager');
		}
	}
}