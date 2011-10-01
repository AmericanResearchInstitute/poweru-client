package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.SessionTemplateManagerDelegate;
	import net.poweru.utils.PowerUResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class SessionTemplateProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'SessionTemplateProxy';
		public static const FIELDS:Array = ['shortname', 'fullname', 'version', 'description', 'lead_time', 'event_template', 'sequence'];
		
		public function SessionTemplateProxy()
		{
			super(NAME, SessionTemplateManagerDelegate, NotificationNames.UPDATESESSIONTEMPLATES, FIELDS, 'SessionTemplate');
			createArgNamesInOrder = ['shortname', 'fullname', 'version', 'description', 'price', 'lead_time', 'active', 'modality'];
			createOptionalArgNames = ['event_template', 'sequence'];
		}
	}
}