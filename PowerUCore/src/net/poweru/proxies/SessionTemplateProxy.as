package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.SessionTemplateManagerDelegate;
	import net.poweru.utils.PowerUResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class SessionTemplateProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'SessionTemplateProxy';
		public static const FIELDS:Array = ['shortname', 'fullname', 'version', 'description', 'lead_time'];
		
		public function SessionTemplateProxy()
		{
			super(NAME, SessionTemplateManagerDelegate, NotificationNames.UPDATESESSIONTEMPLATES, FIELDS, 'SessionTemplate');
		}
		
		override public function create(argDict:Object):void
		{
			var argNamesInOrder:Array = ['shortname', 'fullname', 'version', 'description', 'price', 'lead_time', 'active', 'modality'];
			var args:Array = [loginProxy.authToken];
			for each (var argName:String in argNamesInOrder)
			{
				args.push(argDict[argName]);
			}
			
			var optional_args:Object = {};
			
			for each (var property:String in [])
			{
				if (argDict.hasOwnProperty(property))
					optional_args[property] = argDict[property];
			}
			
			args.push(optional_args);
			
			new primaryDelegateClass(new PowerUResponder(onCreateSuccess, onCreateError, onFault)).create.apply(this, args);
		}
	}
}