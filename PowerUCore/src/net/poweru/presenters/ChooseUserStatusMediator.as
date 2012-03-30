package net.poweru.presenters
{
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.proxies.UserProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class ChooseUserStatusMediator extends BaseSimpleChooserMediator implements IMediator
	{
		public static const NAME:String = 'ChooseUserStatusMediator';
		
		public function ChooseUserStatusMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, Places.CHOOSEUSERSTATUS, NotificationNames.UPDATECHOICES, UserProxy);
		}
		
		override protected function populate():void
		{
			retrieveRequest();
			primaryProxy.getChoices();
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case updateNotification:
					chooser.populate(notification.getBody()['status'] as Array);
					break;
				
				case NotificationNames.SHOWDIALOG:
					if (notification.getBody()[0] == placeName)
						chooser.clear();
					populate();
					break;
			}
		}
	}
}