package net.poweru.components.dialogs.code
{
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.components.validators.RoomCapacityValidator;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	
	public class EditRoomCode extends BaseCRUDDialog implements IEditDialog
	{
		public var nameInput:IGeneratedTextInput;
		public var capacityInput:TextInput;
		
		protected var pk:Number;
		
		public function EditRoomCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function clear():void
		{
			nameInput.text = '';
			capacityInput.text = '';
		}
		
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			nameInput.text = data['name'];
			capacityInput.text = data['capacity'];
		}
		
		override public function getData():Object
		{
			return {
				'id' : pk,
				'name' : nameInput.text,
				'capacity' : capacityInput.text
			};
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			var capacityValidator:RoomCapacityValidator = new RoomCapacityValidator();
			capacityValidator.source = capacityInput;
			capacityValidator.property = 'text';
			
			validators = [
				nameInput.validator,
				capacityValidator
			];
			
			focusManager.setFocus(nameInput);
		}
	}
}