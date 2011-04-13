package net.poweru.presenters
{
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.presenters.BaseEditDialogMediator;
	import net.poweru.proxies.CategoryProxy;
	import net.poweru.proxies.GroupProxy;
	import net.poweru.utils.PKArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class EditGroupMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditGroupMediator';
		
		protected var categoryProxy:CategoryProxy;
		protected var initialData:Object;
		
		public function EditGroupMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, GroupProxy, Places.EDITGROUP);
			categoryProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(CategoryProxy) as CategoryProxy;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.LOGOUT,
				NotificationNames.DIALOGPRESENTED,
				NotificationNames.UPDATECATEGORIES,
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
					if (body != null && body == Places.EDITGROUP)
						populate();
					break;
				
				case NotificationNames.UPDATECATEGORIES:
					var categories:DataSet = notification.getBody() as DataSet;
					editDialog.populate(initialData, categories.toArray());
					break;
			}
		}
		
		override protected function onSubmit(event:ViewEvent):void
		{
			var newObject:Object = event.body;
			newObject['groups'] = new PKArrayCollection(newObject['groups']).toArray();
			primaryProxy.save(newObject);
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
		}
		
		override protected function populate():void
		{
			initialData = primaryProxy.findByPK(initialDataProxy.getInitialData(placeName) as Number);
			// Need to fetch categories before actually populating.
			categoryProxy.getAll(['name']);
		}
		
	}
}