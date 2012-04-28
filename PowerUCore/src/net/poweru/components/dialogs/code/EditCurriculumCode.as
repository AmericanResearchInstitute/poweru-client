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
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	import net.poweru.model.ChooserResult;
	import net.poweru.model.DataSet;
	import net.poweru.utils.PKArrayCollection;
	import net.poweru.utils.SortedDataSetFactory;
	
	public class EditCurriculumCode extends BaseCRUDDialog implements IEditDialog
	{
		public var nameInput:IGeneratedTextInput;
		public var descriptionInput:TextArea;
		[Bindable]
		public var activeInput:CheckBox;
		[Bindable]
		public var tasks:DataGrid;
		[Bindable]
		protected var curriculumTaskAssociationDataSet:DataSet;
		protected var pk:Number;
		protected var activeInputWasPopulated:Boolean;
		[Bindable]
		protected var chosenOrganization:Object;
		
		public function EditCurriculumCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function clear():void
		{
			nameInput.text = '';
			descriptionInput.text = '';
			activeInput.selected = true;
			activeInputWasPopulated = false;
			curriculumTaskAssociationDataSet.source = [];
			curriculumTaskAssociationDataSet.refresh();
			chosenOrganization = null;
			super.clear();
		}
		
		override public function getData():Object
		{
			var ret:Object = {
				'id' : pk,
				'description' : descriptionInput.text,
				'curriculum_task_associations' : curriculumTaskAssociationDataSet.toArray(),
				'name' : nameInput.text,
				'organization' : chosenOrganization.id
			};
			if (activeInputWasPopulated)
				ret['active'] = activeInput.selected;
			return ret;
		}
		
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			nameInput.text = data['name'];
			descriptionInput.text = data['description'];
			curriculumTaskAssociationDataSet.source = data['curriculum_task_associations'];
			curriculumTaskAssociationDataSet.refresh();
			chosenOrganization = data['organization'];
			
			title = 'Edit Curriculum ' + data['name'];
			
			if (data.hasOwnProperty('active'))
			{
				activeInput.selected = data['active'];
				activeInputWasPopulated = true;
			}
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
								'task_type' : task1.type,
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
										'task_type' : task2.type,
										'task_bundle' : choice.value.id
									});
								}
							}
						}
						break;
					
					case Places.CHOOSEORGANIZATION:
						chosenOrganization = choice.value;
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
			curriculumTaskAssociationDataSet = SortedDataSetFactory.singleFieldSort('name');
			validators = validators.concat(nameInput.validator);
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