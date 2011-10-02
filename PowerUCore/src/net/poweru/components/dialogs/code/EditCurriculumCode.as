package net.poweru.components.dialogs.code
{
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.generated.model.Curriculum.NameInput;
	
	public class EditCurriculumCode extends BaseCRUDDialog implements IEditDialog
	{
		public var nameInput:NameInput;
		protected var pk:Number;
		
		public function EditCurriculumCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function clear():void
		{
			nameInput.text = '';
		}
		
		override public function getData():Object
		{
			return {
				'id' : pk,
				'name' : nameInput.text
			};
		}
		
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			nameInput.text = data['name'];
			
			title = 'Edit Curriculum ' + data['name'];
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			validators = [nameInput.validator];
		}
	}
}