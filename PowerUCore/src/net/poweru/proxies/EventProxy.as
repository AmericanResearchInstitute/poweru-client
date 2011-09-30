package net.poweru.proxies
{
	import mx.automation.events.EventDetails;
	
	import net.poweru.NotificationNames;
	import net.poweru.delegates.EventManagerDelegate;
	import net.poweru.utils.PowerUResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class EventProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'EventProxy';
		public static const FIELDS:Array = ['title', 'name', 'lead_time', 'description', 'start', 'end'];
		
		public function EventProxy()
		{
			super(NAME, EventManagerDelegate, NotificationNames.UPDATEEVENTS, FIELDS);
			dateTimeFields = [
				'start',
				'end'
			];
		}
		
		override public function create(argDict:Object):void
		{
			var argNamesInOrder:Array = ['name', 'title', 'description', 'start', 'end', 'organization'];
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