package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.UserManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class AdminUsersViewProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'AdminUsersViewProxy';
		
		public function AdminUsersViewProxy()
		{
			super(NAME, UserManagerDelegate, NotificationNames.UPDATEADMINUSERSVIEW, [], 'User', ['status']);
			getFilteredMethodName = 'admin_users_view';
			createArgNamesInOrder = ['username', 'password', 'title', 'first_name', 'last_name', 'phone', 'email', 'status'];
			createOptionalArgNames = [];
		}
	}
}