package net.poweru.events
{
	import flash.events.Event;

	public class ViewEvent extends Event
	{
		public static const CONFIRM:String = "Confirm";
		public static const CANCEL:String = "Cancel";
		public static const DELETE:String = "Delete";
		public static const FETCH:String = "Fetch";
		public static const LOGOUT:String = "Logout";
		public static const REFRESH:String = "Refresh";
		public static const SHOWDIALOG:String = "ShowDialog";
		
		// body = name of place which will fill the default space
		public static const SETSPACE:String = "SetSpace";
		
		/*	body = container to be filled
			type = place name */
		public static const SETOTHERSPACE:String = "SetOtherSpace";
		public static const SUBMIT:String = "Submit";
		public static const UPLOAD:String = "Upload";
		public static const VIDEOPLAY:String = "VideoPlay";
		
		public var body:Object;
		public var subType:String = null;
		
		public function ViewEvent(type:String, body:Object=null, subType:String=null, bubbles:Boolean=false)
		{
			super(type, bubbles, false);
			this.body = body;
			this.subType = subType;
		}
		
		override public function clone():Event
		{
			return new ViewEvent(type, body, subType, bubbles);
		}
	}
}