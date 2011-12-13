package net.poweru.presenters
{
	import mx.core.mx_internal;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.events.ViewEvent;
	import net.poweru.proxies.ExamProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class EditExamMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditExamMediator';
		
		public function EditExamMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, ExamProxy, Places.EDITEXAM);
		}
	}
}