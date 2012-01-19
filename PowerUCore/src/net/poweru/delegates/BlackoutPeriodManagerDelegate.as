package net.poweru.delegates
{
	import mx.rpc.IResponder;
	
	public class BlackoutPeriodManagerDelegate extends BaseDelegate
	{
		public function BlackoutPeriodManagerDelegate(responder:IResponder)
		{
			super(responder, 'BlackoutPeriodManager');
			mangleMap = {
				'start' : mangleDate,
				'end' : mangleDate
			};
		}
	}
}