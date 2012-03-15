package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.GroupManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class GroupProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'GroupProxy';
		public static const FIELDS:Array = ['name'];
		
		public function GroupProxy()
		{
			super(NAME, GroupManagerDelegate, NotificationNames.UPDATEGROUPS, FIELDS, 'Group');
		}
	}
}