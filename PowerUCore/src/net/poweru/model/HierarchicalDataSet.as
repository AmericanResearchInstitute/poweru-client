package net.poweru.model
{
	import net.poweru.utils.PKArrayCollection;
	import net.poweru.utils.SortedDataSetFactory;
	
	// All the features of DataSet, but hierarchical and suitable for a tree control
	public class HierarchicalDataSet extends DataSet
	{
		protected var keyMap:Object;
		protected var key:String;
		protected var sortField:String;
		
		public function HierarchicalDataSet(source:Array=null, key:String = 'id', sortField:String = null)
		{
			keyMap = {};
			this.key = key;
			this.sortField = sortField;
			super(source);
		}
		
		// put data into hierarchical form
		protected function processIncomingSource(data:Array):void
		{
			for each (var item1:Object in data)
				keyMap[item1[key]] = item1;
			
			var pks:PKArrayCollection = new PKArrayCollection(data);
			
			for each (var pk:Number in pks)
			{
				var item:Object = findByPK(pk);
				if (!item.hasOwnProperty('children'))
					item['children'] = [];
				if (!item.hasOwnProperty('parent') && item.hasOwnProperty('id'))
					continue;
				if (item['parent'] != null)
				{
					removeByPK(item['id']);
					var parent:Object = findByPK(item['parent']);
					if (!parent.hasOwnProperty('children'))
						parent['children'] = [];
					(parent['children'] as Array).push(item);
				}
			}
		}
		
		// sort the data and then have it processed into hierarchical form
		override public function set source(s:Array):void
		{
			// sort the data
			if (sortField)
			{
				var sortedDataSet:DataSet = SortedDataSetFactory.singleFieldSort(sortField);
				sortedDataSet.source = s;
				sortedDataSet.refresh();
				var sortedArray:Array = sortedDataSet.toArray();
				super.source = sortedArray;
				processIncomingSource(sortedArray);
			}
			else
				super.source = s;
		}
		
		override public function findByKey(key:String, value:Object, source:Array=null):Object
		{
			if (key == this.key && keyMap.hasOwnProperty(value))
				return keyMap[value];
			
			// allows us to do recursion
			source = source ? source : this.source;
			
			var ret:Object = null;
				
			for each (var item:Object in source)
				if (item.hasOwnProperty(key) && item[key] == value)
					ret = item;
				else if (item.hasOwnProperty('children'))
				{
					ret = findByKey(key, value, item['children']);
				}
			if (ret != null)
				keyMap[ret[key]] = ret;
			return ret;
		}
		
		override public function removeByKey(key:String, value:Object, array:Array=null):void
		{
			if (keyMap.hasOwnProperty(key))
				delete keyMap[key];
			array = array ? array : source;
			
			for each (var item:Object in array)
				if (item.hasOwnProperty(key))
				{
					if (item[key] == value)
					{	
						array.splice(array.indexOf(item), 1);
						break;
					}
					else if (item.hasOwnProperty('children'))
					{
						removeByKey(key, value, item['children']);
					}
				}
		}
		
		override public function addItem(item:Object):void
		{
			keyMap[item[key]] = item;
			
			if (item.hasOwnProperty('parent') && item['parent'])
			{
				var parent:Object = findByPK(item['parent']);
				if (!parent.hasOwnProperty('children'))
					parent['children'] = [];
				parent['children'].push(item);
			}
			else
			{
				source.push(item);
			}
		}
		
		public function findParent(pk:Number, eligibleParent:Object=null):Object
		{
			var children:Array = (eligibleParent != null && eligibleParent.hasOwnProperty('children')) ? eligibleParent['children'] : source;
			
			for each (var child:Object in children)
			{
				if (child['id'] == pk)
					return eligibleParent;
				else if (child.hasOwnProperty('children'))
				{
					var ret:Object = findParent(pk, child);
					if (ret != null)
						return ret;
				}
			}
			
			return null;
		}
		
		/*	Return all descendants of an item as a flat Array. If item is null,
			return all objects in this structure as a flat Array. */
		public function getDescendants(item:Object=null):Array
		{
			var ret:Array = [];
			
			if (item == null || item.hasOwnProperty('children'))
			{
				var iterable:Array = (item != null) ? item['children'] : source;
				
				for each (var child:Object in iterable)
				{
					ret.push(child);
					for each (var descendant:Object in getDescendants(child))
						ret.push(descendant);
				}
			}
			return ret;
		}
	}
}