package net.poweru.components.dialogs.code
{
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ICreateDialog;
	import net.poweru.generated.model.EventTemplate.NamePrefixInput;
	import net.poweru.generated.model.EventTemplate.TitleInput;
	
	public class CreateEventTemplateCode extends BaseCRUDDialog implements ICreateDialog
	{
		public var titleInput:TitleInput;
		public var namePrefixInput:NamePrefixInput;
		[Bindable]
		public var leadTimeInput:TextInput;
		public var descriptionInput:TextArea;
		
		public function CreateEventTemplateCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function getData():Object
		{
			return {
				'title' : titleInput.text,
				'name_prefix' : namePrefixInput.text,
				'lead_time' : leadTimeInput.text,
				'description' : descriptionInput.text
			};
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			validators = validators.concat(
				titleInput.validator,
				namePrefixInput.validator
			);
		}
		
		public function clear():void
		{
			titleInput.text = '';
			namePrefixInput.text = '';
			leadTimeInput.text = '';
			descriptionInput.text = '';
		}
	}
}