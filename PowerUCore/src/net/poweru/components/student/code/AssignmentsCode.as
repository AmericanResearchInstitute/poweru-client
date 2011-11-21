package net.poweru.components.student.code
{
	import mx.containers.HBox;
	import mx.core.IContainer;
	
	import net.poweru.components.student.interfaces.IAssignments;
	
	public class AssignmentsCode extends HBox implements IAssignments
	{
		public var _fileDownloadsContainer:HBox;
		public var _examsContainer:HBox;
		public var _eventsContainer:HBox;
		
		public function AssignmentsCode()
		{
			super();
		}
		
		public function get fileDownloadsContainer():IContainer
		{
			return _fileDownloadsContainer;
		}
		
		public function get examsContainer():IContainer
		{
			return _examsContainer;
		}
		
		public function get eventsContainer():IContainer
		{
			return _eventsContainer;
		}

	}
}