package net.poweru.proxies
{
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	
	import net.poweru.NotificationNames;
	import net.poweru.delegates.UserManagerDelegate;
	import net.poweru.model.DataSet;
	import net.poweru.utils.PowerUResponder;
	
	import org.puremvc.as3.interfaces.IProxy;

	public class UserProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'UserProxy';
		public static const FIELDS:Array = ['first_name', 'last_name', 'email', 'status', 'alleged_organization'];
		
		public function UserProxy()
		{
			super(NAME, UserManagerDelegate, NotificationNames.UPDATEUSERS, FIELDS, 'User', ['status']);
			createArgNamesInOrder = ['username', 'password', 'title', 'first_name', 'last_name', 'phone', 'email', 'status'];
			createOptionalArgNames = [];
		}
		
		public function getUsersByGroupName(name:String):void
		{
			new UserManagerDelegate(new PowerUResponder(onGetUsersByGroupNameSuccess, onGetUsersByGroupNameError, onFault)).getUsersByGroupName(loginProxy.authToken, name, ['title', 'first_name', 'last_name', 'phone', 'email']);
		}
		
		override public function save(data:Object, oldItem:Object=null):void
		{
			// Make sure current user is in the cache, which might not be the case
			// especially if the current user is not an admin, and thus has not
			// fetched a list of users.
			if (data['id'] == loginProxy.userPK)
				this.dataSet.addOrReplace(loginProxy.currentUser);
			super.save(data, oldItem);
		}
		
		public function changePassword(userId:Number, password:String, oldPassword:String):void
		{
			new UserManagerDelegate(new PowerUResponder(onPasswordChangeSuccess, onPasswordChangeFailure, onFault)).changePassword(loginProxy.authToken, userId, password, oldPassword);
		}
		
		
		// event handlers
		
		protected function onPasswordChangeSuccess(event:ResultEvent):void
		{
			sendNotification(NotificationNames.PASSWORDCHANGESUCCESS);
		}
		
		protected function onPasswordChangeFailure(event:ResultEvent):void
		{
			trace('password change failure');
		}
		
		protected function onGetUsersByGroupNameSuccess(event:ResultEvent):void
		{
			sendNotification(NotificationNames.USERSBYGROUPNAME, [event.token.groupName, new DataSet(event.result.value)]);
		}
		
		protected function onGetUsersByGroupNameError(event:ResultEvent):void
		{
			trace('error getting users by group name');
		}
		
		override protected function onCreateSuccess(data:ResultEvent):void
		{
			super.onCreateSuccess(data);
			sendNotification(NotificationNames.CREATEUSERSUCCESS, data.result['value']);
		}
		
		override protected function onCreateError(data:ResultEvent):void
		{
			if (data.result['error'][0] == 23 && (loginProxy.authToken == null || loginProxy.authToken == ''))
				sendNotification(NotificationNames.CREATEUSERPERMISSIONDENIED);
			else
				super.onCreateError(data);
		}
	}
}