package net.poweru.components.student.interfaces
{
	import mx.core.IContainer;

	public interface IAssignments
	{
		function get fileDownloadsContainer():IContainer;
		function get examsContainer():IContainer;
		function get eventsContainer():IContainer;
	}
}