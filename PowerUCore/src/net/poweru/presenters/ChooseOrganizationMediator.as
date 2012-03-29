package net.poweru.presenters
{
	import mx.events.FlexEvent;
	import mx.utils.ObjectUtil;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.dialogs.choosers.interfaces.IChooser;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.model.HierarchicalDataSet;
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
					chooser.populate(ObjectUtil.copy(primaryProxy.dataSet.toArray()) as Array);
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
		
	}
}