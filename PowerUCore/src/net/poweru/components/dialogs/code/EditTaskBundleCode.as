package net.poweru.components.dialogs.code
{
	import flash.events.Event;
	
	import mx.controls.CheckBox;
	import mx.controls.DataGrid;
	import mx.controls.TextArea;
	import mx.events.FlexEvent;
	
	import net.poweru.Places;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.generated.model.TaskBundle.NameInput;
	import net.poweru.model.ChooserResult;
	import net.poweru.model.DataSet;
	
	public class EditTaskBundleCode extends BaseCRUDDialog implements IEditDialog
	{
		public var nameInput:NameInput;
		public var descriptionInput:TextArea;
		[Bindable]
		public var tasks:DataGrid;
		[Bindable]
		public var activeInput:CheckBox;
		
		protected var activeInputWasPopulated:Boolean;
		
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
			activeInput.selected = true;
			activeInputWasPopulated = false;
		}
		
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			nameInput.text = data['name'];
			descriptionInput.text = data['description'];
			taskDataSet.source = data['tasks'];
			taskDataSet.refresh();
			if (data.hasOwnProperty('active'))
			{
				activeInput.selected = data['active'];
				activeInputWasPopulated = true;
			}
		}
		
		override public function getData():Object
		{
			var ret:Object = {
				'id' : pk,
				'name' : nameInput.text,
				'description' : descriptionInput.text,
				'tasks' : taskDataSet.toArray()
			};
			if (activeInputWasPopulated)
				ret['active'] = activeInput.selected;
			return ret;
		}
		
		override public function receiveChoice(choice:ChooserResult, chooserName:String):void
		{
			if (chooserName == Places.CHOOSETASK && chooserRequestTracker.doIWantThis(chooserName, choice.requestID) && taskDataSet != null && taskDataSet.findByPK(choice.value['id']) == null)
				taskDataSet.addItem(choice.value);
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