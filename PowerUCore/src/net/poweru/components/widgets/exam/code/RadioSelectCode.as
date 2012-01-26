package net.poweru.components.widgets.exam.code
{
	import mx.containers.VBox;
	import mx.controls.RadioButton;
	import mx.controls.RadioButtonGroup;
	import mx.events.FlexEvent;
	
	public class RadioSelectCode extends VBox implements IExamQuestionWidget
	{
		[Bindable]
		protected var _question:Object;
		public var buttonBox:VBox;
		public var radioButtonGroup:RadioButtonGroup;
		
		public function RadioSelectCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function isValid():Boolean
		{
			return (radioButtonGroup.selection != null);
		}
		
		public function set question(question:Object):void
		{
			_question = question;
		}
		
		protected function get answers():Array
		{
			return _question['answers'] as Array;
		}
		
		protected function initBool():void
		{
			initChoice([
				{'label' : 'True', 'value' : true},
				{'label' : 'False', 'value' : false}
			]);
		}
		
		protected function initChoice(answers:Array):void
		{
			for each (var answer:Object in answers)
			{
				var button:RadioButton = new RadioButton();
				button.label = answer['label'];
				button.value = answer['value'];
				button.data = answer['id'];
				button.group = radioButtonGroup;
				button.percentWidth = 100;
				buttonBox.addChild(button);
			}
		}
		
		public function getResponse():Object
		{
			return {
				'questionID' : _question['id'],
				'optionalParameters': {'answers' : [radioButtonGroup.selection.data]}
			};
		}
		
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			switch (_question['question_type'])
			{
				case 'bool':
				case 'choice':
					initChoice(_question['answers']);
					break;
			}
		}
	}
}