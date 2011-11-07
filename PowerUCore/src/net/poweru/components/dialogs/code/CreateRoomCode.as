package net.poweru.components.dialogs.code
{
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ICreateRoom;
	import net.poweru.components.validators.RoomCapacityValidator;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	
	public class CreateRoomCode extends BaseCRUDDialog implements ICreateRoom
	{
		public var nameInput:IGeneratedTextInput;
		public var capacityInput:TextInput;
		
		[Bindable]
		protected var venue:Object;
		
		public function CreateRoomCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function populateVenueData(data:Object):void
		{
			venue = data;
		}
		
		public function clear():void
		{
			nameInput.text = '';
			capacityInput.text = '';
			venue = null;
		}
		
		override public function getData():Object
		{
			return {
				'name' : nameInput.text,
				'capacity' : capacityInput.text,
				'venue' : venue['id']
			}
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