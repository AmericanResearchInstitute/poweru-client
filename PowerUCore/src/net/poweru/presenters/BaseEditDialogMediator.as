package net.poweru.presenters
{
	import net.poweru.placemanager.InitialDataProxy;
	import net.poweru.NotificationNames;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.events.ViewEvent;
	
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.interfaces.IMediator;

	public class BaseEditDialogMediator extends BaseMediator implements IMediator
	{
		protected var initialDataProxy:InitialDataProxy;
		protected var placeName:String;
		
		public function BaseEditDialogMediator(mediatorName:String, viewComponent:Object, primaryProxyClass:Class, placeName:String)
		{
			super(mediatorName, viewComponent, primaryProxyClass);
			initialDataProxy = facade.retrieveProxy(InitialDataProxy.NAME) as InitialDataProxy;
			
			this.placeName = placeName;
		}
		
		protected function get editDialog():IEditDialog
		{
			return viewComponent as IEditDialog;
		}
		
		override protected function addEventListeners():void
		{
			super.addEventListeners();
			if (displayObject)
			{
				displayObject.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
				displayObject.addEventListener(ViewEvent.SUBMIT, onSubmit);
				displayObject.addEventListener(ViewEvent.CANCEL, onCancel);
			}
		}
		
		override protected function removeEventListeners():void
		{
			super.addEventListeners();
			if (displayObject)
			{
				displayObject.removeEventListener(ViewEvent.SUBMIT, onSubmit);
				displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
				displayObject.removeEventListener(ViewEvent.CANCEL, onCancel);
			}
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			populate();
		}
		
		// probably override this in a subclass, and make sure to call the method on super()
		protected function onSubmit(event:ViewEvent):void
		{
			primaryProxy.save(editDialog.getData());
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
		}
		
		// override this in a subclass
		protected function populate():void
		{
			editDialog.populate(primaryProxy.findByPK(initialDataProxy.getInitialData(placeName) as Number));
		}
		
		protected function onCancel(event:ViewEvent):void
		{
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
		}
		
	}
}