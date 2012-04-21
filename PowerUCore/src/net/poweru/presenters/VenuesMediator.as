package net.poweru.presenters
{
	import mx.events.FlexEvent;
	import mx.utils.StringUtil;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.IVenues;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.proxies.BlackoutPeriodProxy;
	import net.poweru.proxies.RoomProxy;
	import net.poweru.proxies.VenueProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class VenuesMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'VenuesMediator';
		
		protected var roomProxy:RoomProxy;
		protected var blackoutPeriodProxy:BlackoutPeriodProxy;
		
		public function VenuesMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, VenueProxy);
			init();
		}
		
		private function init():void
		{
			roomProxy = getProxy(RoomProxy) as RoomProxy;
			blackoutPeriodProxy = getProxy(BlackoutPeriodProxy) as BlackoutPeriodProxy;
		}
		
		protected function get venues():IVenues
		{
			return displayObject as IVenues;
		}
		
		override protected function addEventListeners():void
		{
			displayObject.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			displayObject.addEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.addEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
			displayObject.addEventListener(ViewEvent.FETCH, onFetch);
		}
		
		override protected function removeEventListeners():void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);	
			displayObject.removeEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.removeEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
			displayObject.removeEventListener(ViewEvent.FETCH, onFetch);
		}
		
		override protected function onRefresh(event:ViewEvent):void
		{
			roomProxy.clear();
			blackoutPeriodProxy.clear();
			super.onRefresh(event);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.LOGOUT,
				NotificationNames.SETSPACE,
				NotificationNames.UPDATEVENUES,
				NotificationNames.UPDATEROOMS,
				NotificationNames.UPDATEBLACKOUTPERIODS
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.SETSPACE:
					if (notification.getBody() == Places.VENUES)
						populate();
					break;
				
				// Happens when we save an Event, and indicates that we should just refresh the view
				case NotificationNames.UPDATEVENUES:
					venues.clear();
					venues.populate(primaryProxy.dataSet.toArray());
					break;
				
				case NotificationNames.UPDATEROOMS:
					venues.setRooms((notification.getBody() as DataSet).toArray());
					break;
				
				case NotificationNames.UPDATEBLACKOUTPERIODS:
					venues.setBlackoutPeriods((notification.getBody() as DataSet).toArray());
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		override protected function populate():void
		{
			primaryProxy.getAll();
		}
		
		protected function onFetch(event:ViewEvent):void
		{
			var venueID:Number = event.body as Number;
			var currentDate:Date = new Date();
			var dateString:String = StringUtil.substitute('{0}-{1}-{2}',
				currentDate.getUTCFullYear(),
				currentDate.getUTCMonth() + 1,
				currentDate.getUTCDay()
			);
			
			roomProxy.getFiltered({'exact':{'venue':venueID}});
			blackoutPeriodProxy.getFiltered({
				'exact':{'venue':venueID},
				'greater_than':{'end':dateString}
			});
		}
	}
}