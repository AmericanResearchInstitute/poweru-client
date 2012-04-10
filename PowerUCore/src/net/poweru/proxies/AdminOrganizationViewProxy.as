package net.poweru.proxies
{
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	
	import net.poweru.Constants;
	import net.poweru.NotificationNames;
	import net.poweru.delegates.OrganizationManagerDelegate;
	import net.poweru.model.HierarchicalDataSet;
	import net.poweru.utils.PowerUResponder;
	
	import org.puremvc.as3.interfaces.IProxy;

	public class AdminOrganizationViewProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'AdminOrganizationViewProxy';
		public static const FIELDS:Array = [];
		
		public function AdminOrganizationViewProxy()
		{
			super(NAME, OrganizationManagerDelegate, NotificationNames.UPDATEADMINORGANIZATIONSVIEW, FIELDS);
			getFilteredMethodName = 'admin_org_view';
		}
		
		override protected function markIfNotEditable(item:Object):void
		{
			// First see if the user is logged in as an org-dependent role
			if (LoginProxy.ORG_BASED_STATES.indexOf(loginProxy.applicationState) != -1)
			{
				var orgID:Number = item.id as Number;
				if (loginProxy.associatedOrgs.indexOf(orgID) == -1)
					item[Constants.NOT_EDITABLE_FIELD_NAME] = true;
			}
		}
		
		public function adminOrganizationUsersView(org:Number):void
		{
			new OrganizationManagerDelegate(new PowerUResponder(onAdminOrganizationUsersViewSuccess, onAdminOrganizationUsersViewError, onFault)).adminOrganizationUsersView(loginProxy.authToken, org);
		}
		
		// Result handlers
		
		protected function onAdminOrganizationUsersViewSuccess(event:ResultEvent):void
		{
			sendNotification(NotificationNames.ADMINORGANIZATIONUSERSVIEW, [event.token['org'], event.result.value]);
		}
		
		protected function onAdminOrganizationUsersViewError(event:ResultEvent):void
		{
			trace('admin organization users view error');
		}
	}
}