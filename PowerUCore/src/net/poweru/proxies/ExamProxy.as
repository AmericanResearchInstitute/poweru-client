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
			createArgNamesInOrder = ['name', 'title'];
			createOptionalArgNames = ['description'];
		}
	}
}