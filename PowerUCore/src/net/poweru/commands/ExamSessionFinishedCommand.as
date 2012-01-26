package net.poweru.commands
{
	import mx.controls.Alert;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ExamSessionFinishedCommand extends SimpleCommand implements ICommand
	{
		public function ExamSessionFinishedCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			Alert.show('Exam Session has been finished.');
		}
	}
}