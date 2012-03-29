package net.poweru.model
{
	public class ChooserResult
	{
		public var value:Object;
		public var requestID:String;
		
		public function ChooserResult(requestID:String, value:Object)
		{
			this.value = value;
			this.requestID = requestID;
		}
	}
}