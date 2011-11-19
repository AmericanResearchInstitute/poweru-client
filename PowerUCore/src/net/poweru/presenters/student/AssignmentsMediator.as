package net.poweru.presenters.student
{
	import flash.display.DisplayObject;
	
	import mx.events.FlexEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.student.interfaces.IAssignments;
	import net.poweru.events.ViewEvent;
	import net.poweru.proxies.AssignmentsForUserProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class AssignmentsMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'StudentAssignmentsMediator';
		
		public function AssignmentsMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			displayObject.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		protected function get assignments():IAssignments
		{
			return displayObject as IAssignments;
		}
		
		protected function get displayObject():DisplayObject
		{
			return viewComponent as DisplayObject;
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			sendNotification(NotificationNames.SETOTHERSPACE, assignments.fileDownloadsContainer, Places.FILEDOWNLOADASSIGNMENTS);
		}
	}
}