package net.poweru.proxies
{
	import mx.utils.ObjectUtil;
	
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
			createOptionalArgNames = ['organizations'];
		}
		
		public function sendEmail(users:Array, subject:String, body:String):void
		{
			new UserManagerDelegate(new PowerUResponder(onSendEmailSuccess, onSendEmailError, onFault)).sendEmail(loginProxy.authToken, users, subject, body);
		}
		
		override protected function applyStateFilters(filter:Object):Object
		{
			var ret:Object = {};
			
			switch (loginProxy.applicationState)
			{
				case StateNames.OWNERMANAGER:
				case StateNames.ORG_ADMIN:
					var filterA:Object = ObjectUtil.copy(filter);
					var filterB:Object = ObjectUtil.copy(filter);
					
					if (!filterA.hasOwnProperty('member'))
						filterA['member'] = {};
					filterA['member'] = {'organizations' : loginProxy.associatedOrgs};
					
					if (!filterB.hasOwnProperty('isnull'))
						filterB['isnull'] = {};
					filterB['isnull'] = {'organizations' : true};
					
					ret['or'] = [filterA, filterB];
					break;
				
				default:
					ret = filter;
					break;
			}
			
			return ret;
		}
	}
}