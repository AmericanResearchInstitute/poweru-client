package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.OrganizationManagerDelegate;
	import net.poweru.model.HierarchicalDataSet;
	import net.poweru.utils.PowerUResponder;
	
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	
	import org.puremvc.as3.interfaces.IProxy;

	public class AdminOrganizationViewProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'AdminOrganizationViewProxy';
		
		public function AdminOrganizationViewProxy()
		{
			super(NAME, OrganizationManagerDelegate, NotificationNames.UPDATEORGANIZATIONS);
		}
		
		public function adminOrganizationsView():void
		{
			new OrganizationManagerDelegate(new PowerUResponder(onAdminOrganizationsViewSuccess, onAdminOrganizationsViewError, onFault)).adminOrganizationsView(loginProxy.authToken);
		}
		
		public function adminOrganizationUsersView(org:Number):void
		{
			new OrganizationManagerDelegate(new PowerUResponder(onAdminOrganizationUsersViewSuccess, onAdminOrganizationUsersViewError, onFault)).adminOrganizationUsersView(loginProxy.authToken, org);
		}
		
		// Result handlers
		
		protected function onAdminOrganizationsViewSuccess(event:ResultEvent):void
		{
			data = new HierarchicalDataSet(event.result.value);
			sendNotification(NotificationNames.UPDATEADMINORGANIZATIONSVIEW, ObjectUtil.copy(dataSet.toArray()));
		}
		
		protected function onAdminOrganizationsViewError(event:ResultEvent):void
		{
			trace('admin organizations view error');
		}
		
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