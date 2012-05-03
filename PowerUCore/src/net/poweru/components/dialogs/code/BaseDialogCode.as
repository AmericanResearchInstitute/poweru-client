package net.poweru.components.dialogs.code
{
	import mx.containers.TitleWindow;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	import mx.managers.PopUpManager;
	
	import net.poweru.events.ViewEvent;
	
	public class BaseDialogCode extends TitleWindow
	{
		protected var _creationIsComplete:Boolean = false;
		
		public function BaseDialogCode()
		{
			super();
			init();
		}
		
		private function init():void
		{
			addEventListener(ResizeEvent.RESIZE, onResize);
			addEventListener(CloseEvent.CLOSE, onClose);
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function get creationIsComplete():Boolean
		{
			return _creationIsComplete;
		}
		
		public function setState(state:String):void
		{
			try
			{
				currentState = state;
			}
			catch (err:ArgumentError)
			{
				; // If the state isn't defined, no sweat. Stick with the default.
			}	
		}
		
		protected function limitSize():void
		{
			maxHeight = stage.stageHeight - 20;
		}
		
		private function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			_creationIsComplete = true;
		}
		
		protected function onResize(event:ResizeEvent):void
		{
			event.stopImmediatePropagation();
			if (isPopUp)
			{
				limitSize();
				validateNow();
				PopUpManager.centerPopUp(this);
			}
		}
		
		protected function onClose(event:CloseEvent):void
		{
			dispatchEvent(new ViewEvent(ViewEvent.CANCEL))
		}
	}
}