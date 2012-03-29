package net.poweru.components.dialogs.code
{
	import mx.containers.Form;
	import mx.controls.DataGrid;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.events.CollectionEvent;
	import mx.events.FlexEvent;
	
	import net.poweru.Places;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.components.parts.EditTaskFees;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	import net.poweru.model.ChooserResult;
	import net.poweru.model.DataSet;
	
	public class EditExamCode extends BaseCRUDDialog implements IEditDialog
	{
		public var nameInput:IGeneratedTextInput;
		public var titleInput:IGeneratedTextInput;
		public var descriptionInput:TextArea;
		[Bindable]
		public var passingScoreInput:TextInput;
		protected var pk:Number;
		[Bindable]
		public var achievements:DataGrid;
		[Bindable]
		public var prerequisites:DataGrid;
		[Bindable]
		protected var achievementDataSet:DataSet;
		[Bindable]
		protected var prerequisiteDataSet:DataSet;
		public var editTaskFees:EditTaskFees;
		public var form:Form;
		[Bindable]
		protected var chosenOrganization:Object;
		
		public function EditExamCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function clear():void
		{
			nameInput.text = '';
			titleInput.text = '';
			descriptionInput.text = '';
			passingScoreInput.text = '';
			chosenOrganization = null;
			achievementDataSet.source = [];
			achievementDataSet.refresh();
			prerequisiteDataSet.source = [];
			prerequisiteDataSet.refresh();
			editTaskFees.clear();
			
			super.clear();
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
				'passing_score' : passingScoreInput.text,
				'organization' : chosenOrganization.id
			}
		}
		
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			updateControlIfUnchanged(nameInput, 'text', data['name']);
			updateControlIfUnchanged(titleInput, 'text', data['title']);
			updateControlIfUnchanged(descriptionInput, 'text', data['description']);
			updateControlIfUnchanged(passingScoreInput, 'text', data['passing_score']);
			updateControlIfUnchanged(achievementDataSet, 'source', data['achievements']);
			chosenOrganization = data['organization'];
			achievementDataSet.refresh();
			updateControlIfUnchanged(prerequisiteDataSet, 'source', data['prerequisite_tasks']);
			prerequisiteDataSet.refresh();
			
			title = 'Edit Exam ' + data['name'];
			
			editTaskFees.taskID = pk;
			editTaskFees.dataSet = new DataSet(data['task_fees']);
		}
		
		override public function receiveChoice(choice:ChooserResult, chooserName:String):void
		{
			if (chooserRequestTracker.doIWantThis(chooserName, choice.requestID))
			{
				switch (chooserName)
				{
					case Places.CHOOSEACHIEVEMENT:
						if (achievementDataSet != null && achievementDataSet.findByPK(choice.value['id']) == null)
							achievementDataSet.addItem(choice.value);
						break;
					
					case Places.CHOOSETASK:
						if (prerequisiteDataSet != null && prerequisiteDataSet.findByPK(choice.value['id']) == null)
							prerequisiteDataSet.addItem(choice.value);
						break;
					
					case Places.CHOOSEORGANIZATION:
						chosenOrganization = choice.value;
						break;
				}
			}
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			validators = validators.concat(
				nameInput.validator,
				titleInput.validator
			);
			achievementDataSet = new DataSet();
			achievementDataSet.addEventListener(CollectionEvent.COLLECTION_CHANGE, onControlChanged);
			prerequisiteDataSet = new DataSet();
			prerequisiteDataSet.addEventListener(CollectionEvent.COLLECTION_CHANGE, onControlChanged);
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