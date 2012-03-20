package net.poweru.presenters
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	
	import mx.controls.Alert;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.IUploadFileDownload;
	import net.poweru.events.ViewEvent;
	import net.poweru.proxies.BrowserServicesProxy;
	import net.poweru.proxies.FileDownloadProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class UploadFileDownloadMediator extends BaseCreateDialogMediator implements IMediator
	{
		public static const NAME:String = 'UploadFileDownloadMediator';
		
		protected var browserServicesProxy:BrowserServicesProxy;
		
		public function UploadFileDownloadMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, FileDownloadProxy);
			browserServicesProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(BrowserServicesProxy) as BrowserServicesProxy;
		}
		
		public function get fileDownloadProxy():FileDownloadProxy
		{
			return primaryProxy as FileDownloadProxy;
		}
		
		public function get uploadDialog():IUploadFileDownload
		{
			return viewComponent as IUploadFileDownload;
		}
		
		override public function listNotificationInterests():Array
		{
			return super.listNotificationInterests().concat([
				NotificationNames.LOGOUT,
				NotificationNames.DIALOGPRESENTED,
			]);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.LOGOUT:
					if (uploadDialog)
						uploadDialog.clear();
					break;
				
				case NotificationNames.DIALOGPRESENTED:
					var body:String = notification.getBody() as String;
					if (body != null && body == Places.UPLOADFILEDOWNLOAD)
						uploadDialog.clear();
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		override protected function onSubmit(event:ViewEvent):void
		{
			
			var file:FileReference = uploadDialog.getFileDownload();
			file.addEventListener(Event.CANCEL, onUploadEvent, false, 0, true);
			file.addEventListener(Event.COMPLETE, onUploadEvent, false, 0, true);
			file.addEventListener(IOErrorEvent.IO_ERROR, onUploadEvent, false, 0, true);
			
			var data:Object = uploadDialog.getData();
			
			fileDownloadProxy.uploadFileDownload(file, data);
		}
		
		protected function onUploadEvent(event:Event):void
		{
			switch (event.type)
			{
				case Event.CANCEL:
					Alert.show("Upload cancelled.");
					break;
				
				case Event.COMPLETE:
					// "For file upload, this event is dispatched after the Flash Player or Adobe AIR
					// receives an HTTP status code of 200 from the server receiving the transmission."
					sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
					Alert.show("Upload complete!");
					break;
				
				case IOErrorEvent.IO_ERROR:
					sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
					Alert.show("IO Error uploading the file.")
					break;
			}
		}
	}
}