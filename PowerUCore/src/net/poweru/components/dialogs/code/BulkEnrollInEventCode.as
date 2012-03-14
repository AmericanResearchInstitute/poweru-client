package net.poweru.components.dialogs.code
{
	import flash.events.Event;
	
	import mx.containers.VBox;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IBulkEnrollInEvent;
	import net.poweru.components.parts.SelectSessionRole;
	import net.poweru.events.ViewEvent;
	
	public class BulkEnrollInEventCode extends BaseCRUDDialog implements IBulkEnrollInEvent
	{
		protected var event:Object;
		protected var sessions:Array;
		protected var users:Array;
		
		public var sessionContainer:VBox;
		
		public function BulkEnrollInEventCode()
		{
			super();
		}
		
		override public function clear():void
		{
			sessionContainer.removeAllChildren();
		}
		
		public function populate(event:Object, sessions:Array, users:Array):void
		{
			clear();
			this.users = users;
			this.event = event;
			
			for each (var session:Object in sessions)
			{
				var selectSessionRole:SelectSessionRole = new SelectSessionRole();
				selectSessionRole.session = session;
				sessionContainer.addChild(selectSessionRole);
			}
		}
		
		protected function onSubmit(event:Event):void
		{
			for each (var sessionEnrollment:SelectSessionRole in sessionContainer.getChildren())
			{
				if (sessionEnrollment.enrollCheckBox.selected)
				{
					dispatchEvent(new ViewEvent(ViewEvent.SUBMIT, {'users' : users, 'session_user_role_requirement' : sessionEnrollment.roleComboBox.selectedItem['id']}));
				}
			}
		}
	}
}