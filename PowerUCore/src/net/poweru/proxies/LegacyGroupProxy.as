package net.poweru.proxies
{
	import mx.rpc.events.ResultEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.delegates.GroupManagerDelegate;
	import net.poweru.model.DataSet;
	import net.poweru.utils.PowerUResponder;
	
	import org.puremvc.as3.interfaces.IProxy;

	public class LegacyGroupProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'LegacyGroupProxy';
		public static const FIELDS:Array = ['name'];
		
		public static const SUPERADMINGROUP:String = 'Super Administrators';
		public static const CATEGORYMANAGERGROUP:String = 'Category Managers';
		public static const STUDENTGROUP:String = 'Students';
		protected static var SYSTEMGROUPNAMES:Array = [SUPERADMINGROUP, CATEGORYMANAGERGROUP, STUDENTGROUP];
		
		protected var systemGroups:DataSet;
		
		public function LegacyGroupProxy()
		{
			super(NAME, GroupManagerDelegate, NotificationNames.UPDATELEGACYGROUPS, FIELDS);
			createArgNamesInOrder = ['name'];
		}
		
		public function vodAdminGroupsView():void
		{
			new GroupManagerDelegate(new PowerUResponder(onVodAdminGroupsViewSuccess, onVodAdminGroupsViewError, onFault)).vodAdminGroupsView(loginProxy.authToken);
		}
		
		
		// Result handlers
		
		protected function onVodAdminGroupsViewSuccess(event:ResultEvent):void
		{
			data = new DataSet(event.result.value);
			sendNotification(NotificationNames.UPDATEVODADMINGROUPSVIEW, event.result.value);
		}
		
		protected function onVodAdminGroupsViewError(event:ResultEvent):void
		{
			
		}
		
		override protected function onCreateSuccess(data:ResultEvent):void
		{
			vodAdminGroupsView();
		}
		
	}
}