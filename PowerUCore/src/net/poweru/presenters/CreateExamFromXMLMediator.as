package net.poweru.presenters
{
	import net.poweru.NotificationNames;
	import net.poweru.events.ViewEvent;
	import net.poweru.proxies.ExamProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class CreateExamFromXMLMediator extends BaseCreateDialogMediator implements IMediator
	{
		public static const NAME:String = 'CreateExamFromXMLMediator';
		
		public function CreateExamFromXMLMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, ExamProxy);
		}
		
		protected function get examProxy():ExamProxy
		{
			return primaryProxy as ExamProxy;
		}
		
		override protected function onSubmit(event:ViewEvent):void
		{
			examProxy.createFromXML(createDialog.getData()['xml'] as String);
			createDialog.clear();
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
		}
	}
}