package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.EventTemplateManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class EventTemplateProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'EventTemplateProxy';
		public static const FIELDS:Array = ['active', 'title', 'name_prefix', 'lead_time', 'description', 'session_templates'];
		
		public function EventTemplateProxy()
		{
			super(NAME, EventTemplateManagerDelegate, NotificationNames.UPDATEEVENTTEMPLATES, FIELDS, 'EventTemplate');
			init();
		}
		
		private function init():void
		{
			createArgNamesInOrder = ['name_prefix', 'title', 'description'];
			createOptionalArgNames = ['lead_time'];
		}
	}
}