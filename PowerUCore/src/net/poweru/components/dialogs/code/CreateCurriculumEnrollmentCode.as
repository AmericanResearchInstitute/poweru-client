package net.poweru.components.dialogs.code
{
	import flash.events.Event;
	
	import mx.controls.DateField;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ICreateCurriculumEnrollment;
	
	public class CreateCurriculumEnrollmentCode extends BaseCRUDDialog implements ICreateCurriculumEnrollment
	{
		[Bindable]
		protected var curriculum:Object;
		
		[Bindable]
		public var startDate:DateField;
		[Bindable]
		public var endDate:DateField;
		
		public function CreateCurriculumEnrollmentCode()
		{
			super();
		}
		
		override public function clear():void
		{
			curriculum = {};
			startDate.selectedDate = null;
			endDate.selectedDate = null;
		}
		
		public function populate(curriculum:Object):void
		{
			clear();
			this.curriculum = curriculum;
		}
		
		override public function getData():Object
		{
			return {
				'curriculum' : curriculum.id,
				'start' : startDate.selectedDate,
				'end' : endDate.selectedDate
			}
		}
		
		protected function onStartDateChosen(event:Event):void
		{
			// subtract one day
			endDate.disabledRanges = [{'rangeEnd': new Date(startDate.selectedDate.getTime() - 1000*60*60*24)}];
			
			// if the newly chosen start date is after the end date, erase the end date so the user must choose a new one
			if (endDate.selectedDate != null && endDate.selectedDate.getTime() < startDate.selectedDate.getTime())
				endDate.selectedDate = null;
		}
	}
}