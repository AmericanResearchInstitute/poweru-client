package net.poweru.components.dialogs.code
{
	import flash.events.Event;
	
	import mx.controls.DataGrid;
	import mx.controls.TextArea;
	import mx.events.FlexEvent;
	
	import net.poweru.Places;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	import net.poweru.model.ChooserResult;
	import net.poweru.model.DataSet;
	import net.poweru.utils.PKArrayCollection;
	
	public class EditCurriculumCode extends BaseCRUDDialog implements IEditDialog
	{
		public var nameInput:IGeneratedTextInput;
		public var descriptionInput:TextArea;
		[Bindable]
		public var tasks:DataGrid;
		[Bindable]
		protected var curriculumTaskAssociationDataSet:DataSet;
		protected var pk:Number;
		
		public function EditCurriculumCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function clear():void
		{
			nameInput.text = '';
			descriptionInput.text = '';
			curriculumTaskAssociationDataSet.source = [];
			curriculumTaskAssociationDataSet.refresh();
		}
		
		override public function getData():Object
		{
			return {
				'id' : pk,
				'description' : descriptionInput.text,
				'curriculum_task_associations' : curriculumTaskAssociationDataSet.toArray(),
				'name' : nameInput.text
			};
		}
		
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			nameInput.text = data['name'];
			descriptionInput.text = data['description'];
			curriculumTaskAssociationDataSet.source = data['curriculum_task_associations'];
			curriculumTaskAssociationDataSet.refresh();
			
			title = 'Edit Curriculum ' + data['name'];
		}
		
		override public function receiveChoice(choice:ChooserResult, chooserName:String):void
		{
			if (chooserRequestTracker.doIWantThis(chooserName, choice.requestID))
			{
				switch (chooserName)
				{
					case Places.CHOOSETASK:
						if (curriculumTaskAssociationDataSet != null)
						{
							var task1:Object = choice.value;
							curriculumTaskAssociationDataSet.addItem({
								'task' : task1.id,
								'task_name' : task1.name
							});
						}
						break;
					
					case Places.CHOOSETASKBUNDLE:
						if (curriculumTaskAssociationDataSet != null)
						{
							for each (var task2:Object in (choice.value.tasks as Array))
							{
								if (curriculumTaskAssociationDataSet.findByKey('task', task2.id) == null)
								{
									curriculumTaskAssociationDataSet.addItem({
										'task' : task2.id,
										'task_name' : task2.name,
										'task_bundle' : choice.value.id
									});
								}
							}
						}
						break;
				}
			}
		}

		protected function get chosenTasks():Array
		{
			return new PKArrayCollection(curriculumTaskAssociationDataSet.toArray(), 'task').toArray();
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			curriculumTaskAssociationDataSet = new DataSet();
			validators = [nameInput.validator];
		}
		
		protected function onRemoveTask(event:Event):void
		{
			if (tasks.selectedItem != null)
			{
				curriculumTaskAssociationDataSet.removeItemAt(curriculumTaskAssociationDataSet.getItemIndex(tasks.selectedItem));
				curriculumTaskAssociationDataSet.refresh();
			}
		}
	}
}