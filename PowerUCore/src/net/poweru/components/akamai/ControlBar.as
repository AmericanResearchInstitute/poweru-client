package net.poweru.components.akamai
{
	import flash.events.Event;
	
	import org.openvideoplayer.components.ui.controlbar.ControlBar;

	/*	The released version of this file has a bug, in which the destroy()
		method does not accept the passed event as an argument.  Bug filed
		here:
		
		https://sourceforge.net/tracker/?func=detail&aid=3178651&group_id=243060&atid=1121328
		
		A patch has also been submitted.  This class is a workaround.  I tried
		building the library myself with a local fix, but for unknown reasons
		the text formatting was screwed up and there were other inexplicable
		compilation errors.
		
		The idea here is that we get our hands on the event first and then stop
		it dead in its tracks.
	*/
	public class ControlBar extends org.openvideoplayer.components.ui.controlbar.ControlBar
	{
		public function ControlBar()
		{
			// This must happen before super is called.
			addEventListener(Event.REMOVED_FROM_STAGE, hijackEvent);
			super();
		}
		
		private function hijackEvent(event:Event):void
		{
			event.stopImmediatePropagation();
		}
		
	}
}