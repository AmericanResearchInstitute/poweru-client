package net.poweru.proxies
{
	import mx.rpc.events.ResultEvent;
	import mx.utils.UIDUtil;
	
	import net.poweru.NotificationNames;
	import net.poweru.delegates.CredentialManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class CredentialProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'CredentialProxy';
		public static const FIELDS:Array = ['user', 'credential_type', 'date_expires', 'status'];
		
		protected var userProxy:AdminUsersViewProxy;
		
		public function CredentialProxy()
		{
			super(NAME, CredentialManagerDelegate, NotificationNames.UPDATECREDENTIALS, FIELDS, 'Credential');
			userProxy = getProxy(AdminUsersViewProxy) as AdminUsersViewProxy;
			createArgNamesInOrder = ['user', 'credential_type'];
			createOptionalArgNames = ['date_expires', 'status'];
			dateTimeFields = ['date_expires'];
			getFilteredMethodName = 'detail_view';
		}
		
		/*	When saving a credential, there is probably an EditUser dialog open.
			We should refresh the data in that dialog by fetching the user
			object.
		*/
		override protected function onSaveSuccess(data:ResultEvent):void
		{
			super.onSaveSuccess(data);
			var userID:Number = data.token['updatedItem']['user']['id'];
			userProxy.getOne(userID);
		}
	}
}