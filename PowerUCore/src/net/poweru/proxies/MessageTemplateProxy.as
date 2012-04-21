package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.MessageTemplateManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class MessageTemplateProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'MessageTemplateProxy';
		
		public function MessageTemplateProxy()
		{
			super(NAME, MessageTemplateManagerDelegate, NotificationNames.UPDATEMESSAGETEMPLATES, [], 'MessageTemplate', []);
			init();
		}
		
		private function init():void
		{
			getFilteredMethodName = 'detail_view';
		}
	}
}