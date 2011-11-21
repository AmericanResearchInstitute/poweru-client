package net.poweru.components.dialogs.code
{
	import mx.controls.CheckBox;
	import mx.controls.ComboBox;
	import mx.events.FlexEvent;
	import mx.validators.NumberValidator;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.model.DataSet;
	
	public class EditUserOrgRoleCode extends BaseCRUDDialog implements IEditDialog
	{
		[Bindable]
		public var roleInput:ComboBox;
		public var roleValidator:NumberValidator;
		[Bindable]
		public var persistentInput:CheckBox;
		
		[Bindable]
		protected var chosenOrganization:Object;
		[Bindable]
		protected var user:Object;
		[Bindable]
		protected var removedUser:Object;
		protected var pk:Number;
		
		public function EditUserOrgRoleCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function clear():void
		{
			chosenOrganization = null;
			roleInput.selectedItem = null;
			persistentInput.selected = false;
			user = null;
			removedUser = null;
		}
		
		// args[0] is an array of OrgRoles
		public function populate(data:Object, ...args):void
		{
			var roles:Array = args[0] as Array;
			roleInput.dataProvider.source = roles;
			roleInput.dataProvider.refresh();
			roleInput.selectedItem = (roleInput.dataProvider as DataSet).findByPK(data['role']['id']);
			persistentInput.selected = data['persistent'];
			if (data.hasOwnProperty('owner'))
				user = data['owner'];
			pk = data['id'];
		}
		
		override public function getData():Object
		{
			return {
				'id' : pk,
				'role' : roleInput.selectedItem.id,
				'persistent' : persistentInput.selected,
				'owner' : user
			}
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			roleInput.dataProvider = new DataSet();
			validators = [
				roleValidator
			];
		}
	}
}