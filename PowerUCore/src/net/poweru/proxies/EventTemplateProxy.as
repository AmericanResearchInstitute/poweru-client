package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.EventTemplateManagerDelegate;
	import net.poweru.utils.PowerUResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class EventTemplateProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'EventTemplateProxy';
		public static const FIELDS:Array = ['title', 'name_prefix', 'lead_time', 'description', 'session_templates'];
		
		public function EventTemplateProxy()
		{
			super(NAME, EventTemplateManagerDelegate, NotificationNames.UPDATEEVENTTEMPLATES, FIELDS, 'EventTemplate');
			createArgNamesInOrder = ['name_prefix', 'title', 'description'];
			createOptionalArgNames = ['lead_time'];
		}
	}
}