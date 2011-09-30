package net.poweru.proxies
{
	import mx.rpc.events.ResultEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.delegates.CurriculumEnrollmentManagerDelegate;
	import net.poweru.model.DataSet;
	import net.poweru.utils.PowerUResponder;

	public class CurriculumEnrollmentProxy extends BaseProxy
	{
		public static const NAME:String = 'CurriculumEnrollmentProxy';
		public static const FIELDS:Array = [];
		
		public function CurriculumEnrollmentProxy()
		{
			super(NAME, CurriculumEnrollmentManagerDelegate, NotificationNames.UPDATECURRICULUMENROLLMENTS, FIELDS);
			dateTimeFields = ['start', 'end'];
		}
		
		override public function create(argDict:Object):void
		{
			var argNamesInOrder:Array = ['curriculum', 'start', 'end'];
			var args:Array = [loginProxy.authToken];
			for each (var argName:String in argNamesInOrder)
			{
				args.push(argDict[argName]);
			}
			
			new primaryDelegateClass(new PowerUResponder(onCreateSuccess, onCreateError, onFault)).create.apply(this, args);
		}
		
		public function curriculumEnrollmentsView():void
		{
			new CurriculumEnrollmentManagerDelegate(new PowerUResponder(onCurriculumEnrollmentsViewSuccess, onCurriculumEnrollmentsViewError, onFault)).curriculumEnrollmentsView(loginProxy.authToken);
		}
		
		override public function getOne(pk:Number):void
		{
			new CurriculumEnrollmentManagerDelegate(new PowerUResponder(onGetOneSuccess, onGetOneError, onFault)).curriculumEnrollmentsView(loginProxy.authToken, [pk]);
		}
		
		// Result handlers
		
		protected function onCurriculumEnrollmentsViewSuccess(event:ResultEvent):void
		{
			data = new DataSet(event.result.value);
			sendNotification(NotificationNames.UPDATECURRICULUMENROLLMENTSVIEW, event.result.value);
		}
		
		protected function onCurriculumEnrollmentsViewError(event:ResultEvent):void
		{
			
		}
	}
}