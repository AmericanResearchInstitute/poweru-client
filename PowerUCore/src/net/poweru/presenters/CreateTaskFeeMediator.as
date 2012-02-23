package net.poweru.presenters
{
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.ICreateTaskFee;
	import net.poweru.placemanager.InitialDataProxy;
	import net.poweru.proxies.TaskFeeProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class CreateTaskFeeMediator extends BaseCreateDialogMediator implements IMediator
	{
		public static const NAME:String = 'CreateTaskFeeMediator';
		protected var initialDataProxy:InitialDataProxy;
		
		public function CreateTaskFeeMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, TaskFeeProxy);
			initialDataProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(InitialDataProxy) as InitialDataProxy;
		}
		
		override public function listNotificationInterests():Array
		{
			var ret:Array = super.listNotificationInterests();
			ret.push(NotificationNames.DIALOGPRESENTED);
			return ret;
		}
		
		protected function get createTaskFeeDialog():ICreateTaskFee
		{
			return displayObject as ICreateTaskFee;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.DIALOGPRESENTED:
					if (notification.getBody() == Places.CREATETASKFEE)
						populate();
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		override protected function populate():void
		{
			createTaskFeeDialog.taskID = initialDataProxy.getInitialData(Places.CREATETASKFEE) as Number;
		}
	}
}