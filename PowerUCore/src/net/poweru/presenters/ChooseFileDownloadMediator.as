package net.poweru.presenters
{
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.proxies.FileDownloadProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class ChooseFileDownloadMediator extends BaseSimpleChooserMediator implements IMediator
	{
		public static const NAME:String = 'ChooseFileDownloadMediator';
		
		public function ChooseFileDownloadMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, Places.CHOOSEFILEDOWNLOAD, NotificationNames.UPDATEFILEDOWNLOADS, FileDownloadProxy);
		}
	}
}