package net.poweru.model
{
	import net.poweru.utils.PKArrayCollection;
	
	// All the features of DataSet, but hierarchical and suitable for a tree control
	public class HierarchicalDataSet extends DataSet
	{
		public function HierarchicalDataSet(source:Array=null)
		{
			super(source);
			if (this.source)
			{
				var pks:PKArrayCollection = new PKArrayCollection(source);
				
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
		}
		
		override public function findByKey(key:String, value:Object, source:Array=null):Object
		{
			// allows us to do recursion
			source = source ? source : this.source;
				
			for each (var item:Object in source)
				if (item.hasOwnProperty(key) && item[key] == value)
					return item;
				else if (item.hasOwnProperty('children'))
				{
					var ret:Object = findByKey(key, value, item['children']);
					if (ret != null)
						return ret;
				}
			return null;
		}
		
		override public function removeByKey(key:String, value:Object, array:Array=null):void
		{
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