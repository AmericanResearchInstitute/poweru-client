package net.poweru.components.dialogs.code
{
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.parts.AddOrganization;
	import net.poweru.components.widgets.TitleComboBox;
	import net.poweru.components.widgets.code.IMultipleSelect;
	import net.poweru.model.DataSet;
	
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.Form;
	import mx.containers.FormItem;
	import mx.controls.ComboBox;
	import mx.controls.DataGrid;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	import mx.validators.Validator;
	
	import net.poweru.generated.interfaces.IGeneratedTextInput;

	public class EditUserCode extends BaseCRUDDialog implements IEditDialog
	{
		public var titleInput:TitleComboBox;
		public var first:IGeneratedTextInput;
		public var last:IGeneratedTextInput;
		public var email:IGeneratedTextInput;
		public var phone:IGeneratedTextInput;
		public var oldPasswordInput:TextInput;
		[Bindable]
		public var password1Input:TextInput;
		[Bindable]
		public var password2Input:TextInput;
		[Bindable]
		public var statusInput:ComboBox;
		[Bindable]
		public var orgs:DataGrid;
		[Bindable]
		public var form:Form;
		
		protected var pk:Number;
		[Bindable]
		public var groups:IMultipleSelect;
		[Bindable]
		public var addOrganization:AddOrganization;
		
		[Bindable]
		protected var orgDataSet:DataSet;
		
		public function EditUserCode()
		{
			super();
			orgDataSet = new DataSet();
		}
		
		// args[0] is group choices
		// args[1] is all organizations
		// args[2] is all organization roles
		public function populate(data:Object, ...args):void
		{
			orgDataSet.source = data['owned_userorgroles'];
			orgDataSet.refresh();
			
			var groupChoices:Array = args[0];
			addOrganization.organizationData.source = args[1] as Array;
			addOrganization.organizationData.refresh();
			addOrganization.orgRoleData.source = args[2] as Array;
			addOrganization.orgRoleData.refresh();
			addOrganization.orgDataSet = orgDataSet;
			addOrganization.currentState = '';
			
			titleInput.text = data['title'];
			first.text = data['first_name'];
			last.text = data['last_name'];
			email.text = data['email'];
			phone.text = data['phone'];
			pk = data['id'];
		
			statusInput.selectedItem = data['status'];
			
			groups.populate(groupChoices, data['groups']);
			
			this.title = "Edit User " + first.text + " " + last.text;
			
			password1Input.text = '';
			password2Input.text = '';
			oldPasswordInput.text = '';
		}
		
		override public function getData():Object
		{
			var ret:Object = {
				'id' : pk,
				'title' : titleInput.text,
				'first_name' : first.text,
				'last_name' : last.text,
				'email' : email.text,
				'phone' : phone.text,
				'groups' : groups.selectedItems,
				'status' : statusInput.selectedItem,
				'owned_userorgroles' : orgDataSet.toArray()
			};
			
			if (password1Input.text.length > 0)
			{
				ret['oldPassword'] = oldPasswordInput.text;
				ret['password'] = password1Input.text;
			}
				
			return ret;
		}
		
		public function clear():void
		{
			pk = -1;
			titleInput.text = '';
			first.text = '';
			last.text = '';
			email.text = '';
			phone.text = '';
			statusInput.selectedItem = null;
			
			groups.populate([], []);
			
			password1Input.text = '';
			password2Input.text = '';
			oldPasswordInput.text = '';
			
			orgDataSet.source = [];
			orgDataSet.refresh();
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			statusInput.dataProvider = new DataSet();
			addOrganization.addEventListener(MouseEvent.CLICK, onOrganizationAdded);
			addOrganization.remove.addEventListener(FlexEvent.BUTTON_DOWN, onClickRemove);
			BindingUtils.bindProperty(addOrganization.remove, 'enabled', orgs, 'selectedItem');
			
			for each (var item:Object in form.getChildren())
				if (item is FormItem)
					for each (var child:Object in item.getChildren())
						if (child.hasOwnProperty('validator'))
							validators.push(child['validator']);
		}
		
		protected function onClickRemove(event:FlexEvent):void
		{
			orgDataSet.removeItemAt(orgDataSet.getItemIndex(orgs.selectedItem));
		}
		
		protected function onOrganizationAdded(event:MouseEvent):void
		{
			if (event.target == addOrganization.confirm)
			{
				var newOrgRelationship:Object = {
					'organization' : addOrganization.selectedOrganization['id'],
					'organization_name' : addOrganization.selectedOrganization['name'],
					'role' : addOrganization.selectedOrgRole['id'],
					'role_name' : addOrganization.selectedOrgRole['name'],
					'owner' : pk
				}
				
				orgDataSet.addItem(newOrgRelationship);
			}
		}
		
		override public function setChoices(choices:Object):void
		{
			super.setChoices(choices);
			statusInput.dataProvider.source = choices['status'];
			statusInput.dataProvider.refresh();
		}

	}
}