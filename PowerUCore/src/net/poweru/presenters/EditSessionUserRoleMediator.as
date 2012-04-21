package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.Places;
	import net.poweru.proxies.SessionUserRoleProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class EditSessionUserRoleMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditSessionUserRoleMediator';
		
		protected var inputCollector:InputCollector;
		
		public function EditSessionUserRoleMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, SessionUserRoleProxy, Places.EDITSESSIONUSERROLE);
		}
		
		override protected function onReceivedOne(notification:INotification):void
		{
			inputCollector.addInput('session_user_role', notification.getBody());
		}
		
		override protected function populate():void
		{
			if (inputCollector)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			inputCollector = new InputCollector(['session_user_role']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			
			primaryProxy.findByPK(initialDataProxy.getInitialData(placeName) as Number);
		}
		
		protected function onInputsCollected(event:Event):void
		{
			var inputCollector:InputCollector = event.target as InputCollector;
			editDialog.populate(inputCollector.object['session_user_role']);
		}
	}
}