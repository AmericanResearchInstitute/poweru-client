package net.poweru.components.parts.code
{
	import mx.containers.HBox;
	import mx.controls.Button;
	import mx.controls.ComboBox;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	import net.poweru.model.DataSet;
	
	public class AddSessionUserRoleCode extends HBox
	{
		[Bindable]
		public var roleData:DataSet;
		public var minInput:TextInput;
		public var maxInput:TextInput;
		public var roleCB:ComboBox;
		[Bindable]
		public var addButton:Button;
		[Bindable]
		public var removeButton:Button;
		
		public function AddSessionUserRoleCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			roleData = new DataSet();
		}
		
		public function get selectedRole():Object
		{
			return {
				'session_user_role' : roleCB.selectedItem['id'],
				'role_name' : roleCB.selectedItem['name'],
				'min' : minInput.text,
				'max' : maxInput.text
			};
		}
	}
}