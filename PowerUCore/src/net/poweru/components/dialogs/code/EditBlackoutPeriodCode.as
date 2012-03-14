package net.poweru.components.dialogs.code
{
	import com.yahoo.astra.mx.controls.TimeInput;
	
	import flash.events.Event;
	
	import mx.controls.DateField;
	import mx.controls.TextArea;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	
	public class EditBlackoutPeriodCode extends BaseCRUDDialog implements IEditDialog
	{
		protected static const ONEDAYINSECONDS:Number = 1000*60*60*24;
		
		[Bindable]
		public var startDateInput:DateField;
		public var startTimeInput:TimeInput;
		public var endDateInput:DateField;
		public var endTimeInput:TimeInput;
		public var descriptionInput:TextArea;
		protected var pk:Number;
		
		public function EditBlackoutPeriodCode()
		{
			super();
			validators = [];
		}
		
		override public function clear():void
		{
			descriptionInput.text = '';
			startDateInput.selectedDate = null;
			startTimeInput.value = new Date();
			endDateInput.selectedDate = null;
			endTimeInput.value = new Date();
		}
		
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			descriptionInput.text = data['description'];
			startDateInput.selectedDate = new Date((data['start'] as Date).time);
			startTimeInput.value = new Date((data['start'] as Date).time);
			endDateInput.selectedDate = new Date((data['end'] as Date).time);
			endTimeInput.value = new Date((data['end'] as Date).time);
			
			restrictEndDateRange();
		}
		
		override public function getData():Object
		{
			return {
				'id' : pk,
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
				)
			};
		}
		
		protected function restrictEndDateRange():void
		{
			// subtract one day
			endDateInput.disabledRanges = [
				{'rangeEnd': new Date(startDateInput.selectedDate.getTime() - ONEDAYINSECONDS)}
			];
			
			// if the chosen start date is after the end date, erase the end date so the user must choose a new one
			if (endDateInput.selectedDate != null && endDateInput.selectedDate.getTime() < startDateInput.selectedDate.getTime())
				endDateInput.selectedDate = null;
		}
		
		protected function onStartDateSelected(event:Event):void
		{
			restrictEndDateRange();
		}
	}
}