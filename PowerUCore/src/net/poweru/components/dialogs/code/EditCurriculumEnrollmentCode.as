package net.poweru.components.dialogs.code
{
	import flash.events.Event;
	
	import mx.controls.DateField;
	import mx.controls.Label;
	import mx.controls.TextArea;
	import mx.events.FlexEvent;
	
	import net.poweru.Places;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	import net.poweru.model.ChooserResult;
	
	public class EditCurriculumEnrollmentCode extends BaseCRUDDialog implements IEditDialog
	{
		public var nameInput:IGeneratedTextInput;
		public var descriptionInput:TextArea;
		[Bindable]
		public var startInput:DateField;
		[Bindable]
		public var endInput:DateField;
		[Bindable]
		protected var chosenOrganization:Object;
		
		protected var pk:Number;
		
		public function EditCurriculumEnrollmentCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			nameInput.text = data['name'];
			descriptionInput.text = data['description'];
			chosenOrganization = data['organization'];
			startInput.selectedDate = data['start'];
			endInput.selectedDate = data['end'];
			if (startInput.selectedDate != null)
				restrictEndDate();
		}
		
		override public function clear():void
		{
			startInput.selectedDate = null;
			endInput.selectedDate = null;
			descriptionInput.text = '';
			nameInput.text = '';
			chosenOrganization = null;
		}
		
		override public function getData():Object
		{
			return {
				'id' : pk,
				'description' : descriptionInput.text,
				'name' : nameInput.text,
				'organization' : chosenOrganization.id,
				'start' : startInput.selectedDate,
				'end' : endInput.selectedDate
			};
		}
		
		override public function receiveChoice(choice:ChooserResult, chooserName:String):void
		{
			if (chooserRequestTracker.doIWantThis(chooserName, choice.requestID))
			{
				switch (chooserName)
				{
					case Places.CHOOSEORGANIZATION:
						chosenOrganization = choice.value;
						break;
					
					default:
						super.receiveChoice(choice, chooserName);
				}
			}
		}
		
		protected function restrictEndDate():void
		{
			// subtract one day
			endInput.disabledRanges = [{'rangeEnd': new Date(startInput.selectedDate.getTime() - 1000*60*60*24)}];
			
			// if the newly chosen start date is after the end date, erase the end date so the user must choose a new one
			if (endInput.selectedDate != null && endInput.selectedDate.getTime() < startInput.selectedDate.getTime())
				endInput.selectedDate = null;
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			validators = validators.concat(nameInput.validator);
		}
		
		protected function onStartDateChosen(event:Event):void
		{
			restrictEndDate();
		}
	}
}