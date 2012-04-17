package net.poweru.commands
{
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.proxies.CredentialProxy;
	import net.poweru.utils.BatchRequestTracker;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class BatchCreateCompleteCommand extends SimpleCommand implements ICommand
	{
		public function BatchCreateCompleteCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var viewName:String = determineViewName(notification.getType());
			sendNotification(NotificationNames.SHOWDIALOG, [viewName, notification.getBody()]);
		}
		
		protected function determineViewName(batchType:String):String
		{
			var ret:String = '';
			
			switch (batchType)
			{
				case CredentialProxy.NAME:
					ret = Places.BATCHCREATECREDENTIALSRESULTS;
					break;
			}
			
			return ret;
		}
	}
}