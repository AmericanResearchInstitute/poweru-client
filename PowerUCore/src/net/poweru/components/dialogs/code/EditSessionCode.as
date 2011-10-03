package net.poweru.components.dialogs.code
{
	import com.yahoo.astra.mx.controls.TimeInput;
	
	import flash.events.MouseEvent;
	
	import mx.controls.DataGrid;
	import mx.controls.DateField;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.components.parts.AddSessionUserRole;
	import net.poweru.generated.model.Session.NameInput;
	import net.poweru.generated.model.Session.TitleInput;
	import net.poweru.generated.model.Session.UrlInput;
	import net.poweru.model.DataSet;
	
	public class EditSessionCode extends BaseCRUDDialog implements IEditDialog
	{
		public var nameInput:NameInput;
		public var titleInput:TitleInput;
		public var startDateInput:DateField;
		public var startTimeInput:TimeInput;
		public var endDateInput:DateField;
		public var endTimeInput:TimeInput;
		public var leadTimeInput:TextInput;
		public var urlInput:UrlInput;
		public var descriptionInput:TextArea;
		public var roles:DataGrid;
		public var addRole:AddSessionUserRole;
		
		protected var pk:Number;
		
		public function EditSessionCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function clear():void
		{
			pk = -1;
			nameInput.text = '';
			titleInput.text = '';
			leadTimeInput.text = '';
			descriptionInput.text = '';
			startDateInput.selectedDate = null;
			startTimeInput.value = new Date();
			endDateInput.selectedDate = null;
			endTimeInput.value = new Date();
		}
		
		public function populate(data:Object, ...args):void
		{
			var sessionUserRoles:Array = args[0] as Array;
			
			addRole.roleData.source = sessionUserRoles;
			addRole.roleData.refresh();
			
			pk = data['id'];
			
			nameInput.text = data['name'];
			titleInput.text = data['title'];
			leadTimeInput.text = data['lead_time'];
			urlInput.text = data['url'];
			descriptionInput.text = data['description'];
			startDateInput.selectedDate = new Date((data['start'] as Date).time);
			startTimeInput.value = new Date((data['start'] as Date).time);
			endDateInput.selectedDate = new Date((data['end'] as Date).time);
			endTimeInput.value = new Date((data['end'] as Date).time);
			roles.dataProvider = data['session_user_role_requirements'];
		}
		
		override public function getData():Object
		{
			return {
				'id' : pk,
				'name' : nameInput.text,
				'title' : titleInput.text,
				'lead_time' : leadTimeInput.text,
				'url' : urlInput.text,
				'description' : descriptionInput.text,
				'start' : new Date(
					startDateInput.selectedDate.fullYear,
					startDateInput.selectedDate.month,
					startDateInput.selectedDate.date,
					startTimeInput.value.hours,
					startTimeInput.value.minutes
				),
				'end' : new Date(
					endDateInput.selectedDate.fullYear,
					endDateInput.selectedDate.month,
					endDateInput.selectedDate.date,
					endTimeInput.value.hours,
					endTimeInput.value.minutes
				),
				'session_user_role_requirements' : roles.dataProvider.toArray()
			};
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			roles.dataProvider = new DataSet();
			validators = [
				nameInput.validator,
				titleInput.validator,
				urlInput.validator
			];
			
			addRole.addEventListener(MouseEvent.CLICK, onRoleAdded);
			addRole.removeButton.addEventListener(FlexEvent.BUTTON_DOWN, onClickRemove);
		}
		
		protected function onClickRemove(event:FlexEvent):void
		{
			roles.dataProvider.removeItemAt(roles.dataProvider.getItemIndex(roles.selectedItem));
		}
		
		protected function onRoleAdded(event:MouseEvent):void
		{
			if (event.target == addRole.confirmButton)
			{
				var newSURR:Object = addRole.selectedRole;
				roles.dataProvider.addItem(newSURR);
			}
		}
	}
}