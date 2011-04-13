package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.GroupManagerDelegate;
	import net.poweru.model.DataSet;
	import net.poweru.utils.PowerUResponder;
	
	import mx.rpc.events.ResultEvent;
	
	import org.puremvc.as3.interfaces.IProxy;

	public class GroupProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'GroupProxy';
		public static const SUPERADMINGROUP:String = 'Super Administrators';
		public static const CATEGORYMANAGERGROUP:String = 'Category Managers';
		public static const STUDENTGROUP:String = 'Students';
		protected static var SYSTEMGROUPNAMES:Array = [SUPERADMINGROUP, CATEGORYMANAGERGROUP, STUDENTGROUP];
		
		protected var systemGroups:DataSet;
		
		public function GroupProxy()
		{
			super(NAME, GroupManagerDelegate, NotificationNames.UPDATEGROUPS);
		}
		
		override public function create(argDict:Object):void
		{
			var argNamesInOrder:Array = ['name'];
			var args:Array = [loginProxy.authToken];
			for each (var argName:String in argNamesInOrder)
			{
				args.push(argDict[argName]);
			}
			
			new primaryDelegateClass(new PowerUResponder(onCreateSuccess, onCreateError, onFault)).create.apply(this, args);
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