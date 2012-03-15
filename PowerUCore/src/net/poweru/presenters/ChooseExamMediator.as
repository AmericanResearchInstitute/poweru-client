package net.poweru.presenters
{
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.proxies.ExamProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class ChooseExamMediator extends BaseSimpleChooserMediator implements IMediator
	{
		public static const NAME:String = 'ChooseExamMediator';

		public function ChooseExamMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, Places.CHOOSEEXAM, NotificationNames.UPDATEEXAMS, ExamProxy);
		}
	}
}