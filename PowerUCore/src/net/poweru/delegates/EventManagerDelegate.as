package net.poweru.delegates
{
	import mx.rpc.IResponder;
	
	public class EventManagerDelegate extends BaseDelegate
	{
		public function EventManagerDelegate(responder:IResponder)
		{
			super(responder, 'EventManager');
			mangleMap = {
				'start' : mangleDate,
				'end' : mangleDate
			};
		}
	}
}