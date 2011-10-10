package net.poweru.presenters
{
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.ICreateVenue;
	import net.poweru.model.DataSet;
	import net.poweru.proxies.RegionProxy;
	import net.poweru.proxies.VenueProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class CreateVenueMediator extends BaseCreateDialogMediator implements IMediator
	{
		public static const NAME:String = 'CreateVenueMediator';
		
		protected var regionProxy:RegionProxy;
		
		public function CreateVenueMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, VenueProxy);
			regionProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(RegionProxy) as RegionProxy;
		}
		
		protected function get createVenue():ICreateVenue
		{
			return viewComponent as ICreateVenue;
		}
		
		override public function listNotificationInterests():Array
		{
			var ret:Array = super.listNotificationInterests();
			ret.push(NotificationNames.DIALOGPRESENTED);
			ret.push(NotificationNames.UPDATEREGIONS);
			return ret;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.DIALOGPRESENTED:
					if (notification.getBody() == Places.CREATEVENUE)
						populate();
					break;
				
				/*	grab the first region we can find and use it. This system
					does not support the use of regions, but we must have at
					least one to satisfy the VenueManager.create() method. */
				case NotificationNames.UPDATEREGIONS:
					var regions:DataSet = notification.getBody() as DataSet;
					if (regions.length > 0)
						createVenue.setRegion(regions[0]);
					else
					{
						sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
						trace('no regions found! at least one is needed by ' + NAME);
						Alert.show('No regions found. Contact an administrator.', 'Region Not Found');
					}
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		override protected function populate():void
		{
			regionProxy.getAll();
		}
	}
}