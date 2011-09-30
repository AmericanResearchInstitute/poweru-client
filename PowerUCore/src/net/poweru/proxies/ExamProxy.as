package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.ExamManagerDelegate;
	import net.poweru.utils.PowerUResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class ExamProxy extends BaseProxy implements IProxy
	{
		public static var NAME:String = 'ExamProxy';
		public static const FIELDS:Array = ['name', 'title', 'description', 'type'];
		
		public function ExamProxy()
		{
			super(NAME, ExamManagerDelegate, NotificationNames.UPDATEEXAMS, FIELDS, 'Exam');
		}
		
		override public function create(argDict:Object):void
		{
			var argNamesInOrder:Array = ['name', 'title'];
			var args:Array = [loginProxy.authToken];
			for each (var argName:String in argNamesInOrder)
			{
				args.push(argDict[argName]);
			}
			// optional parameters go in a dictionary
			args.push({'description': argDict['description']});
			
			new primaryDelegateClass(new PowerUResponder(onCreateSuccess, onCreateError, onFault)).create.apply(this, args);
		}
	}
}