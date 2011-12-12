package net.poweru.delegates
{
	import mx.rpc.IResponder;
	
	public class AchievementManagerDelegate extends BaseDelegate
	{
		public function AchievementManagerDelegate(responder:IResponder)
		{
			super(responder, 'AchievementManager');
		}
	}
}