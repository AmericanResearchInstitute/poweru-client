package net.poweru.model
{
	public class ChooserRequest
	{
		public var exclude:Array;
		public var requestID:String;
		public var body:Object;
		public var showInactive:Boolean;
		
		public function ChooserRequest(requestID:String, exclude:Array = null, body:Object = null, showInactive:Boolean = true)
		{
			init(requestID, exclude, body, showInactive);
		}
		
		private function init(requestID:String, exclude:Array, body:Object, showInactive:Boolean):void
		{
			this.requestID = requestID;
			this.exclude = exclude == null ? [] : exclude;
			this.body = body;
			this.showInactive = showInactive;
		}
	}
}