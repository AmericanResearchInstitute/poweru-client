package net.poweru.commands
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.proxies.BrowserServicesProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	
	/*	This should probably be run when NotificationNames.FILEDOWNLOADURLRECEIVED
		is received. It simply opens the URL in a new window. */
	public class OpenFileDownloadURLCommand extends SimpleCommand implements ICommand
	{
		protected var browserServicesProxy:BrowserServicesProxy;
		
		public function OpenFileDownloadURLCommand()
		{
			super();
			browserServicesProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(BrowserServicesProxy) as BrowserServicesProxy;
		}
		
		override public function execute(notification:INotification):void
		{
			var backendURL:String = browserServicesProxy.backendURL;
			var fileURL:String = notification.getBody() as String;
			if (fileURL.indexOf('/svc/') == 0)
				fileURL = fileURL.slice(5);
			navigateToURL(new URLRequest(backendURL + fileURL));
		}
	}
}