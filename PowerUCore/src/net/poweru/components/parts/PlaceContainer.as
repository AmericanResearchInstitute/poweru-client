package net.poweru.components.parts
{
	import mx.containers.HBox;
	import mx.events.FlexEvent;
	
	import net.poweru.events.ViewEvent;
	
	/*	Any time you need to place a container in an arbitrary location, you can
		use this one for convenience. Specify the placeName, and make sure that
		a parent container has a mediator that subclasses BasePlaceContainerMediator.
		This contianer will send out an event that the mediator receives, telling it
		to populate this container with the named place. */
	public class PlaceContainer extends HBox
	{
		// name of the place that should be populated to this container
		public var placeName:String;
		
		public function PlaceContainer()
		{
			super();
			init();
		}
		
		private function init():void
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			percentHeight = 100;
			percentWidth = 100;
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			dispatchEvent(new ViewEvent(ViewEvent.SETOTHERSPACE, this, placeName, true));
		}
	}
}