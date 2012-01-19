package net.poweru.presenters
{
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.ICreateBlackoutPeriod;
	import net.poweru.placemanager.InitialDataProxy;
	import net.poweru.proxies.BlackoutPeriodProxy;
	import net.poweru.proxies.VenueProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class CreateBlackoutPeriodMediator extends BaseCreateDialogMediator implements IMediator
	{
		public static const NAME:String = 'CreateBlackoutPeriodMediator';
		
		protected var initialDataProxy:InitialDataProxy;
		protected var venueProxy:VenueProxy;
		
		public function CreateBlackoutPeriodMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, BlackoutPeriodProxy);
			initialDataProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(InitialDataProxy) as InitialDataProxy;
			venueProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(VenueProxy) as VenueProxy;
		}
		
		override public function listNotificationInterests():Array
		{
			var ret:Array = super.listNotificationInterests();
			ret.push(NotificationNames.DIALOGPRESENTED);
			ret.push(NotificationNames.RECEIVEDONE);
			return ret;
		}
		
		protected function get createBlackoutPeriodDialog():ICreateBlackoutPeriod
		{
			return displayObject as ICreateBlackoutPeriod;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.DIALOGPRESENTED:
					if (notification.getBody() == Places.CREATEBLACKOUTPERIOD)
						populate();
					break;
				
				case NotificationNames.RECEIVEDONE:
					if (notification.getType() == VenueProxy.NAME)
						createBlackoutPeriodDialog.populateVenueData(notification.getBody());
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		override protected function populate():void
		{
			venueProxy.findByPK(initialDataProxy.getInitialData(Places.CREATEBLACKOUTPERIOD) as Number);
		}
	}
}