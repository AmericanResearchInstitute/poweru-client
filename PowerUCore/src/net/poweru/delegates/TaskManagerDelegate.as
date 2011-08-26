package net.poweru.delegates
{
	import mx.rpc.IResponder;
	
	public class TaskManagerDelegate extends BaseDelegate
	{
		public function TaskManagerDelegate(responder:IResponder)
		{
			super(responder, 'TaskManager');
		}
	}
}