package net.poweru.components.dialogs.code
{
	import flash.events.Event;
	import flash.net.FileReference;
	
	import mx.containers.HBox;
	import mx.controls.Button;
	import mx.controls.ProgressBar;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	import net.poweru.Places;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IUploadFileDownload;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	
	public class UploadFileDownloadCode extends BaseCRUDDialog implements IUploadFileDownload
	{
		public var nameInput:IGeneratedTextInput;
		[Bindable]
		public var description:TextArea;
		[Bindable]
		public var fileNameInput:TextInput;
		[Bindable]
		public var file:FileReference;
		public var upload:Button;
		public var uploadProgress:ProgressBar;
		public var uploadCancel:Button;
		public var progressBox:HBox;
		
		[Bindable]
		protected var chosenOrganization:Object;
		
		public function UploadFileDownloadCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function getFileDownload():FileReference
		{
			return file;
		}
		
		override public function clear():void
		{
			nameInput.text = '';
			description.text = '';
			progressBoxVisibility = false;
			chosenOrganization = null;
			
			resetFileref();
		}
		
		protected function selectFile():void
		{
			file.browse();
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			resetFileref();
			validators.push(nameInput.validator);
		}
		
		protected function onFileSelected(event:Event):void
		{
			fileNameInput.text = event.target.name;
		}
		
		protected function onUploadCancel(event:Event):void
		{
			uploadCancel.enabled = false;
			file.cancel();
		}
		
		public function getFile():FileReference
		{
			return file;
		}
		
		override public function getData():Object
		{
			return {
				'name' : nameInput.text,
				'description' : description.text,
				'organization' : chosenOrganization.id
			};
		}
		
		override public function receiveChoice(choice:Object, chooserName:String):void
		{
			if (chooserName == Places.CHOOSEORGANIZATION)
				chosenOrganization = choice;
		}
		
		public function set progressBoxVisibility(visible:Boolean):void
		{
			progressBox.visible = visible;
		}
		
		private function resetFileref():void
		{
			if (file != null)
			{
				file.removeEventListener(Event.SELECT, onFileSelected);
				file.removeEventListener(Event.CANCEL, onUploadEvent);
				file.removeEventListener(Event.COMPLETE, onUploadEvent);
				file.removeEventListener(Event.OPEN, onUploadEvent);
			}
			file = new FileReference();
			file.addEventListener(Event.SELECT, onFileSelected, false, 0, true);
			file.addEventListener(Event.CANCEL, onUploadEvent, false, 0, true);
			file.addEventListener(Event.COMPLETE, onUploadEvent, false, 0, true);
			file.addEventListener(Event.OPEN, onUploadEvent, false, 0, true);
			fileNameInput.text = '';
		}
		
		protected function onUploadEvent(event:Event):void
		{
			switch (event.type)
			{
				case Event.CANCEL:
					uploadCancel.enabled = false;
					uploadProgress.source = null;
					break;
				
				case Event.COMPLETE:
					uploadCancel.enabled = false;
					break;
				
				case Event.OPEN:
					progressBoxVisibility = true;
					uploadCancel.enabled = true;
					uploadProgress.source = file;
					break;
			}
		}
	}
}