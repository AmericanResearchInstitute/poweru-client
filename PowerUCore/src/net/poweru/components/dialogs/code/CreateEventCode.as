package net.poweru.components.dialogs.code
{
	import flash.events.Event;
	
	import mx.controls.DateField;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	import mx.validators.NumberValidator;
	import mx.validators.Validator;
	
	import net.poweru.Places;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ICreateDialog;
	import net.poweru.generated.model.Event.NameInput;
	import net.poweru.generated.model.Event.TitleInput;
	
	public class CreateEventCode extends BaseCRUDDialog implements ICreateDialog
	{
		public var nameInput:NameInput;
		public var titleInput:TitleInput;
		public var leadTimeInput:TextInput;
		[Bindable]
		public var startInput:DateField;
		[Bindable]
		public var endInput:DateField;
		public var descriptionInput:TextArea;
		public var extraValidators:Array;
		
		[Bindable]
		protected var chosenOrganization:Object;
		
		public function CreateEventCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function getData():Object
		{
			return {
				'name' : nameInput.text,
				'title' : titleInput.text,
				'lead_time' : leadTimeInput.text,
				'description' : descriptionInput.text,
				'start' : startInput.selectedDate,
				'end' : endInput.selectedDate,
				'organization' : chosenOrganization.id
			};
		}
		
		public function clear():void
		{
			nameInput.text = '';
			titleInput.text = '';
			leadTimeInput.text = '';
			descriptionInput.text = '';
			startInput.selectedDate = null;
			endInput.selectedDate = null;
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			focusManager.setFocus(nameInput);
			
			validators = [
				nameInput.validator,
				titleInput.validator,
			];
			for each (var validator:Validator in extraValidators)
				validators.push(validator);
		}
		
		override public function receiveChoice(choice:Object, chooserName:String):void
		{
			if (chooserName == Places.CHOOSEORGANIZATION)
				chosenOrganization = choice;
		}
		
		protected function onStartDateChosen(event:Event):void
		{
			// subtract one day
			endInput.disabledRanges = [{'rangeEnd': new Date(startInput.selectedDate.getTime() - 1000*60*60*24)}];
			
			// if the newly chosen start date is after the end date, erase the end date so the user must choose a new one
			if (endInput.selectedDate != null && endInput.selectedDate.getTime() < startInput.selectedDate.getTime())
				endInput.selectedDate = null;
		}
	}
}