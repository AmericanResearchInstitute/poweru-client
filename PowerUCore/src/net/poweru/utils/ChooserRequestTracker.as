package net.poweru.utils
{
	import mx.utils.UIDUtil;
	
	import net.poweru.model.ChooserRequest;

	/*	Keep track of requests to show a chooser dialog. Each outgoing request
		gets a unique ID that is stored with the type (same as chooser name).
		When a choice is received, call doIWantThis() to determine if this
		choice matches our most recent request. */
	public class ChooserRequestTracker
	{
		// key is a place name, value is a chooser requestID
		protected var requestIDsByType:Object = {};
		
		public function ChooserRequestTracker()
		{
		}
		
		// Convenience method for generating a ChooserRequest object
		public function getChooserRequest(type:String, exclude:Array = null, body:Object = null, showInactive:Boolean = true):ChooserRequest
		{
			return new ChooserRequest(getID(type), exclude, body, showInactive);
		}
		
		// type should usually be the place name of a chooser
		public function getID(type:String):String
		{
			var requestID:String = UIDUtil.createUID();
			requestIDsByType[type] = requestID;
			return requestID;
		}
	
		/*	Quick way to determine if the incoming choice matches out most
			recent request for the given type. */
		public function doIWantThis(type:String, requestID:String):Boolean
		{
			return (requestIDsByType.hasOwnProperty(type) && requestIDsByType[type] == requestID);
		}
	}
}