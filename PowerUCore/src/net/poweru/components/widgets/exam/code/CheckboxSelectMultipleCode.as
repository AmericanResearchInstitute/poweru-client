package net.poweru.components.widgets.exam.code
{
	import mx.containers.VBox;
	import mx.controls.CheckBox;
	import mx.events.FlexEvent;
	
	public class CheckboxSelectMultipleCode extends VBox implements IExamQuestionWidget
	{
		[Bindable]
		protected var _question:Object;
		public var buttonBox:VBox;
		
		public function CheckboxSelectMultipleCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function set question(question:Object):void
		{
			_question = question;
		}
		
		// This is always valid
		public function isValid():Boolean
		{
			return true;
		}
		
		public function getResponse():Object
		{
			var selected:Array = [];
			
			for each (var cb:CheckBox in buttonBox.getChildren())
			{
				if (cb.selected)
				{
					selected.push(cb.data);
				}
			}
			
			return {
				'questionID' : _question['id'],
				'optionalParameters': {'answers' : selected}
			};
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			for each (var answer:Object in _question['answers'])
			{
				var cb:CheckBox = new CheckBox();
				cb.label = answer['label'];
				cb.data = answer['id'];
				buttonBox.addChild(cb);
			}
		}
	}
}