package net.poweru.presenters
{
	import mx.events.FlexEvent;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.IVenues;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.proxies.RoomProxy;
	import net.poweru.proxies.VenueProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class VenuesMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'VenuesMediator';
		
		protected var roomProxy:RoomProxy;
		
		public function VenuesMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, VenueProxy);
			roomProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(RoomProxy) as RoomProxy;
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
			displayObject.addEventListener(ViewEvent.FETCH, onFetchRooms);
		}
		
		override protected function removeEventListeners():void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);	
			displayObject.removeEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.removeEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
			displayObject.removeEventListener(ViewEvent.FETCH, onFetchRooms);
		}
		
		override protected function onRefresh(event:ViewEvent):void
		{
			roomProxy.clear();
			super.onRefresh(event);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.SETSPACE,
				NotificationNames.UPDATEVENUES,
				NotificationNames.UPDATEROOMS
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
					venues.populate(primaryProxy.dataSet.toArray());
					break;
				
				case NotificationNames.UPDATEROOMS:
					venues.setRooms((notification.getBody() as DataSet).toArray());
					break;
			}
		}
		
		override protected function populate():void
		{
			primaryProxy.getAll();
		}
		
		protected function onFetchRooms(event:ViewEvent):void
		{
			var room_ids:Array = event.body as Array;
			if (room_ids.length > 0)
				roomProxy.findByIDs(room_ids);
		}
	}
}