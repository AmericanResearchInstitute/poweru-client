package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.model.DataSet;
	import net.poweru.proxies.ExamProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class ChooseExamMediator extends BaseTaskChooserMediator implements IMediator
	{
		public static const NAME:String = 'ChooseExamMediator';

		public function ChooseExamMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, Places.CHOOSEEXAM, NotificationNames.UPDATEEXAMS, ExamProxy);
		}
	}
}