package net.poweru.components.dialogs.code
{
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ICreateSessionTemplate;
	import net.poweru.generated.model.SessionTemplate.FullnameInput;
	import net.poweru.generated.model.SessionTemplate.ShortnameInput;
	
	public class CreateSessionTemplateCode extends BaseCRUDDialog implements ICreateSessionTemplate
	{
		public var fullNameInput:FullnameInput;
		public var leadTimeInput:TextInput;
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
		
		public function clear():void
		{
			fullNameInput.text = '';
			leadTimeInput.text = '';
			sequenceInput.text = '';
			descriptionInput.text = '';
		}
		
		override public function getData():Object
		{
			return {
				'event_template' : eventTemplate['id'],
				'shortname' : '',
				'fullname' : fullNameInput.text,
				'lead_time' : leadTimeInput.text,
				'description' : descriptionInput.text,
				'sequence' : sequenceInput.text,
				'price' : 0,
				'version' : '',
				'active' : true,
				'modality' : 'Generic'
			};
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			validators = [
				fullNameInput.validator
			];
			focusManager.setFocus(fullNameInput);
		}
	}
}