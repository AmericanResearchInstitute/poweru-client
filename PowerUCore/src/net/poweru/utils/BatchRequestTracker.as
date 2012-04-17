package net.poweru.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.utils.UIDUtil;

	public class BatchRequestTracker extends EventDispatcher
	{
		public var totalRequests:Number = 0;
		[Bindable]
		public var successResults:ArrayCollection;
		[Bindable]
		public var errorResults:ArrayCollection;
		
		protected var _batchID:String;
		
		public function BatchRequestTracker()
		{
			super();
			reset();
		}
		
		public function get batchID():String
		{
			return _batchID;
		}
		
		public function get successPKs():PKArrayCollection
		{
			return new PKArrayCollection(successResults.toArray());
		}
		
		public function get errorPKs():PKArrayCollection
		{
			return new PKArrayCollection(errorResults.toArray());
		}
		
		public function processSuccess(item:Object, batchID:String):void
		{
			if (batchID == this.batchID)
			{
				successResults.addItem(item);
				considerCompletion();
			}
		}
		
		public function processError(item:Object, batchID:String):void
		{
			if (batchID == this.batchID)
			{
				errorResults.addItem(item);
				considerCompletion();
			}
		}
		
		public function reset():String
		{
			successResults = new ArrayCollection();
			errorResults = new ArrayCollection();
			_batchID = UIDUtil.createUID();
			return batchID;
		}
		
		protected function considerCompletion():void
		{
			if (successResults.length + errorResults.length == totalRequests)
				dispatchEvent(new Event(Event.COMPLETE));
		}

	}
}