package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.EventManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class EventProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'EventProxy';
		
		public function EventProxy()
		{
			super(NAME, EventManagerDelegate, NotificationNames.UPDATEEVENTS, []);
			init();
		}
		
		private function init():void
		{
			dateTimeFields = [
				'start',
				'end'
			];
			createArgNamesInOrder = ['name', 'title', 'description', 'start', 'end', 'organization'];
			createOptionalArgNames = ['lead_time', 'sessions'];
			getFilteredMethodName = 'detail_view';
		}
	}
}