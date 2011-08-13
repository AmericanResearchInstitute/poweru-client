package net.poweru.components.dialogs.code
{
	import flash.events.Event;
	
	import mx.controls.TextArea;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.generated.model.Exam.NameInput;
	import net.poweru.generated.model.Exam.TitleInput;
	
	public class EditExamCode extends BaseCRUDDialog implements IEditDialog
	{
		public var nameInput:NameInput;
		public var titleInput:TitleInput;
		public var descriptionInput:TextArea;
		protected var pk:Number;
		
		public function EditExamCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function clear():void
		{
			nameInput.text = '';
			titleInput.text = '';
			descriptionInput.text = '';
		}
		
		override public function getData():Object
		{
			return {
				'id' : pk,
				'name' : nameInput.text,
				'title' : titleInput.text,
				'description' : descriptionInput.text
			}
		}
		
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			nameInput.text = data['name'];
			titleInput.text = data['title'];
			descriptionInput.text = data['description'];
			
			title = 'Edit Exam ' + data['name'];
		}
		
		protected function onCreationComplete(event:Event):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			validators = [nameInput.validator, titleInput.validator];
		}
	}
}