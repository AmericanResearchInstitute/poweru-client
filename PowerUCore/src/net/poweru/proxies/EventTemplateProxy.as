package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.EventTemplateManagerDelegate;
	import net.poweru.utils.PowerUResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class EventTemplateProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'EventTemplateProxy';
		
		public function EventTemplateProxy()
		{
			super(NAME, EventTemplateManagerDelegate, NotificationNames.UPDATEEVENTTEMPLATES, 'EventTemplate');
		}
		
		override public function create(argDict:Object):void
		{
			var argNamesInOrder:Array = ['name_prefix', 'title', 'description'];
			var args:Array = [loginProxy.authToken];
			for each (var argName:String in argNamesInOrder)
			{
				args.push(argDict[argName]);
			}
			// optional parameters
			args.push({
				'lead_time' : argDict['lead_time']
			});
			
			new primaryDelegateClass(new PowerUResponder(onCreateSuccess, onCreateError, onFault)).create.apply(this, args);
		}
	}
}