package net.poweru.components.dialogs.code
{
	import mx.containers.Form;
	import mx.controls.ComboBox;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.model.DataSet;
	
	public class EditSessionUserRoleRequirementCode extends BaseEditTaskCode implements IEditDialog
	{
		[Bindable]
		public var rolesCB:ComboBox;
		[Bindable]
		public var minInput:TextInput;
		[Bindable]
		public var maxInput:TextInput;
		public var form:Form;

		protected var session:Number;
		
		
		public function EditSessionUserRoleRequirementCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function clear():void
		{
			super.clear();
			
			session = Number.NaN;
			rolesCB.selectedIndex = -1;
			minInput.text = '';
			maxInput.text = '';
		}
		
		override public function populate(data:Object, ...args):void
		{
			super.populate.apply(this, [data].concat(args));
			
			session = data['session'];
			updateControlIfUnchanged(minInput, 'text', data['min']);
			updateControlIfUnchanged(maxInput, 'text', data['max']);
			rolesCB.dataProvider.source = args[0];
			rolesCB.dataProvider.refresh();
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
				'prerequisite_achievements' : prerequisiteAchievementDataSet.toArray(),
				'prerequisite_tasks' : prerequisiteTaskDataSet.toArray()
			};
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			rolesCB.dataProvider = new DataSet();
			addControlChangeListener(form);
		}
	}
}