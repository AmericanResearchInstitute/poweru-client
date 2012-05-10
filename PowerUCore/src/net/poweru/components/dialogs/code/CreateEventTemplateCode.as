package net.poweru.components.dialogs.code
{
	import mx.controls.TextArea;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ICreateDialog;
	import net.poweru.components.widgets.LeadTimeInput;
	import net.poweru.generated.model.EventTemplate.NamePrefixInput;
	import net.poweru.generated.model.EventTemplate.TitleInput;
	
	public class CreateEventTemplateCode extends BaseCRUDDialog implements ICreateDialog
	{
		public var titleInput:TitleInput;
		public var namePrefixInput:NamePrefixInput;
		[Bindable]
		public var leadTimeInput:LeadTimeInput;
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
				'lead_time' : leadTimeInput.seconds,
				'description' : descriptionInput.text
			};
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			validators = [
				leadTimeInput.validator,
				titleInput.validator,
				namePrefixInput.validator
			];
		}
		
		override public function clear():void
		{
			titleInput.text = '';
			namePrefixInput.text = '';
			leadTimeInput.clear();
			descriptionInput.text = '';
		}
	}
}