package net.poweru.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/*	Use this class when you need to gather multiple pieces of data
		asynchronously and then do something with them after they have all
		arrived. */
	public class InputCollector extends EventDispatcher
	{
		protected var requirements:Array;
		protected var _object:Object;
		
		/* 	name each requirement whatever you want. Once they have all been
			added, an Event of type Event.COMPLETE will be dispatched.  Note
			that even after they have all been added, if one of them is added
			again, the event will be dispatched again. */
		public function InputCollector(requirements:Array)
		{
			super();
			init(requirements);
		}
		
		private function init(requirements:Array):void
		{
			_object = {};
			this.requirements = requirements;
		}

		public function addInput(name:String, value:Object):void
		{
			_object[name] = value;
			checkCompletion();
		}
		
		protected function checkCompletion():void
		{
			var done:Boolean = true;
			for each (var requirement:String in requirements)
				if (!_object.hasOwnProperty(requirement))
				{
					done = false;
					break;
				}
			if (done)
				dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get object():Object
		{
			return _object;
		}
		
	}
}