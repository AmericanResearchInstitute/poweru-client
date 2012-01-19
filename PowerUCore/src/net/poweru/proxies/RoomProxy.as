package net.poweru.proxies
{
	import mx.rpc.AsyncToken;
	
	import net.poweru.NotificationNames;
	import net.poweru.delegates.RoomManagerDelegate;
	import net.poweru.utils.PowerUResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class RoomProxy extends BaseCollectionCachingProxy implements IProxy
	{
		public static const NAME:String = 'RoomProxy';
		public static const FIELDS:Array = ['name', 'capacity', 'venue'];
		
		public function RoomProxy()
		{
			super(NAME, RoomManagerDelegate, NotificationNames.UPDATEROOMS, FIELDS, 'venue', 'Room');
			createArgNamesInOrder = ['name', 'venue', 'capacity'];
		}
		
		public function getAvailableRooms(start:Date, end:Date, IDs:Array):void
		{
			var token:AsyncToken = new RoomManagerDelegate(new PowerUResponder(onGetFilteredSuccess, onGetFilteredError, onFault)).getAvailableRooms(loginProxy.authToken, start, end, IDs, FIELDS);
			token['filters'] = {};
		}
	}
}