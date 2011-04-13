package net.poweru.components.dialogs.code
{
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.widgets.code.IMultipleSelect;
	
	import flash.events.Event;
	
	import net.poweru.generated.interfaces.IGeneratedTextInput;

	public class EditGroupCode extends BaseCRUDDialog implements IEditDialog
	{
		public var nameInput:IGeneratedTextInput;
		public var categoriesInput:IMultipleSelect;
		protected var pk:Number;
		
		public function EditGroupCode()
		{
			super();
		}
		
		public function clear():void
		{
			nameInput.text = '';
			categoriesInput.populate([], []);
		}
		
		override public function getData():Object
		{
			return {
				'id' : pk,
				'name' : nameInput.text,
				'categories' : categoriesInput.selectedItems
			}
		}
		
		// only additional argument should be an array of categories
		public function populate(data:Object, ...args):void
		{
			var categoryChoices:Array = args[0];
			
			pk = data['id'];
			nameInput.text = data['name'];
			categoriesInput.populate(categoryChoices, data['categories']);
			
			title = 'Edit Group ' + data['name'];
		}
		
		protected function onCreationComplete(event:Event):void
		{
			validators = [nameInput.validator];
		}
		
	}
}