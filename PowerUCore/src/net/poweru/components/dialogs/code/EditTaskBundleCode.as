package net.poweru.components.dialogs.code
{
	import flash.events.Event;
	
	import mx.controls.DataGrid;
	import mx.controls.TextArea;
	import mx.events.FlexEvent;
	
	import net.poweru.Places;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.generated.model.TaskBundle.NameInput;
	import net.poweru.model.DataSet;
	
	public class EditTaskBundleCode extends BaseCRUDDialog implements IEditDialog
	{
		public var nameInput:NameInput;
		public var descriptionInput:TextArea;
		[Bindable]
		public var tasks:DataGrid;
		
		protected var pk:Number;
		[Bindable]
		protected var taskDataSet:DataSet;
		
		public function EditTaskBundleCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function clear():void
		{
			pk = Number.NaN;
			nameInput.text = '';
			descriptionInput.text = '';
			
			taskDataSet.source = [];
			taskDataSet.refresh();
		}
		
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			nameInput.text = data['name'];
			descriptionInput.text = data['description'];
			taskDataSet.source = data['tasks'];
			taskDataSet.refresh();
		}
		
		override public function getData():Object
		{
			return {
				'id' : pk,
				'name' : nameInput.text,
				'description' : descriptionInput.text,
				'tasks' : taskDataSet.toArray()
			}
		}
		
		override public function receiveChoice(choice:Object, chooserName:String):void
		{
			if (chooserName == Places.CHOOSETASK && taskDataSet != null && taskDataSet.findByPK(choice['id']) == null)
				taskDataSet.addItem(choice);
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			taskDataSet = new DataSet();
			validators = [nameInput.validator];
		}
		
		protected function onRemoveTask(event:Event):void
		{
			if (tasks.selectedItem != null)
			{
				taskDataSet.removeByPK(tasks.selectedItem['id']);
				taskDataSet.refresh();
			}
		}
	}
}