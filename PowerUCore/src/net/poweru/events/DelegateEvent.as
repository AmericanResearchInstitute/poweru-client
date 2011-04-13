package net.poweru.events
{
	import flash.events.Event;

	public class DelegateEvent extends Event
	{
		public static const NOUPDATE:String = "NoUpdate";
		
		public function DelegateEvent(type:String)
		{
			super(type, false, false);
		}
		
	}
}