package net.poweru.components.widgets.exam.code
{
	import mx.core.IUIComponent;

	public interface IExamQuestionWidget extends IUIComponent
	{
		function set question(question:Object):void;
		function isValid():Boolean;
		function getResponse():Object;
	}
}