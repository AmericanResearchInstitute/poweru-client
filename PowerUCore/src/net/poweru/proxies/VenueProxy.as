package net.poweru.proxies
{
	import mx.rpc.AsyncToken;
	
	import net.poweru.NotificationNames;
	import net.poweru.delegates.VenueManagerDelegate;
	import net.poweru.utils.PowerUResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class VenueProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'VenueProxy';
		public static const FIELDS:Array = ['address', 'blackout_periods', 'contact', 'hours_of_operation', 'name', 'phone', 'rooms'];
		
		public function VenueProxy()
		{
			super(NAME, VenueManagerDelegate, NotificationNames.UPDATEVENUES, FIELDS, 'Venue');
			init();
		}
		
		private function init():void
		{
			createArgNamesInOrder = ['name', 'phone', 'region'];
			createOptionalArgNames = ['address', 'contact', 'hours_of_operation'];
		}
		
		public function getAvailableVenues(start:Date, end:Date):void
		{
			var token:AsyncToken = new VenueManagerDelegate(new PowerUResponder(onGetFilteredSuccess, onGetFilteredError, onFault)).getAvailableVenues(loginProxy.authToken, start, end, FIELDS);
			token['filters'] = {};
		}
	}
}