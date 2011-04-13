package net.poweru.presenters
{
	import net.poweru.placemanager.InitialDataProxy;
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.components.interfaces.IReportDialog;
	import net.poweru.events.ViewEvent;
	import net.poweru.utils.InputCollector;
	
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.interfaces.IMediator;

	public class BaseReportDialogMediator extends BaseMediator implements IMediator
	{
		protected var initialDataProxy:InitialDataProxy;
		protected var inputCollector:InputCollector;
		
		public function BaseReportDialogMediator(mediatorName:String, viewComponent:Object, primaryProxyClass:Class=null)
		{
			super(mediatorName, viewComponent, primaryProxyClass);
			initialDataProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(InitialDataProxy) as InitialDataProxy;
			
			/*	Must wait for data and creation to be complete before passing
				data into the dialog */
			inputCollector = new InputCollector(['creationComplete', 'data']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
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
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			inputCollector.addInput('creationComplete', true);
		}
		
		protected function onCancel(event:Event):void
		{
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
		}
		
		protected function get reportDialog():IReportDialog
		{
			return displayObject as IReportDialog;
		}
		
		// pass the data to the view component
		protected function onInputsCollected(event:Event):void
		{
			reportDialog.populate(inputCollector.object['data']);
		}
		
		// Override this
		protected function populate():void
		{
			
		}
		
	}
}