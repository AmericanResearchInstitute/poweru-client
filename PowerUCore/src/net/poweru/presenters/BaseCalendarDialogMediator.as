package net.poweru.presenters
{
	import mx.events.FlexEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.components.interfaces.ICalendarDialog;
	import net.poweru.events.ViewEvent;
	import net.poweru.proxies.FlexCalendarLicenseProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class BaseCalendarDialogMediator extends BaseMediator implements IMediator
	{
		protected var flexCalendarLicenseProxy:FlexCalendarLicenseProxy;
		
		public function BaseCalendarDialogMediator(mediatorName:String, viewComponent:Object, primaryProxyClass:Class=null)
		{
			super(mediatorName, viewComponent, primaryProxyClass);
			init();
		}
		
		private function init():void
		{
			flexCalendarLicenseProxy = getProxy(FlexCalendarLicenseProxy) as FlexCalendarLicenseProxy;
			displayObject.addEventListener(FlexEvent.CREATION_COMPLETE, onViewCreationComplete);
		}
		
		protected function get calendarDialog():ICalendarDialog
		{
			return viewComponent as ICalendarDialog;
		}
		
		override protected function addEventListeners():void
		{
			super.addEventListeners();
			displayObject.addEventListener(ViewEvent.CANCEL, onCancel);
		}
		
		override protected function removeEventListeners():void
		{
			super.removeEventListeners();
			displayObject.removeEventListener(ViewEvent.CANCEL, onCancel);
		}
		
		protected function onCancel(event:ViewEvent):void
		{
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
		}
		
		protected function onViewCreationComplete(event:FlexEvent):void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onViewCreationComplete);
			calendarDialog.license = flexCalendarLicenseProxy.license;
		}
	}
}