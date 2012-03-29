package net.poweru.model
{
	public class ChooserRequest
	{
		public var exclude:Array;
		public var requestID:String;
		public var body:Object;
		
		public function ChooserRequest(requestID:String, exclude:Array = null, body:Object = null)
		{
			this.requestID = requestID;
			this.exclude = exclude == null ? [] : exclude;
			this.body = body;
		}
	}
}