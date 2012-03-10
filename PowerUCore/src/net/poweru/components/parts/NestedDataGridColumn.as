package net.poweru.components.parts
{
	import mx.collections.Sort;
	import mx.controls.dataGridClasses.DataGridColumn;
	
	import net.poweru.utils.NestedDataUtils;
	
	public class NestedDataGridColumn extends DataGridColumn
	{
		protected var _nestedName:String;
		protected var _nestedNamePieces:Array;
		protected var pureSortCompareFunction:Function;
		
		public function NestedDataGridColumn(columnName:String=null)
		{
			super(columnName);
			sortCompareFunction = nestedSortFunction;
			// We can't grab the internal one from this class, because my other
			// meddling has already confused it.
			pureSortCompareFunction = new Sort().compareFunction;
		}
		
		public function set nestedName(name:String):void
		{
			_nestedName = name;
			_nestedNamePieces = name.split('.');
		}
		
		public function get nestedName():String
		{
			return _nestedName;
		}

		protected function getFinalObject(x:Object):Object
		{
			return NestedDataUtils.getFinalObject(x, _nestedNamePieces);
		}
		
		/*	replaces the normal "sortCompareFunction" but just calls an equivalent
		to the original with the final nested object. */
		protected function nestedSortFunction(a:Object, b:Object):int
		{
			return pureSortCompareFunction(getFinalObject(a), getFinalObject(b));
		}
		
		override public function itemToLabel(data:Object):String
		{
			return String(getFinalObject(data));
		}
	}
}