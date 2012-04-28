package net.poweru.presenters
{
	import net.poweru.Places;
	import net.poweru.proxies.CurriculumEnrollmentProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class CurriculumEnrollmentUsersMediator extends BaseReportDialogMediator implements IMediator
	{
		public static const NAME:String = 'CurriculumEnrollmentUsersMediator';
		
		public function CurriculumEnrollmentUsersMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, CurriculumEnrollmentProxy, Places.CURRICULUMENROLLMENTUSERS);
		}
		
		override protected function populate():void
		{
			inputCollector.addInput('data', initialDataProxy.getInitialData(placeName));
		}
	}
}