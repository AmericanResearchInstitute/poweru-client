package net.poweru.components.widgets.code
{
	import flash.events.Event;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.controls.TextInput;
	
	import net.poweru.events.ViewEvent;
	
	public class ReCaptchaCode extends Canvas
	{
		public var image:Image;
		[Bindable]
		public var response:TextInput;
		
		public function ReCaptchaCode()
		{
			super();
		}
		
		public function clear():void
		{
			response.text = '';
			image.unloadAndStop();
		}
		
		protected function onLoadNew(event:Event):void
		{
			clear();
			dispatchEvent(new ViewEvent(ViewEvent.REFRESH));
		}
	}
}