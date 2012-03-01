package net.poweru.presenters
{
	import mx.events.FlexEvent;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.events.ViewEvent;
	import net.poweru.placemanager.InitialDataProxy;
	import net.poweru.proxies.ExamSessionProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class AdministerExamSessionMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'AdministerExamMediator';
		
		protected var initialDataProxy:InitialDataProxy;
		
		public function AdministerExamSessionMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, ExamSessionProxy);
			initialDataProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(InitialDataProxy) as InitialDataProxy;
		}
		
		protected function get examSessionProxy():ExamSessionProxy
		{
			return primaryProxy as ExamSessionProxy;
		}
		
		override protected function addEventListeners():void
		{
			displayObject.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			displayObject.addEventListener(ViewEvent.SUBMIT, onSubmit);
			displayObject.addEventListener(ViewEvent.CANCEL, onCancel);
		}
		
		override protected function removeEventListeners():void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			displayObject.removeEventListener(ViewEvent.SUBMIT, onSubmit);
			displayObject.removeEventListener(ViewEvent.CANCEL, onCancel);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.EXAMSESSIONCREATED,
				NotificationNames.DIALOGPRESENTED,
				NotificationNames.LOGOUT
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.DIALOGPRESENTED:
					if (notification.getBody() == Places.ADMINISTEREXAMSESSION)
						populate();
					break;
				
				case NotificationNames.EXAMSESSIONCREATED:
					var body:Object = notification.getBody();
					var questionPools:Array = body['question_pools'] as Array;
					if (questionPools != null && questionPools.length > 0)
						objectPopulatedComponent.populate(body);
					else
					{
						// no more questions left, so don't show the dialog.
						objectPopulatedComponent.clear();
						sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
					}
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		override protected function populate():void
		{
			primaryProxy.create({
				'assignment' : initialDataProxy.getInitialData(Places.ADMINISTEREXAMSESSION),
				'fetch_all' : true,
				'resume' : true
			});
		}
		
		
		protected function onSubmit(event:ViewEvent):void
		{
			objectPopulatedComponent.clear();
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
			var responses:Array = event.body as Array;
			for each (var response:Object in responses)
			{
				examSessionProxy.addResponse(
					response['examSessionID'],
					response['questionID'],
					response['optionalParameters']
				);
			}
		}
		
		protected function onCancel(event:ViewEvent):void
		{
			objectPopulatedComponent.clear();
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
		}
	}
}