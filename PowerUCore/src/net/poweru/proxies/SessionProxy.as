package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.SessionManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class SessionProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'SessionProxy';
		public static const FIELDS:Array = ['start', 'end', 'status', 'confirmed', 'event', 'name', 'title', 'url', 'description'];
		
		public function SessionProxy()
		{
			super(NAME, SessionManagerDelegate, NotificationNames.UPDATESESSIONS, FIELDS, 'Session');
			createArgNamesInOrder = ['start', 'end', 'status', 'confirmed', 'default_price', 'event'];
			createOptionalArgNames = ['name', 'title', 'url', 'description'];
			dateTimeFields = ['start', 'end'];
		}
	}
}