package net.poweru.presenters
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.presenters.BaseEditDialogMediator;
	import net.poweru.proxies.CategoryProxy;
	import net.poweru.proxies.LegacyGroupProxy;
	import net.poweru.utils.InputCollector;
	import net.poweru.utils.PKArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class EditGroupMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditGroupMediator';
		
		protected var categoryProxy:CategoryProxy;
		protected var inputCollector:InputCollector;
		
		public function EditGroupMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, LegacyGroupProxy, Places.EDITGROUP);
			categoryProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(CategoryProxy) as CategoryProxy;
		}
		
		override public function listNotificationInterests():Array
		{
			var ret:Array = super.listNotificationInterests();
			ret = ret.concat([
				NotificationNames.UPDATECATEGORIES
			])
			return ret;
		}

		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{				
				case NotificationNames.UPDATECATEGORIES:
					var categories:DataSet = notification.getBody() as DataSet;
					inputCollector.addInput('categories', (notification.getBody() as ArrayCollection).toArray());
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		override protected function onReceivedOne(notification:INotification):void
		{
			inputCollector.addInput('group', notification.getBody());
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
			if (inputCollector)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			inputCollector = new InputCollector(['categories', 'group']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			
			primaryProxy.findByPK(initialDataProxy.getInitialData(placeName) as Number);
			// Need to fetch categories before actually populating.
			categoryProxy.getAll();
		}
		
		protected function onInputsCollected(event:Event):void
		{
			var inputCollector:InputCollector = event.target as InputCollector;
			editDialog.populate(inputCollector.object['group'], inputCollector.object['categories']);
		}
		
	}
}