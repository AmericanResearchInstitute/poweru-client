package net.poweru.components.dialogs.code
{
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	import mx.validators.NumberValidator;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	
	public class EditEventTemplateCode extends BaseCRUDDialog implements IEditDialog
	{
		public var titleInput:IGeneratedTextInput;
		public var namePrefixInput:IGeneratedTextInput;
		[Bindable]
		public var leadTimeInput:TextInput;
		public var descriptionInput:TextArea;
		
		public var leadTimeInputValidator:NumberValidator;
		
		protected var pk:Number;
		
		public function EditEventTemplateCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function clear():void
		{
			pk = 0;
			titleInput.text = '';
			namePrefixInput.text = '';
			leadTimeInput.text = '';
			descriptionInput.text = '';
		}
		
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			titleInput.text = data['title'];
			namePrefixInput.text = data['name_prefix'];
			leadTimeInput.text = data['lead_time'];
			descriptionInput.text = data['description'];
		}
		
		override public function getData():Object
		{
			return {
				'id' : pk,
				'title' : titleInput.text,
				'name_prefix' : namePrefixInput.text,
				'lead_time' : leadTimeInput.text,
				'description' : descriptionInput.text
			};
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			validators = [
				titleInput.validator,
				namePrefixInput.validator,
				leadTimeInputValidator
			];
		}
	}
}