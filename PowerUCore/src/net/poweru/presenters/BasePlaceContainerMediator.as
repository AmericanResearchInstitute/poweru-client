package net.poweru.presenters
{
	import flash.display.DisplayObject;
	
	import net.poweru.NotificationNames;
	import net.poweru.events.ViewEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/*	Use this as the mediator for any container which either is or contains
		PlaceContainers. This mediator will automatically populate them with
		their requested place. */
	public class BasePlaceContainerMediator extends Mediator implements IMediator
	{
		public function BasePlaceContainerMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
			displayObject.addEventListener(ViewEvent.SETOTHERSPACE, onSetOtherSpace);
		}
		
		protected function get displayObject():DisplayObject
		{
			return viewComponent as DisplayObject;
		}
		
		protected function onSetOtherSpace(event:ViewEvent):void
		{
			sendNotification(NotificationNames.SETOTHERSPACE, event.body, event.subType);
			event.stopPropagation();
		}
	}
}