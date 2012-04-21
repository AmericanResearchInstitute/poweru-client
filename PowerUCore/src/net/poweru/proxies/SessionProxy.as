package net.poweru.proxies
{
	import mx.rpc.events.ResultEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.delegates.SessionManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class SessionProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'SessionProxy';
		
		public function SessionProxy()
		{
			super(NAME, SessionManagerDelegate, NotificationNames.UPDATESESSIONS, [], 'Session');
			init();
		}
		
		private function init():void
		{
			createArgNamesInOrder = ['start', 'end', 'status', 'confirmed', 'default_price', 'event', 'shortname', 'fullname'];
			createOptionalArgNames = ['title', 'url', 'description', 'lead_time'];
			dateTimeFields = ['start', 'end'];
		}
		
		/*	clear item from cache and re-fetch so we get the correct
			session_user_role data. */
		override protected function onSaveSuccess(data:ResultEvent):void
		{
			dataSet.removeByPK(data.token['updatedItem']['id']);
			findByIDs([data.token['updatedItem']['id']]);
			saveCounter.decrement();
		}
	}
}