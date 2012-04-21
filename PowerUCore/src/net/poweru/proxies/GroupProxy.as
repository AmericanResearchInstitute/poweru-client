package net.poweru.proxies
{
	import mx.rpc.events.ResultEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.StateNames;
	import net.poweru.delegates.GroupManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class GroupProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'GroupProxy';
		public static const FIELDS:Array = ['name'];
		
		public static const SUPERADMINGROUP:String = 'Super Administrators';
		public static const CATEGORYMANAGERGROUP:String = 'Category Managers';
		public static const STUDENTGROUP:String = 'Students';
		
		public function GroupProxy()
		{
			super(NAME, GroupManagerDelegate, NotificationNames.UPDATEGROUPS, FIELDS, 'Group');
			init();
		}
		
		private function init():void
		{
			createArgNamesInOrder = ['name'];
		}
		
		// Make sure the super user group isn't visible to non-superusers
		override protected function onGetFilteredSuccess(data:ResultEvent):void
		{
			if (loginProxy.applicationState != StateNames.SUPERADMIN)
			{
				var value:Array = data.result.value as Array;
				data.result.value = value.filter(filterSuperUserGroup);
			}
			super.onGetFilteredSuccess(data);
		}
		
		protected function filterSuperUserGroup(item:*, index:int, array:Array):Boolean
		{
			return !(item.hasOwnProperty('name') && item.name == SUPERADMINGROUP);
		}
	}
}