package net.poweru.components.dialogs.code
{
	import mx.controls.CheckBox;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	
	public class EditGroupCode extends BaseCRUDDialog implements IEditDialog
	{
		public var nameInput:IGeneratedTextInput;
		[Bindable]
		public var activeInput:CheckBox;
		
		protected var activeInputWasPopulated:Boolean;
		protected var pk:Number;
		
		public function EditGroupCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function clear():void
		{
			nameInput.text = '';
			activeInput.selected = true;
			activeInputWasPopulated = false;
		}
		
		override public function getData():Object
		{
			var ret:Object = {
				'id' : pk,
				'name' : nameInput.text
			};
			if (activeInputWasPopulated)
				ret['active'] = activeInput.selected;
			return ret;
		}
		
		// only additional argument should be an array of categories
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			nameInput.text = data['name'];
			title = 'Edit Group ' + data['name'];
			if (data.hasOwnProperty('active'))
			{
				activeInput.selected = data['active'];
				activeInputWasPopulated = true;
			}
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			validators = [nameInput.validator];
		}
	}
}