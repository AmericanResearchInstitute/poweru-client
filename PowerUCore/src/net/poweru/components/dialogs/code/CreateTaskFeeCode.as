package net.poweru.components.dialogs.code
{
	import mx.containers.Form;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	import mx.utils.UIDUtil;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ICreateTaskFee;
	import net.poweru.generated.model.TaskFee.NameInput;
	
	public class CreateTaskFeeCode extends BaseCRUDDialog implements ICreateTaskFee
	{
		public var nameInput:NameInput;
		[Bindable]
		public var priceInput:TextInput;
		
		protected var _taskID:Number;
		
		public function CreateTaskFeeCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function clear():void
		{
			nameInput.text = '';
			priceInput.text = '';
			_taskID = Number.NaN;
		}
		
		override public function getData():Object
		{
			return {
				'name' : nameInput.text,
				'price' : priceInput.text,
				'task' : _taskID,
				'sku' : UIDUtil.createUID(),
				'description' : ''
			};
		}
		
		public function set taskID(data:Number):void
		{
			_taskID = data;
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			validators.push(nameInput.validator);
		}
	}
}