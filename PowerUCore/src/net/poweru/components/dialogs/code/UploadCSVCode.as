package net.poweru.components.dialogs.code
{
	import flash.events.Event;
	import flash.net.FileReference;
	
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IUploadCSV;
	
	public class UploadCSVCode extends BaseCRUDDialog implements IUploadCSV
	{
		protected var csvFile:FileReference;
		[Bindable]
		public var fileLocation:TextInput;
		
		public function UploadCSVCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			clear();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function clear():void
		{
			fileLocation.text = '';
			csvFile = new FileReference();
			csvFile.addEventListener(Event.SELECT, onFileSelected, false, 0, true);
		}
		
		public function setModelName(name:String):void
		{
			title = name + ' CSV Upload';
		}
		
		protected function onFileSelected(event:Event):void
		{
			fileLocation.text = event.target.name;
		}
		
		protected function onAddedToStage(event:Event):void
		{
			clear();
		}
		
	}
}