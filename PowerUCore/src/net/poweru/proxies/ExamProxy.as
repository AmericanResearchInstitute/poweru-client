package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.ExamManagerDelegate;
	import net.poweru.utils.PowerUResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class ExamProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'ExamProxy';
		
		public function ExamProxy()
		{
			super(NAME, ExamManagerDelegate, NotificationNames.UPDATEEXAMS, [], 'Exam');
			createArgNamesInOrder = ['name', 'title', 'organization'];
			createOptionalArgNames = ['description'];
			getFilteredMethodName = 'achievement_detail_view';
		}
		
		public function createFromXML(xml:String):void
		{
			new ExamManagerDelegate(new PowerUResponder(onCreateSuccess, onCreateError, onFault)).createFromXML(loginProxy.authToken, xml);
		}

	}
}