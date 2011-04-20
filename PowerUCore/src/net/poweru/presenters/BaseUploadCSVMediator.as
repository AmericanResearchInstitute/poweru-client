package net.poweru.presenters
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.net.FileReference;
	
	import mx.controls.Alert;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.components.interfaces.IUploadCSV;
	import net.poweru.events.ViewEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class BaseUploadCSVMediator extends BaseCreateDialogMediator implements IMediator
	{
		protected var modelName:String;
		protected var humanModelName:String;
		
		public function BaseUploadCSVMediator(mediatorName:String, viewComponent:Object, primaryProxyClass:Class, modelName:String, humanModelName:String)
		{
			super(mediatorName, viewComponent, primaryProxyClass);
			this.modelName = modelName;
			this.humanModelName = humanModelName;
		}
		
		protected function get uploadCSVDialog():IUploadCSV
		{
			return viewComponent as IUploadCSV;
		}
		

		override protected function onSubmit(event:ViewEvent):void
		{
			var fileRef:FileReference = event.body as FileReference;
			fileRef.addEventListener(Event.COMPLETE, onUploadComplete);
			primaryProxy.uploadCSV(fileRef, modelName);
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
		}
		
		protected function onUploadComplete(event:Event):void
		{
			(event.target as FileReference).removeEventListener(Event.COMPLETE, onUploadComplete);
			Alert.show('CSV upload succeeded.', 'Success!');
		}
		
		override protected function onCreationComplete(event:FlexEvent):void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			uploadCSVDialog.setModelName(humanModelName);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.UPLOADFAILED,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.UPLOADFAILED:
					var proxyName:String = notification.getBody() as String;
					if (proxyName == primaryProxyName)
						Alert.show("I am sorry I don't have more information for you, but most browsers don't yet support the ability of a plugin (like Flash Player) to read these error messages.", 'CSV Upload Failed');
					break;
			}
		}
		
	}
}