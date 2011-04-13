package net.poweru.commands
{
	import net.poweru.ApplicationFacade;
	import net.poweru.proxies.BrowserServicesProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class SpaceReadyCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			var browserServicesProxy:BrowserServicesProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(BrowserServicesProxy) as BrowserServicesProxy;
			browserServicesProxy.determineBackendURL();
		}
		
	}
}