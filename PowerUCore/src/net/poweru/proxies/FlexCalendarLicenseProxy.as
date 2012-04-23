package net.poweru.proxies
{
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	/*	It is up to you to figure out how and when to add the license string
		to this proxy. I suggest using a command that runs at startup.
		
		It will need the resource, which I suggest embedding like this:
	
			[Embed(source="../assets/flexcalendar_license.txt",mimeType="application/octet-stream")]
			protected var FlexCalendarLicenseClass:Class;
	
		Then in your command's execute() method, you can do this:
	
			flexCalendarLicenseProxy.license = new FlexCalendarLicenseClass();
	*/
	public class FlexCalendarLicenseProxy extends Proxy implements IProxy
	{
		public static const NAME:String = 'FlexCalendarLicenseProxy';
		
		public function FlexCalendarLicenseProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function get license():String
		{
			return data as String;
		}
		
		public function set license(value:String):void
		{
			data = value;
		}
	}
}