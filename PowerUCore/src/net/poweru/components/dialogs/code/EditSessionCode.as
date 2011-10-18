package net.poweru.components.dialogs.code
{
	import com.yahoo.astra.mx.controls.TimeInput;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.DataGrid;
	import mx.controls.DateField;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	import net.poweru.Places;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.components.parts.AddSessionUserRole;
	import net.poweru.generated.model.Session.NameInput;
	import net.poweru.generated.model.Session.TitleInput;
	import net.poweru.generated.model.Session.UrlInput;
	import net.poweru.model.DataSet;
	
	public class EditSessionCode extends BaseCRUDDialog implements IEditDialog
	{
		protected static const ONEDAYINSECONDS:Number = 1000*60*60*24;
		
		public var nameInput:NameInput;
		public var titleInput:TitleInput;
		[Bindable]
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
		protected var event:Object;
		[Bindable]
		protected var chosenVenue:Object;
		[Bindable]
		protected var chosenRoom:Object;
		
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
			
			chosenRoom = null;
			chosenVenue = null;
		}
		
		public function populate(data:Object, ...args):void
		{
			var sessionUserRoles:Array = args[0] as Array;
			event = args[1];
			
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
			
			if (data.hasOwnProperty('room') && data['room'] != null)
			{
				chosenRoom = data['room'];
				chosenVenue = {'name' : chosenRoom['venue_name']};
			}
			else
			{
				chosenRoom = null;
				chosenVenue = null;
			}
			
			restrictStartDateRange();
			restrictEndDateRange();
		}
		
		override public function getData():Object
		{
			var ret:Object = {
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
			
			if (chosenRoom != null && chosenRoom.hasOwnProperty('id'))
				ret['room'] = chosenRoom['id'];
			
			return ret;
		}
		
		protected function get eventStart():Date
		{
			return event['start'] as Date;
		}
		
		protected function get eventEnd():Date
		{
			return event['end'] as Date;
		}
		
		override public function receiveChoice(choice:Object, chooserName:String):void
		{
			if (chooserName == Places.CHOOSEROOM)
			{
				chosenVenue = choice['venue'];
				chosenRoom = choice['room'];
			}
		}
		
		/*	Makes sure the endDateInput cannot select a date before the event
			and session have begun or after the event has ended. */
		protected function restrictEndDateRange():void
		{
			// subtract one day
			endDateInput.disabledRanges = [
				{'rangeEnd': new Date(startDateInput.selectedDate.getTime() - ONEDAYINSECONDS)},
				{'rangeStart' : new Date(eventEnd.getTime() + ONEDAYINSECONDS)}
			];
			
			// if the chosen start date is after the end date, erase the end date so the user must choose a new one
			if (endDateInput.selectedDate != null && endDateInput.selectedDate.getTime() < startDateInput.selectedDate.getTime())
				endDateInput.selectedDate = null;
		}
		
		/* 	Makes sure the startDateInput cannot select a date outside the
			date range for the event. */
		protected function restrictStartDateRange():void
		{
			startDateInput.disabledRanges = [
				{'rangeEnd': new Date(eventStart.getTime() - ONEDAYINSECONDS)},
				{'rangeStart' : new Date(eventEnd.getTime() + ONEDAYINSECONDS)}
			];
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
		
		protected function onStartDateSelected(event:Event):void
		{
			restrictEndDateRange();
		}
	}
}