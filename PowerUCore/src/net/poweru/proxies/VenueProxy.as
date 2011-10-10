package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.VenueManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class VenueProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'VenueProxy';
		public static const FIELDS:Array = ['address', 'contact', 'hours_of_operation', 'name', 'phone', 'rooms'];
		
		public function VenueProxy()
		{
			super(NAME, VenueManagerDelegate, NotificationNames.UPDATEVENUES, FIELDS, 'Venue');
			createArgNamesInOrder = ['name', 'phone', 'region'];
			createOptionalArgNames = ['address', 'contact', 'hours_of_operation'];
		}
	}
}