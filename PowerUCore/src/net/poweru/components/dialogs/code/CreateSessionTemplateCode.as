package net.poweru.components.dialogs.code
{
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	import mx.validators.NumberValidator;
	import mx.validators.NumberValidatorDomainType;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ICreateSessionTemplate;
	import net.poweru.components.widgets.LeadTimeInput;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	
	public class CreateSessionTemplateCode extends BaseCRUDDialog implements ICreateSessionTemplate
	{
		public var shortNameInput:IGeneratedTextInput;
		public var fullNameInput:IGeneratedTextInput;
		public var leadTimeInput:LeadTimeInput;
		public var sequenceInput:TextInput;
		public var descriptionInput:TextArea;
		
		protected var eventTemplate:Object;
		
		public function CreateSessionTemplateCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function populateEventTemplateData(data:Object):void
		{
			eventTemplate = data;
		}
		
		override public function clear():void
		{
			shortNameInput.text = '';
			fullNameInput.text = '';
			leadTimeInput.clear();
			sequenceInput.text = '';
			descriptionInput.text = '';
		}
		
		override public function getData():Object
		{
			return {
				'event_template' : eventTemplate['id'],
				'shortname' : shortNameInput.text,
				'fullname' : fullNameInput.text,
				'lead_time' : leadTimeInput.seconds,
				'description' : descriptionInput.text,
				'sequence' : sequenceInput.text,
				'price' : 0,
				'version' : '',
				'active' : true,
				'modality' : 'Generic'
			};
		}
		
		protected function createSequenceValidator():NumberValidator
		{
			var validator:NumberValidator = new NumberValidator();
			validator.allowNegative = false;
			validator.domain = NumberValidatorDomainType.INT;
			validator.source = sequenceInput;
			validator.property = 'text';
			validator.required = true;
			return validator;
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			validators = [
				shortNameInput.validator,
				fullNameInput.validator,
				leadTimeInput.validator,
				createSequenceValidator()
			];
			focusManager.setFocus(shortNameInput);
		}
	}
}