package net.poweru.components.student.interfaces
{
	import net.poweru.components.interfaces.IArrayPopulatedComponent;
	
	public interface IExamAssignments extends IArrayPopulatedComponent
	{
		function setExamSessions(data:Array):void;
	}
}