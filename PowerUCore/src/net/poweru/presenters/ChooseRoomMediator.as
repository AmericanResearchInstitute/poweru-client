package net.poweru.presenters
{
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.dialogs.choosers.interfaces.IChooseRoom;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.proxies.RoomProxy;
	import net.poweru.proxies.VenueProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class ChooseRoomMediator extends BaseChooserMediator implements IMediator
	{
		public static const NAME:String = 'ChooseRoomMediator';
		
		protected var roomProxy:RoomProxy;
		
		public function ChooseRoomMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, Places.CHOOSEROOM, NotificationNames.UPDATEVENUES, VenueProxy);
			roomProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(RoomProxy) as RoomProxy;
		}
		
		protected function get chooseRoom():IChooseRoom
		{
			return viewComponent as IChooseRoom;
		}
		
		override protected function addEventListeners():void
		{
			super.addEventListeners();
			displayObject.addEventListener(ViewEvent.FETCH, onFetchRooms);
		}
		
		override protected function removeEventListeners():void
		{
			super.removeEventListeners();
			displayObject.removeEventListener(ViewEvent.FETCH, onFetchRooms);
		}
		
		override public function listNotificationInterests():Array
		{
			var ret:Array = super.listNotificationInterests();
			ret.push(NotificationNames.UPDATEROOMS);
			ret.push(NotificationNames.LOGOUT);
			return ret;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case updateNotification:
					chooser.populate((notification.getBody() as DataSet).toArray());
					break;
				
				case NotificationNames.UPDATEROOMS:
					chooseRoom.setRooms((notification.getBody() as DataSet).toArray());
					break;
				
				default:
					super.handleNotification(notification);
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