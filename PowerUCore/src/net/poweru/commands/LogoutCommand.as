package net.poweru.commands
{
	import net.poweru.placemanager.InitialDataProxy;
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.proxies.BaseProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class LogoutCommand extends SimpleCommand implements ICommand
	{
		// What should be put on space upon logout?  This command gets to decide!
		override public function execute(notification:INotification):void
		{
			sendNotification(NotificationNames.SETSPACE, Places.LOGIN);
			// clear out the history of initial data
			facade.retrieveProxy(InitialDataProxy.NAME).setData(new Object());
			
			// Clear data from all proxies.
			for each (var name:String in (facade as ApplicationFacade).proxyNames)
			{
				var proxy:BaseProxy = facade.retrieveProxy(name) as BaseProxy;
				if (proxy != null)
				{
					proxy.clear();
				}
			}
			
			if (facade.hasProxy(InitialDataProxy.NAME))
				(facade.retrieveProxy(InitialDataProxy.NAME) as InitialDataProxy).clear();
		}
	}
}