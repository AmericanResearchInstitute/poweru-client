package net.poweru.components.dialogs.code
{
	import mx.controls.TextArea;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ICreateDialog;
	
	public class CreateExamFromXMLCode extends BaseCRUDDialog implements ICreateDialog
	{
		[Bindable]
		public var xmlInput:TextArea;
		
		public function CreateExamFromXMLCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function clear():void
		{
			xmlInput.text = '';
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			validators = [];
			focusManager.setFocus(xmlInput);
		}
		
		override public function getData():Object
		{
			return {'xml' : xmlInput.text};
		}
	}
}