package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.BlackoutPeriodManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class BlackoutPeriodProxy extends BaseCollectionCachingProxy implements IProxy
	{
		public static const NAME:String = 'BlackoutPeriodProxy';
		public static const FIELDS:Array = ['description', 'end', 'start', 'venue'];
		
		public function BlackoutPeriodProxy()
		{
			super(NAME, BlackoutPeriodManagerDelegate, NotificationNames.UPDATEBLACKOUTPERIODS, FIELDS, 'venue', 'BlackoutPeriod');
			init();
		}
		
		private function init():void
		{
			createArgNamesInOrder = ['venue', 'start', 'end', 'description'];
			dateTimeFields = ['start', 'end'];
		}
	}
}