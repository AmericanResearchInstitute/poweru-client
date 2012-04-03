package net.poweru.components.widgets
{
	import com.hillelcoren.components.AutoComplete;
	
	public class PoliteAutoComplete extends AutoComplete
	{
		public var externalFilterFunction:Function;
		
		override public function PoliteAutoComplete()
		{
			super();
		}
		
		/*	Allow this component's filtering to work in tandem with an optional
			external filter function.
		*/
		override protected function filterFunctionWrapper(item:Object):Boolean
		{
			var ret:Boolean = super.filterFunctionWrapper(item);
			if (ret && externalFilterFunction != null)
				ret = externalFilterFunction(item);
			return ret;
		}
	}
}