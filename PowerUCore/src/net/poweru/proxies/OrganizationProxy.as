package net.poweru.proxies
{
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	
	import net.poweru.NotificationNames;
	import net.poweru.delegates.OrganizationManagerDelegate;
	import net.poweru.model.DataSet;
	import net.poweru.model.HierarchicalDataSet;
	import net.poweru.utils.PowerUResponder;
	
	import org.puremvc.as3.interfaces.IProxy;

	public class OrganizationProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'OrganizationProxy';
		public static const FIELDS:Array = ['name', 'parent'];

		public function OrganizationProxy()
		{
			super(NAME, OrganizationManagerDelegate, NotificationNames.UPDATEORGANIZATIONS, FIELDS);
			createArgNamesInOrder = ['name'];
		}
	}
}