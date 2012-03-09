package net.poweru.utils
{
	import mx.collections.SortField;
	
	public class NestedSortField extends SortField
	{
		public var pureCompareFunction:Function;
		protected var namePieces:Array;
		
		public function NestedSortField(name:String=null, caseInsensitive:Boolean=false, descending:Boolean=false, numeric:Object=null)
		{
			super(name, caseInsensitive, descending, numeric);
			namePieces = name.split('.');
			pureCompareFunction = new SortField(null, caseInsensitive, descending, numeric).compareFunction;
			compareFunction = nestedCompareFunction;
		}
		
		public function nestedCompareFunction(a:Object, b:Object):int
		{
			return pureCompareFunction(getFinalObject(a), getFinalObject(b));
		}
		
		protected function getFinalObject(x:Object):Object
		{
			return NestedDataUtils.getFinalObject(x, namePieces);
		}
	}
}