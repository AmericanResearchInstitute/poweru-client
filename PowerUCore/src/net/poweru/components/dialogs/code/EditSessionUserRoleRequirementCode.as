package net.poweru.components.dialogs.code
{
	import mx.controls.ComboBox;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.model.DataSet;
	
	public class EditSessionUserRoleRequirementCode extends BaseCRUDDialog implements IEditDialog
	{
		[Bindable]
		public var rolesCB:ComboBox;
		[Bindable]
		public var minInput:TextInput;
		[Bindable]
		public var maxInput:TextInput;
		
		protected var session:Number;
		protected var pk:Number;
		
		public function EditSessionUserRoleRequirementCode()
		{
			super();
		}
		
		public function clear():void
		{
			pk = Number.NaN;
			session = Number.NaN;
			rolesCB.selectedIndex = -1;
			minInput.text = '';
			maxInput.text = '';
		}
		
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			session = data['session'];
			minInput.text = data['min'];
			maxInput.text = data['max'];
			rolesCB.dataProvider.source = args[0];
			rolesCB.dataProvider.refresh();
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			rolesCB.dataProvider = new DataSet();
		}
		
		override public function getData():Object
		{
			return {
				'id' : pk,
				'session' : session,
				'session_user_role' : {'id' : rolesCB.selectedItem.id, 'name' : rolesCB.selectedItem.name},
				'min' : minInput.text,
				'max' : maxInput.text
			};
		}
	}
}