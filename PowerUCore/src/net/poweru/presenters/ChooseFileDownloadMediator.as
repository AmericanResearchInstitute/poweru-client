package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.model.DataSet;
	import net.poweru.proxies.FileDownloadProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class ChooseFileDownloadMediator extends BaseSimpleChooserMediator implements IMediator
	{
		public static const NAME:String = 'ChooseFileDownloadMediator';
		
		public function ChooseFileDownloadMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, Places.CHOOSEFILEDOWNLOAD, NotificationNames.UPDATEFILEDOWNLOADS, FileDownloadProxy);
		}
	}
}