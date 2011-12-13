package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.events.ViewEvent;
	import net.poweru.proxies.FileDownloadProxy;
	import net.poweru.utils.InputCollector;
	import net.poweru.utils.PKArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class EditFileDownloadMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditFileDownloadMediator';
		
		protected var inputCollector:InputCollector;
		
		public function EditFileDownloadMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, FileDownloadProxy, Places.EDITFILEDOWNLOAD);
		}
		
		override protected function onReceivedOne(notification:INotification):void
		{
			inputCollector.addInput('file_download', notification.getBody());
		}
		
		override protected function populate():void
		{
			if (inputCollector)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			inputCollector = new InputCollector(['file_download']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			
			primaryProxy.findByPK(initialDataProxy.getInitialData(placeName) as Number);
		}
		
		protected function onInputsCollected(event:Event):void
		{
			var inputCollector:InputCollector = event.target as InputCollector;
			editDialog.populate(inputCollector.object['file_download']);
		}
	}
}