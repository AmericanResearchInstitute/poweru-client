package net.poweru.proxies
{
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	
	import net.poweru.NotificationNames;
	import net.poweru.delegates.CurriculumManagerDelegate;
	import net.poweru.model.DataSet;
	import net.poweru.utils.PowerUResponder;
	
	import org.puremvc.as3.interfaces.IProxy;

	public class CurriculumProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'CurriculumProxy';

		public function CurriculumProxy()
		{
			super(NAME, CurriculumManagerDelegate, NotificationNames.UPDATECURRICULUMS);
		}
		
		override public function create(argDict:Object):void
		{
			var argNamesInOrder:Array = ['name'];
			var args:Array = [loginProxy.authToken];
			for each (var argName:String in argNamesInOrder)
			{
				args.push(argDict[argName]);
			}
			
			new primaryDelegateClass(new PowerUResponder(onCreateSuccess, onCreateError, onFault)).create.apply(this, args);
		}
		
		public function adminCurriculumsView():void
		{
			new CurriculumManagerDelegate(new PowerUResponder(onAdminCurriculumsViewSuccess, onAdminCurriculumsViewError, onFault)).adminCurriculumsView(loginProxy.authToken);
		}
		
		protected function onAdminCurriculumsViewSuccess(event:ResultEvent):void
		{
			data = new DataSet(event.result.value);
			sendNotification(NotificationNames.UPDATEADMINCURRICULUMSVIEW, ObjectUtil.copy(event.result.value));
		}
		
		protected function onAdminCurriculumsViewError(event:ResultEvent):void
		{
			
		}
	}
}