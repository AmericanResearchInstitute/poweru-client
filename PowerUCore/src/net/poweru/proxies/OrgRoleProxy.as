package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.OrgRoleManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;

	public class OrgRoleProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'OrgRoleProxy';
		
		public function OrgRoleProxy()
		{
			super(NAME, OrgRoleManagerDelegate, NotificationNames.UPDATEORGROLES);
		}
		
	}
}