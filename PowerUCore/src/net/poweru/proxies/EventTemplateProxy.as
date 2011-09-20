package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.EventTemplateManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class EventTemplateProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'EventTemplateProxy';
		
		public function EventTemplateProxy()
		{
			super(NAME, EventTemplateManagerDelegate, NotificationNames.UPDATEEVENTTEMPLATES, 'EventTemplate');
		}
	}
}