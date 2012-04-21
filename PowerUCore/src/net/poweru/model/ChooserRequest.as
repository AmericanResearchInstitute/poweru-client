package net.poweru.model
{
	public class ChooserRequest
	{
		public var exclude:Array;
		public var requestID:String;
		public var body:Object;
		
		public function ChooserRequest(requestID:String, exclude:Array = null, body:Object = null)
		{
			init(requestID, exclude, body);
		}
		
		private function init(requestID:String, exclude:Array = null, body:Object = null):void
		{
			this.requestID = requestID;
			this.exclude = exclude == null ? [] : exclude;
			this.body = body;
		}
	}
}