package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.ICreateCurriculumEnrollment;
	import net.poweru.components.interfaces.ICreateDialog;
	import net.poweru.events.ViewEvent;
	import net.poweru.placemanager.InitialDataProxy;
	import net.poweru.proxies.CurriculumEnrollmentProxy;
	import net.poweru.proxies.CurriculumProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class CreateCurriculumEnrollmentMediator extends BaseCreateDialogMediator implements IMediator
	{
		public static const NAME:String = 'CreateCurriculumEnrollmentMediator';
		protected var initialDataProxy:InitialDataProxy;
		protected var curriculumProxy:CurriculumProxy;
		
		public function CreateCurriculumEnrollmentMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, CurriculumEnrollmentProxy);
			initialDataProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(InitialDataProxy) as InitialDataProxy;
			curriculumProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(CurriculumProxy) as CurriculumProxy;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.LOGOUT,
				NotificationNames.DIALOGPRESENTED,
				NotificationNames.RECEIVEDONE,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.LOGOUT:
					if (createDialog)
						createDialog.clear();
					break;
				
				case NotificationNames.DIALOGPRESENTED:
					var body:String = notification.getBody() as String;
					if (body != null && body == Places.CREATECURRICULUMENROLLMENT)
						populate();
					break;
				
				case NotificationNames.RECEIVEDONE:
					if (notification.getType() == curriculumProxy.getProxyName())
						createCurriculumEnrollmentDialog.populate(notification.getBody());
					break;
			}
		}
		
		override protected function onSubmit(event:ViewEvent):void
		{
			var newObject:Object = event.body;
			primaryProxy.create(newObject);
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
		}
		
		protected function get createCurriculumEnrollmentDialog():ICreateCurriculumEnrollment
		{
			return viewComponent as ICreateCurriculumEnrollment;
		}
		
		override protected function populate():void
		{
			var pk:Number = initialDataProxy.getInitialData(Places.CREATECURRICULUMENROLLMENT) as Number;
			curriculumProxy.getOne(pk);
		}
	}
}