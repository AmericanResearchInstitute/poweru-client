package net.poweru.components.dialogs.code
{
	import com.yahoo.astra.mx.controls.TimeInput;
	
	import flash.events.Event;
	
	import mx.containers.Form;
	import mx.controls.DataGrid;
	import mx.controls.DateField;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	import mx.validators.DateValidator;
	import mx.validators.NumberValidator;
	
	import net.poweru.Places;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.components.validators.URLValidator;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	import net.poweru.model.ChooserResult;
	import net.poweru.model.DataSet;
	
	public class EditSessionCode extends BaseCRUDDialog implements IEditDialog
	{
		protected static const ONEDAYINSECONDS:Number = 1000*60*60*24;
		
		public var shortNameInput:IGeneratedTextInput;
		public var fullNameInput:IGeneratedTextInput;
		public var titleInput:IGeneratedTextInput;
		[Bindable]
		public var startDateInput:DateField;
		public var startTimeInput:TimeInput;
		[Bindable]
		public var endDateInput:DateField;
		public var endTimeInput:TimeInput;
		[Bindable]
		public var leadTimeInput:TextInput;
		[Bindable]
		public var urlInput:IGeneratedTextInput;
		public var descriptionInput:TextArea;
		[Bindable]
		public var roles:DataGrid;
		public var form:Form;
		
		protected var pk:Number;
		protected var event:Object;
		[Bindable]
		protected var chosenVenue:Object;
		[Bindable]
		protected var chosenRoom:Object;
		
		public var leadTimeInputValidator:NumberValidator;
		public var startDateValidator:DateValidator;
		public var endDateValidator:DateValidator;
		public var urlValidator:URLValidator;
		
		
		public function EditSessionCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function clear():void
		{
			pk = -1;
			shortNameInput.text = '';
			fullNameInput.text = '';
			titleInput.text = '';
			leadTimeInput.text = '';
			descriptionInput.text = '';
			startDateInput.selectedDate = null;
			startTimeInput.value = new Date();
			endDateInput.selectedDate = null;
			endTimeInput.value = new Date();
			
			chosenRoom = null;
			chosenVenue = null;
			super.clear();
		}
		
		public function populate(data:Object, ...args):void
		{
			event = args[0];
			
			pk = data['id'];
			updateControlIfUnchanged(shortNameInput, 'text', data['shortname']);
			updateControlIfUnchanged(fullNameInput, 'text', data['fullname']);
			updateControlIfUnchanged(titleInput, 'text', data['title']);
			updateControlIfUnchanged(urlInput, 'text', data['url']);
			updateControlIfUnchanged(descriptionInput, 'text', data['description']);
			updateControlIfUnchanged(leadTimeInput, 'text', data['lead_time']);
			
			updateControlIfUnchanged(startDateInput, 'selectedDate', new Date((data['start'] as Date).time));
			updateControlIfUnchanged(startTimeInput, 'value', new Date((data['start'] as Date).time));
			updateControlIfUnchanged(endDateInput, 'selectedDate', new Date((data['end'] as Date).time));
			updateControlIfUnchanged(endTimeInput, 'value', new Date((data['end'] as Date).time));
			
			roles.dataProvider.source = data['session_user_role_requirements'];
			roles.dataProvider.refresh()

			
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
				'shortname' : shortNameInput.text,
				'fullname' : fullNameInput.text,
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
		
		override public function receiveChoice(choice:ChooserResult, chooserName:String):void
		{
			if (chooserName == Places.CHOOSEROOM && chooserRequestTracker.doIWantThis(chooserName, choice.requestID))
			{
				chosenVenue = choice.value['venue'];
				chosenRoom = choice.value['room'];
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
				endDateValidator,
				leadTimeInputValidator,
				shortNameInput.validator,
				startDateValidator,
				fullNameInput.validator,
				titleInput.validator,
				urlInput.validator,
				urlValidator
			];
			
			addControlChangeListener(form);
		}
		
		protected function onStartDateSelected(event:Event):void
		{
			restrictEndDateRange();
		}
		
		
	}
}