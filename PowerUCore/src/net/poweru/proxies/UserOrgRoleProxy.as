package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.UserOrgRoleManagerDelegate;

	public class UserOrgRoleProxy extends BaseProxy
	{
		public static const NAME:String = 'UserOrgRoleProxy';
		public static const FIELDS:Array = ['organization', 'owner', 'role', 'title', 'persistent'];
		
		public function UserOrgRoleProxy()
		{
			super(NAME, UserOrgRoleManagerDelegate, NotificationNames.UPDATEUSERORGROLES, FIELDS);
			init();
		}
		
		private function init():void
		{
			createArgNamesInOrder = ['organization', 'role'];
			createOptionalArgNames = ['owner', 'title', 'persistent'];
		}
	}
}