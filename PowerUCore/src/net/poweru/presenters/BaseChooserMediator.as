package net.poweru.presenters
{
	import mx.events.FlexEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.components.dialogs.choosers.interfaces.IChooser;
	import net.poweru.events.ViewEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	/*	Base class for mediators that present an IChooser dialog. These
		are dialogs that are used to make a choice when a user is filling
		out a form, especially when the data from which to choose is not
		easily made available in something simple like a ComboBox. */
	public class BaseChooserMediator extends BaseMediator implements IMediator
	{
		protected var placeName:String;
		protected var updateNotification:String;
		
		public function BaseChooserMediator(mediatorName:String, viewComponent:Object, placeName:String, updateNotification:String, primaryProxyClass:Class=null)
		{
			super(mediatorName, viewComponent, primaryProxyClass);
			this.placeName = placeName; 
			this.updateNotification = updateNotification;
		}
		
		protected function get chooser():IChooser
		{
			return viewComponent as IChooser;
		}
		
		override protected function addEventListeners():void
		{
			displayObject.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			displayObject.addEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.addEventListener(ViewEvent.SUBMIT, onSubmit);
			displayObject.addEventListener(ViewEvent.CANCEL, onCancel);
		}
		
		override protected function removeEventListeners():void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);	
			displayObject.removeEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.removeEventListener(ViewEvent.SUBMIT, onSubmit);
			displayObject.removeEventListener(ViewEvent.CANCEL, onCancel);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.SHOWDIALOG,
				updateNotification
			];
		}
		
		protected function onSubmit(event:ViewEvent):void
		{
			sendNotification(NotificationNames.CHOICEMADE, event.body, placeName);
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
			chooser.clear();
		}
		
		protected function onCancel(event:ViewEvent):void
		{
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
		}
	}
}