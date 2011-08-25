package net.poweru.presenters
{
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.proxies.CurriculumProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class EditCurriculumMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditCurriculumMediator';
		
		public function EditCurriculumMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, CurriculumProxy, Places.EDITCURRICULUM);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.LOGOUT,
				NotificationNames.DIALOGPRESENTED,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.LOGOUT:
					if (editDialog)
						editDialog.clear();
					break;
				
				case NotificationNames.DIALOGPRESENTED:
					var body:String = notification.getBody() as String;
					if (body != null && body == Places.EDITEXAM)
						populate();
					break;
			}
		}
		
		override protected function populate():void
		{
			var initialData:Object = primaryProxy.findByPK(initialDataProxy.getInitialData(placeName) as Number);
			editDialog.populate(initialData);
		}
	}
}