package net.poweru.presenters
{
	import mx.events.FlexEvent;
	
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
				case NotificationNames.SHOWDIALOG:
					if (notification.getBody()[0] == Places.CHOOSEORGANIZATION)
						populate();
					break;
				
				// Happens when we save an org, and indicates that we should just refresh the view
				case NotificationNames.UPDATEORGANIZATIONS:
					// constructor of HierarchicalDataSet rearranges the data into tree form
					chooser.populate(new HierarchicalDataSet((notification.getBody() as DataSet).toArray()).toArray());
					break;
			}
		}
		
		override protected function populate():void
		{
			primaryProxy.getAll(['name', 'parent']);
		}
		
	}
}