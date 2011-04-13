package net.poweru.utils
{
	/*	When making remote requests, increment this object.  As results come
		in, decrement it.  Whenever decrement() is called and the count is at
		or becomes 0, the callback is called.
		
		Callback should be a function that takes no arguments.
	*/
	public class ExpectedResultCounter
	{
		protected var outstandingResults:int = 0;
		protected var callback:Function;
		
		public function ExpectedResultCounter(callback:Function)
		{
			this.callback = callback;
		}
		
		// Call this when making a request
		public function increment():void
		{
			outstandingResults++;
		}

		// Call this when receiving results (or an error) for a request
		public function decrement():void
		{
			if (outstandingResults > 0)
				outstandingResults--;
			if (outstandingResults == 0)
				callback();
		}
		
		// If things go horribly wrong, you might want to reset the count.
		public function reset():void
		{
			outstandingResults = 0;
		}
	}
}