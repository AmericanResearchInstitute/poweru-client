package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.RoomManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class RoomProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'RoomProxy';
		public static const FIELDS:Array = ['name', 'capacity', 'venue'];
		
		public function RoomProxy()
		{
			super(NAME, RoomManagerDelegate, NotificationNames.UPDATEROOMS, FIELDS, 'Room');
			createArgNamesInOrder = ['name', 'venue', 'capacity'];
		}
	}
}