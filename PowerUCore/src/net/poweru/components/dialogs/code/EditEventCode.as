package net.poweru.components.dialogs.code
{
	import flash.events.Event;
	
	import mx.controls.DateField;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	import mx.validators.Validator;
	
	import net.poweru.Places;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	import net.poweru.model.ChooserResult;
	
	public class EditEventCode extends BaseCRUDDialog implements IEditDialog
	{
		public var nameInput:IGeneratedTextInput;
		public var titleInput:IGeneratedTextInput;
		public var leadTimeInput:TextInput;
		[Bindable]
		public var startInput:DateField;
		[Bindable]
		public var endInput:DateField;
		public var descriptionInput:TextArea;
		public var extraValidators:Array;
		[Bindable]
		protected var chosenOrganization:Object;
		
		protected var pk:Number;
		
		public function EditEventCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function clear():void
		{
			nameInput.text = '';
			titleInput.text = '';
			leadTimeInput.text = '';
			descriptionInput.text = '';
			startInput.selectedDate = null;
			endInput.selectedDate = null;
			chosenOrganization = null;
		}
		
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			nameInput.text = data['name'];
			titleInput.text = data['title'];
			leadTimeInput.text = data['lead_time'];
			descriptionInput.text = data['description'];
			startInput.selectedDate = data['start'];
			endInput.selectedDate = data['end'];
			if (startInput.selectedDate != null)
				restrictEndDate();
			chosenOrganization = data['organization'];
		}		
		
		override public function getData():Object
		{
			return {
				'id' : pk,
				'name' : nameInput.text,
				'title' : titleInput.text,
				'lead_time' : leadTimeInput.text,
				'description' : descriptionInput.text,
				'start' : startInput.selectedDate,
				'end' : endInput.selectedDate,
				'organization' : chosenOrganization.id
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
		
		override public function receiveChoice(choice:ChooserResult, chooserName:String):void
		{
			if (chooserRequestTracker.doIWantThis(chooserName, choice.requestID))
			{
				switch (chooserName)
				{
					case Places.CHOOSEORGANIZATION:
						chosenOrganization = choice.value;
						break;
				}
			}
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
		
		protected function onStartDateChosen(event:Event):void
		{
			restrictEndDate();
		}
		
	}
}