package net.poweru.components.dialogs.code
{
	import flash.events.Event;
	
	import mx.containers.Form;
	import mx.controls.DataGrid;
	import mx.controls.TextArea;
	import mx.events.CollectionEvent;
	import mx.events.FlexEvent;
	
	import net.poweru.Places;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.components.parts.EditTaskFees;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	import net.poweru.model.DataSet;
	
	public class EditFileDownloadCode extends BaseCRUDDialog implements IEditDialog
	{
		public var nameInput:IGeneratedTextInput;
		public var titleInput:IGeneratedTextInput;
		public var descriptionInput:TextArea;
		[Bindable]
		public var achievements:DataGrid;
		[Bindable]
		public var prerequisites:DataGrid;
		public var editTaskFees:EditTaskFees;
		public var form:Form;
		
		[Bindable]
		protected var achievementDataSet:DataSet;
		[Bindable]
		protected var prerequisiteDataSet:DataSet;
		protected var pk:Number;
		[Bindable]
		protected var chosenOrganization:Object;
		
		public function EditFileDownloadCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function clear():void
		{
			pk = 0;
			nameInput.text = '';
			titleInput.text = '';
			descriptionInput.text = '';
			chosenOrganization = null;
			achievementDataSet.source = [];
			achievementDataSet.refresh();
			prerequisiteDataSet.source = [];
			prerequisiteDataSet.refresh();
			editTaskFees.clear();
			
			super.clear();
		}
		
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			updateControlIfUnchanged(nameInput, 'text', data['name']);
			updateControlIfUnchanged(titleInput, 'text', data['title']);
			updateControlIfUnchanged(descriptionInput, 'text', data['description']);
			updateControlIfUnchanged(achievementDataSet, 'source', data['achievements']);
			chosenOrganization = data['organization'];
			achievementDataSet.refresh();
			updateControlIfUnchanged(prerequisiteDataSet, 'source', data['prerequisite_tasks']);
			prerequisiteDataSet.refresh();
			
			editTaskFees.taskID = pk;
			editTaskFees.dataSet = new DataSet(data['task_fees']);
		}
		
		override public function getData():Object
		{
			return {
				'id' : pk,
				'name' : nameInput.text,
				'title' : titleInput.text,
				'description' : descriptionInput.text,
				'achievements' : achievementDataSet.toArray(),
				'prerequisite_tasks' : prerequisiteDataSet.toArray(),
				'organization' : chosenOrganization.id
			}
		}
		
		override public function receiveChoice(choice:Object, chooserName:String):void
		{
			switch (chooserName)
			{
				case Places.CHOOSEACHIEVEMENT:
					if (achievementDataSet != null && achievementDataSet.findByPK(choice['id']) == null)
						achievementDataSet.addItem(choice);
					break;
				
				case Places.CHOOSETASK:
					if (prerequisiteDataSet != null && prerequisiteDataSet.findByPK(choice['id']) == null)
						prerequisiteDataSet.addItem(choice);
					break;
				
				case Places.CHOOSEORGANIZATION:
					chosenOrganization = choice;
					break;
			}
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			achievementDataSet = new DataSet();
			achievementDataSet.addEventListener(CollectionEvent.COLLECTION_CHANGE, onControlChanged);
			prerequisiteDataSet = new DataSet();
			prerequisiteDataSet.addEventListener(CollectionEvent.COLLECTION_CHANGE, onControlChanged);
			validators = validators.concat([
				nameInput.validator,
				titleInput.validator
			]);
			addControlChangeListener(form);
		}
		
		protected function onRemoveAchievement(event:Event):void
		{
			if (achievements.selectedItem != null)
			{
				achievementDataSet.removeByPK(achievements.selectedItem['id']);
				achievementDataSet.refresh();
			}
		}
		
		protected function onRemoveTask(event:Event):void
		{
			if (prerequisites.selectedItem != null)
			{
				prerequisiteDataSet.removeByPK(prerequisites.selectedItem['id']);
				prerequisiteDataSet.refresh();
			}
		}
	}
}