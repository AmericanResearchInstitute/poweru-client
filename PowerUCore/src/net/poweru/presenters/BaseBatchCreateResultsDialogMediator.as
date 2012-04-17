package net.poweru.presenters
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.events.ViewEvent;
	import net.poweru.placemanager.InitialDataProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class BaseBatchCreateResultsDialogMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'BaseBulkCreateResultsDialogMediator';
		
		protected var initialDataProxy:InitialDataProxy;
		protected var inputCollector:InputCollector;
		protected var placeName:String;
		
		public function BaseBatchCreateResultsDialogMediator(mediatorName:String, viewComponent:Object, primaryProxyClass:Class=null, placeName:String=null)
		{
			super(mediatorName, viewComponent, primaryProxyClass);
			this.placeName = placeName;
			initialDataProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(InitialDataProxy) as InitialDataProxy;
			inputCollector = new InputCollector(['creationComplete', 'data']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
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
		
		override protected function populate():void
		{
			inputCollector.addInput('data', initialDataProxy.getInitialData(placeName));
		}
		
		override protected function onCreationComplete(event:FlexEvent):void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			inputCollector.addInput('creationComplete', true);
			populate();
		}
		
		// pass the data to the view component
		protected function onInputsCollected(event:Event):void
		{
			objectPopulatedComponent.populate(inputCollector.object['data']);
		}
		
		protected function onCancel(event:Event):void
		{
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
		}
	}
}