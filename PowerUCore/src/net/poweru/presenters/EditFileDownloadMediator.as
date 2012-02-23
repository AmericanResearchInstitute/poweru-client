package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.Constants;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.events.ViewEvent;
	import net.poweru.proxies.FileDownloadProxy;
	import net.poweru.proxies.TaskFeeProxy;
	import net.poweru.utils.InputCollector;
	import net.poweru.utils.PKArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class EditFileDownloadMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditFileDownloadMediator';
		
		protected var inputCollector:InputCollector;
		protected var taskFeeProxy:TaskFeeProxy;
		
		public function EditFileDownloadMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, FileDownloadProxy, Places.EDITFILEDOWNLOAD);
			taskFeeProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(TaskFeeProxy) as TaskFeeProxy;
		}
		
		override public function listNotificationInterests():Array
		{
			var ret:Array = super.listNotificationInterests();
			ret.push(NotificationNames.TASKFEECREATED);
			ret.push(NotificationNames.TASKFEEDELETED);
			return ret;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				// refresh our task if we have one, because a task fee was changed
				case NotificationNames.TASKFEECREATED:
				case NotificationNames.TASKFEEDELETED:
					var currentData:Object = editDialog.getData();
					if (currentData.hasOwnProperty('id') && currentData.id != null)
						primaryProxy.getOne(currentData.id);
					break;
				
				default:
					super.handleNotification(notification);
			}
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
		
		override protected function onDelete(event:ViewEvent):void
		{
			if (event.subType == Constants.TASK_FEE)
				taskFeeProxy.deleteObject(event.body as Number);
		}
	}
}