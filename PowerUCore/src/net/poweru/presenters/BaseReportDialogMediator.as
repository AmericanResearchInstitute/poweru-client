package net.poweru.presenters
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.events.ViewEvent;
	import net.poweru.placemanager.InitialDataProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class BaseReportDialogMediator extends BaseMediator implements IMediator
	{
		protected var initialDataProxy:InitialDataProxy;
		protected var inputCollector:InputCollector;
		protected var placeName:String;
		
		public function BaseReportDialogMediator(mediatorName:String, viewComponent:Object, primaryProxyClass:Class=null, placeName:String=null)
		{
			super(mediatorName, viewComponent, primaryProxyClass);
			init(placeName);
		}
		
		private function init(placeName:String):void
		{
			initialDataProxy = getProxy(InitialDataProxy) as InitialDataProxy;
			
			/*	Must wait for data and creation to be complete before passing
				data into the dialog */
			inputCollector = buildInputCollector();
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			
			this.placeName = placeName;
		}
		
		protected function buildInputCollector():InputCollector
		{
			return new InputCollector(['creationComplete', 'data']);
		}
		
		override protected function addEventListeners():void
		{
			displayObject.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			displayObject.addEventListener(ViewEvent.CANCEL, onCancel);
		}
		
		override protected function removeEventListeners():void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			displayObject.removeEventListener(ViewEvent.CANCEL, onCancel);
		}
		
		override protected function onCreationComplete(event:FlexEvent):void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			inputCollector.addInput('creationComplete', true);
		}
		
		protected function onCancel(event:Event):void
		{
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
		}
		
		// pass the data to the view component
		protected function onInputsCollected(event:Event):void
		{
			arrayPopulatedComponent.populate(inputCollector.object['data']);
		}
		
		override public function listNotificationInterests():Array
		{
			return super.listNotificationInterests().concat(
				NotificationNames.DIALOGPRESENTED
			);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.DIALOGPRESENTED:
					if (notification.getBody() == placeName)
						populate();
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
	}
}