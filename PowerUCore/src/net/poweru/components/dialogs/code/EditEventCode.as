package net.poweru.components.dialogs.code
{
	import flash.events.Event;
	
	import mx.controls.DateField;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	import mx.validators.Validator;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.generated.model.Event.NameInput;
	import net.poweru.generated.model.Event.TitleInput;
	
	public class EditEventCode extends BaseCRUDDialog implements IEditDialog
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
		
		protected var pk:Number;
		
		public function EditEventCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
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