package net.poweru.components.dialogs.code
{
	import mx.containers.Form;
	import mx.controls.CheckBox;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	
	public class EditExamCode extends BaseEditTaskCode implements IEditDialog
	{
		public var nameInput:IGeneratedTextInput;
		public var titleInput:IGeneratedTextInput;
		public var descriptionInput:TextArea;
		[Bindable]
		public var passingScoreInput:TextInput;
		public var form:Form;
		[Bindable]
		public var activeInput:CheckBox;
		
		protected var activeInputWasPopulated:Boolean;
		
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
			activeInput.selected = true;
			activeInputWasPopulated = false;
			
			super.clear();
		}
		
		override public function getData():Object
		{
			var ret:Object =  {
				'id' : pk,
				'name' : nameInput.text,
				'title' : titleInput.text,
				'description' : descriptionInput.text,
				'achievements' : achievementDataSet.toArray(),
				'prerequisite_tasks' : prerequisiteTaskDataSet.toArray(),
				'prerequisite_achievements' : prerequisiteAchievementDataSet.toArray(),
				'passing_score' : passingScoreInput.text,
				'organization' : chosenOrganization.id
			};
			if (activeInputWasPopulated)
				ret['active'] = activeInput.selected;
			return ret;
		}
		
		override public function populate(data:Object, ...args):void
		{
			super.populate.apply(this, [data].concat(args));
			
			updateControlIfUnchanged(nameInput, 'text', data['name']);
			updateControlIfUnchanged(titleInput, 'text', data['title']);
			updateControlIfUnchanged(descriptionInput, 'text', data['description']);
			updateControlIfUnchanged(passingScoreInput, 'text', data['passing_score']);
			if (data.hasOwnProperty('active'))
			{
				activeInput.selected = data['active'];
				activeInputWasPopulated = true;
			}
			
			title = 'Edit Exam ' + data['name'];
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			validators = validators.concat(
				nameInput.validator,
				titleInput.validator
			);
			addControlChangeListener(form);
		}
	}
}