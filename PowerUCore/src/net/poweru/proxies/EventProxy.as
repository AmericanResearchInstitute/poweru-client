package net.poweru.proxies
{
	import mx.automation.events.EventDetails;
	
	import net.poweru.NotificationNames;
	import net.poweru.delegates.EventManagerDelegate;
	import net.poweru.utils.PowerUResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class EventProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'EventProxy';
		public static const FIELDS:Array = ['title', 'name', 'lead_time', 'description', 'start', 'end', 'sessions'];
		
		public function EventProxy()
		{
			super(NAME, EventManagerDelegate, NotificationNames.UPDATEEVENTS, FIELDS);
			dateTimeFields = [
				'start',
				'end'
			];
			createArgNamesInOrder = ['name', 'title', 'description', 'start', 'end', 'organization'];
			createOptionalArgNames = ['lead_time'];
		}
	}
}