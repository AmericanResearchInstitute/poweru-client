package net.poweru.presenters
{
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.proxies.AssignmentProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class TranscriptMediator extends BaseReportDialogMediator implements IMediator
	{
		public static const NAME:String = 'TranscriptMediator';
		
		public function TranscriptMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, AssignmentProxy, Places.TRANSCRIPT);
		}
		
		override public function listNotificationInterests():Array
		{
			var ret:Array = super.listNotificationInterests();
			ret = ret.concat([
				NotificationNames.UPDATETRANSCRIPT
			]);
			return ret;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.UPDATETRANSCRIPT:
					inputCollector.addInput('data', notification.getBody());
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		override protected function populate():void
		{
			var userID:Number = initialDataProxy.getInitialData(placeName) as Number;
			if (userID == 0) // happens when null is cast to a Number
				userID = loginProxy.currentUser.id;
			var filters:Object = {'exact' : {'user' : userID}};
			(primaryProxy as AssignmentProxy).transcriptView(filters, ['task']);
		}
	}
}