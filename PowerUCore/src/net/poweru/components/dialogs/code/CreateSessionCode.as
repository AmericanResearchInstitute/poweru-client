package net.poweru.components.dialogs.code
{
	import com.yahoo.astra.mx.controls.TimeInput;
	import com.yahoo.astra.mx.core.yahoo_mx_internal;
	
	import flash.events.Event;
	
	import mx.controls.DateField;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ICreateSession;
	import net.poweru.generated.model.Session.FullnameInput;
	import net.poweru.generated.model.Session.ShortnameInput;
	import net.poweru.generated.model.Session.TitleInput;
	import net.poweru.generated.model.Session.UrlInput;
	
	public class CreateSessionCode extends BaseCRUDDialog implements ICreateSession
	{
		protected static const ONEDAYINSECONDS:Number = 1000*60*60*24;
		
		public var shortNameInput:ShortnameInput;
		public var fullNameInput:FullnameInput;
		public var titleInput:TitleInput;
		[Bindable]
		public var startDateInput:DateField;
		public var startTimeInput:TimeInput;
		public var endDateInput:DateField;
		public var endTimeInput:TimeInput;
		public var leadTimeInput:TextInput;
		public var urlInput:UrlInput;
		public var descriptionInput:TextArea;
		
		[Bindable]
		protected var event:Object;
		
		public function CreateSessionCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function getData():Object
		{
			return {
				'event' : event['id'],
				'shortname' : shortNameInput.text,
				'fullname' : fullNameInput.text,
				'title' : titleInput.text,
				'lead_time' : leadTimeInput.text,
				'url' : urlInput.text,
				'description' : descriptionInput.text,
				'status' : 'pending',
				'default_price' : 0,
				'confirmed' : true,
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
				)
			};
		}
		
		public function populateEventData(data:Object):void
		{
			event = data;
			restrictStartDateRange();
		}
		
		protected function get eventStart():Date
		{
			return event['start'] as Date;
		}
		
		protected function get eventEnd():Date
		{
			return event['end'] as Date;
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
		
		public function clear():void
		{
			shortNameInput.text = '';
			fullNameInput.text = '';
			titleInput.text = '';
			leadTimeInput.text = '';
			descriptionInput.text = '';
			startDateInput.selectedDate = null;
			startTimeInput.value = new Date();
			endDateInput.selectedDate = null;
			endTimeInput.value = new Date();
			event = null;
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			validators = [
				shortNameInput.validator,
				fullNameInput.validator,
				titleInput.validator,
				urlInput.validator
			];
			focusManager.setFocus(shortNameInput);
		}
		
		protected function onStartDateSelected(event:Event):void
		{
			restrictEndDateRange();
		}
	}
}