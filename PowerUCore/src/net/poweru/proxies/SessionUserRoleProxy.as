package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.SessionUserRoleManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class SessionUserRoleProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'SessionUserRoleProxy';
		public static const FIELDS:Array = ['name'];
		
		public function SessionUserRoleProxy()
		{
			super(NAME, SessionUserRoleManagerDelegate, NotificationNames.UPDATESESSIONUSERROLES, FIELDS, 'SessionUserRole');
			init();
		}
		
		private function init():void
		{
			createArgNamesInOrder = ['name'];
		}
	}
}