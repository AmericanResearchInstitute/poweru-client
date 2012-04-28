package net.poweru.components.dialogs.code
{
	import mx.controls.TextArea;
	import mx.events.FlexEvent;
	
	import net.poweru.Places;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ICreateDialog;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	import net.poweru.model.ChooserResult;
	
	public class CreateCurriculumCode extends BaseCRUDDialog implements ICreateDialog
	{
		[Bindable]
		public var nameInput:IGeneratedTextInput;
		public var descriptionInput:TextArea;
		
		[Bindable]
		protected var chosenOrganization:Object;
		
		public function CreateCurriculumCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function getData():Object
		{
			return {
				'name' : nameInput.text,
				'description' : descriptionInput.text,
				'organization' : chosenOrganization.id
			};
		}
		
		override public function clear():void
		{
			nameInput.text = '';
			descriptionInput.text = '';
			chosenOrganization = null;
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
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			focusManager.setFocus(nameInput);
			validators.push(nameInput.validator);
		}
	}
}