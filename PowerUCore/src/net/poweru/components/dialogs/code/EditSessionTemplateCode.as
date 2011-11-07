package net.poweru.components.dialogs.code
{
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	
	public class EditSessionTemplateCode extends BaseCRUDDialog implements IEditDialog
	{
		public var shortNameInput:IGeneratedTextInput;
		public var fullNameInput:IGeneratedTextInput;
		public var leadTimeInput:TextInput;
		public var sequenceInput:TextInput;
		public var descriptionInput:TextArea;
		
		protected var pk:Number;
		
		public function EditSessionTemplateCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function clear():void
		{
			shortNameInput.text = '';
			fullNameInput.text = '';
			leadTimeInput.text = '';
			sequenceInput.text = '';
			descriptionInput.text = '';
		}
		
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			
			shortNameInput.text = data['shortname'];
			fullNameInput.text = data['fullname'];
			leadTimeInput.text = data['lead_time'];
			sequenceInput.text = data['sequence'];
			descriptionInput.text = data['description'];
		}
		
		override public function getData():Object
		{
			return {
				'id' : pk,
				'shortname' : shortNameInput.text,
				'fullname' : fullNameInput.text,
				'lead_time' : leadTimeInput.text,
				'description' : descriptionInput.text,
				'sequence' : sequenceInput.text
			};
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			validators = [
				shortNameInput.validator,
				fullNameInput.validator
			];
		}
	}
}