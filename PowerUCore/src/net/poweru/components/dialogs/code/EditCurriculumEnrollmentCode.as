package net.poweru.components.dialogs.code
{
	import flash.events.Event;
	
	import mx.controls.DateField;
	import mx.controls.Label;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	
	public class EditCurriculumEnrollmentCode extends BaseCRUDDialog implements IEditDialog
	{
		[Bindable]
		public var startInput:DateField;
		[Bindable]
		public var endInput:DateField;
		public var curriculumName:Label;
		
		protected var pk:Number;
		
		public function EditCurriculumEnrollmentCode()
		{
			super();
		}
		
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			curriculumName.text = data['curriculum_name'];
			startInput.selectedDate = data['start'];
			endInput.selectedDate = data['end'];
			if (startInput.selectedDate != null)
				restrictEndDate();
		}
		
		override public function clear():void
		{
			startInput.selectedDate = null;
			endInput.selectedDate = null;
		}
		
		override public function getData():Object
		{
			return {
				'id' : pk,
				'start' : startInput.selectedDate,
				'end' : endInput.selectedDate
			};
		}
		
		protected function restrictEndDate():void
		{
			// subtract one day
			endInput.disabledRanges = [{'rangeEnd': new Date(startInput.selectedDate.getTime() - 1000*60*60*24)}];
			
			// if the newly chosen start date is after the end date, erase the end date so the user must choose a new one
			if (endInput.selectedDate != null && endInput.selectedDate.getTime() < startInput.selectedDate.getTime())
				endInput.selectedDate = null;
		}
		
		protected function onStartDateChosen(event:Event):void
		{
			restrictEndDate();
		}
	}
}