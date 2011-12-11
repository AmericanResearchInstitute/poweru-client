package net.poweru.commands
{
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class BulkAssignmentSuccessCommand extends SimpleCommand implements ICommand
	{
		public function BulkAssignmentSuccessCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			sendNotification(NotificationNames.SHOWDIALOG, [Places.BULKASSIGNMENTRESULTS, notification.getBody()]);
		}
	}
}