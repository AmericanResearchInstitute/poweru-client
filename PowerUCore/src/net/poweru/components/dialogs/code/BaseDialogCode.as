package net.poweru.components.dialogs.code
{
	import mx.containers.TitleWindow;
	import mx.events.CloseEvent;
	import mx.events.ResizeEvent;
	import mx.managers.PopUpManager;
	
	import net.poweru.events.ViewEvent;
	
	public class BaseDialogCode extends TitleWindow
	{
		public function BaseDialogCode()
		{
			super();
			addEventListener(ResizeEvent.RESIZE, onResize);
			addEventListener(CloseEvent.CLOSE, onClose);
		}
		
		protected function onResize(event:ResizeEvent):void
		{
			PopUpManager.centerPopUp(this);
		}
		
		protected function onClose(event:CloseEvent):void
		{
			dispatchEvent(new ViewEvent(ViewEvent.CANCEL))
		}
	}
}