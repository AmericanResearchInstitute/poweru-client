package net.poweru.presenters
{
	import mx.utils.ObjectUtil;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.proxies.LoginProxy;
	import net.poweru.proxies.OrganizationProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class ChooseOrganizationMediator extends BaseChooserMediator implements IMediator
	{
		public static const NAME:String = 'ChooseOrganizationMediator';
		
		public function ChooseOrganizationMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, Places.CHOOSEORGANIZATION, NotificationNames.UPDATEORGANIZATIONS, OrganizationProxy);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.UPDATEORGANIZATIONS:
					// constructor of HierarchicalDataSet rearranges the data into tree form
					var data:Array = ObjectUtil.copy(primaryProxy.dataSet.toArray()) as Array;
					if (LoginProxy.ORG_BASED_STATES.indexOf(loginProxy.applicationState) != -1)
					{
						data = data.filter(filterForOrgScopedRoles);
						for each (var item:Object in data)
							if (item.id == loginProxy.activeUserOrgRole.organization)
								item.parent = null;
					}
					chooser.populate(data);
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		override protected function populate():void
		{
			super.populate();
			primaryProxy.getAll();
		}
		
		protected function filterForOrgScopedRoles(item:*, index:int, array:Array):Boolean
		{
			return (loginProxy.associatedOrgs.indexOf(item.id) != -1);
		}
		
	}
}