package net.poweru.proxies
{
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	
	import net.poweru.Constants;
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
			createOptionalArgNames = ['parent'];
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
	}
}