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
			super(NAME, CurriculumManagerDelegate, NotificationNames.UPDATECURRICULUMS, []);
			init();
		}
		
		private function init():void
		{
			createArgNamesInOrder = ['name'];
			createOptionalArgNames = ['description', 'organization'];
			getFilteredMethodName = 'admin_curriculums_view';
		}
	}
}