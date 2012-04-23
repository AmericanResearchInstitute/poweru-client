package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.ITranscript;
	import net.poweru.model.DataSet;
	import net.poweru.proxies.AchievementAwardProxy;
	import net.poweru.proxies.AssignmentProxy;
	import net.poweru.proxies.CredentialProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class TranscriptMediator extends BaseReportDialogMediator implements IMediator
	{
		public static const NAME:String = 'TranscriptMediator';
		
		protected var achievementAwardProxy:AchievementAwardProxy;
		protected var credentialProxy:CredentialProxy;
		
		public function TranscriptMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, AssignmentProxy, Places.TRANSCRIPT);
			init();
		}
		
		private function init():void
		{
			achievementAwardProxy = getProxy(AchievementAwardProxy) as AchievementAwardProxy;
			credentialProxy = getProxy(CredentialProxy) as CredentialProxy;
		}
		
		override public function listNotificationInterests():Array
		{
			var ret:Array = super.listNotificationInterests();
			ret = ret.concat(
				NotificationNames.UPDATEACHIEVEMENTAWARDS,
				NotificationNames.UPDATECREDENTIALS,
				NotificationNames.UPDATETRANSCRIPT
			);
			return ret;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.UPDATEACHIEVEMENTAWARDS:
					inputCollector.addInput('achievementAwards', (notification.getBody() as DataSet).toArray());
					break;
				
				case NotificationNames.UPDATECREDENTIALS:
					inputCollector.addInput('credentials', (notification.getBody() as DataSet).toArray());
					break;
				
				case NotificationNames.UPDATETRANSCRIPT:
					inputCollector.addInput('assignments', notification.getBody());
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		protected function get transcript():ITranscript
		{
			return viewComponent as ITranscript;
		}
		
		override protected function buildInputCollector():InputCollector
		{
			return new InputCollector(['creationComplete', 'assignments', 'achievementAwards', 'credentials']);
		}
		
		override protected function onInputsCollected(event:Event):void
		{
			transcript.populate(
				inputCollector.object['assignments'],
				inputCollector.object['achievementAwards'],
				inputCollector.object['credentials']
			);
		}
		
		override protected function populate():void
		{
			var userID:Number = initialDataProxy.getInitialData(placeName) as Number;
			if (userID == 0) // happens when null is cast to a Number
				userID = loginProxy.currentUser.id;
			var filters:Object = {'exact' : {'user' : userID}};
			(primaryProxy as AssignmentProxy).transcriptView(filters, ['task']);
			achievementAwardProxy.getFiltered(filters);
			credentialProxy.getFiltered(filters);
		}
	}
}