package net.poweru.components.dialogs.code
{
	import mx.controls.ComboBox;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ICreateSessionUserRoleRequirementDialog;
	import net.poweru.model.DataSet;
	
	public class CreateSessionUserRoleRequirementCode extends BaseCRUDDialog implements ICreateSessionUserRoleRequirementDialog
	{
		[Bindable]
		public var rolesCB:ComboBox;
		[Bindable]
		public var minInput:TextInput;
		[Bindable]
		public var maxInput:TextInput;
		
		[Bindable]
		protected var session:Object;
		
		public function CreateSessionUserRoleRequirementCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function populate(session:Object, roles:Array):void
		{
			this.session = session;
			
			rolesCB.dataProvider.source = roles;
			rolesCB.dataProvider.refresh();
		}
		
		override public function clear():void
		{
			minInput.text = '';
			maxInput.text = '';
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			rolesCB.dataProvider = new DataSet();
		}
		
		override public function getData():Object
		{
			return {
				'session' : session.id,
				'session_user_role' : rolesCB.selectedItem.id,
				'min' : minInput.text,
				'max' : maxInput.text
			};
		}
	}
}