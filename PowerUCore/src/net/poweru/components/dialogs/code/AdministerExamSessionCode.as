package net.poweru.components.dialogs.code
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.controls.Alert;
	
	import net.poweru.Constants;
	import net.poweru.components.dialogs.BaseDialog;
	import net.poweru.components.interfaces.IAdministerExamSession;
	import net.poweru.components.widgets.exam.CheckboxSelectMultiple;
	import net.poweru.components.widgets.exam.RadioSelect;
	import net.poweru.components.widgets.exam.code.IExamQuestionWidget;
	import net.poweru.events.ViewEvent;
	
	public class AdministerExamSessionCode extends BaseDialog implements IAdministerExamSession
	{
		public var questionBox:VBox;
		
		[Bindable]
		protected var currentQuestions:Object;
		[Bindable]
		protected var questionPoolTitle:String;
		
		public function AdministerExamSessionCode()
		{
			super();
		}
		
		public function populate(data:Object):void
		{
			removeQuestionWidgets();
			currentQuestions = data;
			var questionPools:Array = currentQuestions['question_pools'];
			if (questionPools != null && questionPools.length > 0)
			{
				questionPoolTitle = questionPools[0]['title'];
				addQuestionWidgets();
			}
		}
		
		public function clear():void
		{
			populate({});
			removeQuestionWidgets();
		}
		
		protected function collectResponses():Array
		{
			var ret:Array = [];
			
			for each (var widget:IExamQuestionWidget in questionBox.getChildren())
			{
				var response:Object = widget.getResponse();
				response['examSessionID'] = currentQuestions['id'];
				ret.push(response);
			}
			
			return ret;
		}
		
		protected function onSubmit(event:MouseEvent):void
		{
			var valid:Boolean = true;
			
			for each (var widget:IExamQuestionWidget in questionBox.getChildren())
			{
				if (widget.isValid() == false)
				{
					valid = false;
					break;
				}
			}
			
			if (valid)
			{
				dispatchEvent(new ViewEvent(ViewEvent.SUBMIT, collectResponses()));
			}
			else
			{
				Alert.show('Please answer all required questions.');
			}
		}
		
		protected function addQuestionWidgets():void
		{
			// Yes, we assume that there is only one question pool, because that is the way
			// the back end seems to be written.
			var questionPool:Array = currentQuestions['question_pools'][0]['questions'];
			for each (var question:Object in questionPool)
			{
				var widget:IExamQuestionWidget = getWidget(question);
				questionBox.addChild(widget as DisplayObject);
			}
		}
		
		protected function removeQuestionWidgets():void
		{
			questionBox.removeAllChildren();
		}
		
		protected function getWidget(question:Object):IExamQuestionWidget
		{
			var ret:IExamQuestionWidget;
			
			switch (question['widget'])
			{
				case Constants.RADIOSELECT:
					ret = new RadioSelect();
					break;
				
				case Constants.CHECKBOXSELECTMULTIPLE:
					ret = new CheckboxSelectMultiple();
					break;
			}
			
			ret.question = question;
			return ret;
		}
	}
}