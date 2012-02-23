package net.poweru.components.dialogs.code
{
	import flash.events.Event;
	
	import mx.containers.Form;
	import mx.controls.ComboBox;
	import mx.controls.DataGrid;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	import net.poweru.Places;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.components.parts.EditTaskFees;
	import net.poweru.model.DataSet;
	
	public class EditSessionUserRoleRequirementCode extends BaseCRUDDialog implements IEditDialog
	{
		[Bindable]
		public var rolesCB:ComboBox;
		[Bindable]
		public var minInput:TextInput;
		[Bindable]
		public var maxInput:TextInput;
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
		protected var session:Number;
		protected var pk:Number;
		
		
		public function EditSessionUserRoleRequirementCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function clear():void
		{
			pk = Number.NaN;
			session = Number.NaN;
			rolesCB.selectedIndex = -1;
			minInput.text = '';
			maxInput.text = '';
			achievementDataSet.source = [];
			achievementDataSet.refresh();
			prerequisiteDataSet.source = [];
			prerequisiteDataSet.refresh();
			editTaskFees.clear();
		}
		
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			session = data['session'];
			updateControlIfUnchanged(minInput, 'text', data['min']);
			updateControlIfUnchanged(maxInput, 'text', data['max']);
			rolesCB.dataProvider.source = args[0];
			rolesCB.dataProvider.refresh();
			achievementDataSet.source = data['achievements'];
			achievementDataSet.refresh();
			prerequisiteDataSet.source = data['prerequisite_tasks'];
			prerequisiteDataSet.refresh();
			editTaskFees.taskID = pk;
			editTaskFees.dataSet = new DataSet(data['task_fees']);
		}
		
		override public function getData():Object
		{
			return {
				'id' : pk,
				'session' : session,
				'session_user_role' : {'id' : rolesCB.selectedItem.id, 'name' : rolesCB.selectedItem.name},
				'min' : minInput.text,
				'max' : maxInput.text,
				'achievements' : achievementDataSet.toArray(),
				'prerequisite_tasks' : prerequisiteDataSet.toArray()
			};
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
			}
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			rolesCB.dataProvider = new DataSet();
			achievementDataSet = new DataSet();
			prerequisiteDataSet = new DataSet();
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