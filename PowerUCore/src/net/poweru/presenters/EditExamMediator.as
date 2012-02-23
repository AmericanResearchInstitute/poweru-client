package net.poweru.presenters
{
	import mx.core.mx_internal;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.Constants;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.events.ViewEvent;
	import net.poweru.proxies.ExamProxy;
	import net.poweru.proxies.TaskFeeProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class EditExamMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditExamMediator';
		
		protected var taskFeeProxy:TaskFeeProxy;
		
		public function EditExamMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, ExamProxy, Places.EDITEXAM);
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
		
		override protected function onDelete(event:ViewEvent):void
		{
			if (event.subType == Constants.TASK_FEE)
				taskFeeProxy.deleteObject(event.body as Number);
		}
	}
}