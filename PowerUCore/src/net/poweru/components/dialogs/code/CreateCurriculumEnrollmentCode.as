package net.poweru.components.dialogs.code
{
	import flash.events.Event;
	
	import mx.controls.DateField;
	import mx.controls.TextArea;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ICreateCurriculumEnrollment;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	
	public class CreateCurriculumEnrollmentCode extends BaseCRUDDialog implements ICreateCurriculumEnrollment
	{
		[Bindable]
		protected var curriculum:Object;
		
		public var nameInput:IGeneratedTextInput;
		public var descriptionInput:TextArea;
		[Bindable]
		public var startDate:DateField;
		[Bindable]
		public var endDate:DateField;
		
		public function CreateCurriculumEnrollmentCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function clear():void
		{
			nameInput.text = '';
			descriptionInput.text = '';
			curriculum = {};
			startDate.selectedDate = null;
			endDate.selectedDate = null;
		}
		
		public function populate(curriculum:Object):void
		{
			clear();
			this.curriculum = curriculum;
			nameInput.text = curriculum.name;
			descriptionInput.text = curriculum.description;
		}
		
		override public function getData():Object
		{
			return {
				'name' : nameInput.text,
				'description' : descriptionInput.text,
				'curriculum' : curriculum.id,
				'start' : startDate.selectedDate,
				'end' : endDate.selectedDate
			}
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			validators = validators.concat(nameInput.validator);
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