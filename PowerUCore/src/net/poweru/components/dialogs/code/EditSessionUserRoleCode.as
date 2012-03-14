package net.poweru.components.dialogs.code
{
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	
	public class EditSessionUserRoleCode extends BaseCRUDDialog implements IEditDialog
	{
		public var nameInput:IGeneratedTextInput;
		
		protected var pk:Number;
		
		public function EditSessionUserRoleCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function clear():void
		{
			pk = -1;
			nameInput.text = '';
		}
		
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			nameInput.text = data['name'];
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			validators = [nameInput.validator];
		}
		
		override public function getData():Object
		{
			return {
				'id' : pk,
				'name' : nameInput.text
			}
		}
	}
}