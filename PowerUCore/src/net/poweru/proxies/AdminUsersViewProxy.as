package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.StateNames;
	import net.poweru.delegates.UserManagerDelegate;
	import net.poweru.utils.PowerUResponder;
	
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
		
		public function sendEmail(users:Array, subject:String, body:String):void
		{
			new UserManagerDelegate(new PowerUResponder(onSendEmailSuccess, onSendEmailError, onFault)).sendEmail(loginProxy.authToken, users, subject, body);
		}
		
		override protected function applyStateFilters(filter:Object):Object
		{
			switch (loginProxy.applicationState)
			{
				case StateNames.OWNERMANAGER:
					if (!filter.hasOwnProperty('member'))
						filter['member'] = {};
					filter['member']['organizations'] = loginProxy.associatedOrgs;
			}
			
			return filter;
		}
	}
}