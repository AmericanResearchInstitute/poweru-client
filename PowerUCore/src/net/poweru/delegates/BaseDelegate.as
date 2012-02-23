package net.poweru.delegates
{
	import com.adobe.utils.DateUtil;
	
	import flash.events.EventDispatcher;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.remoting.RemoteObject;
	
	import net.poweru.events.DelegateEvent;
	import net.poweru.model.DataSet;
	import net.poweru.utils.PKArrayCollection;
	import net.poweru.utils.RemoteObjectFactory;
	
	public class BaseDelegate extends EventDispatcher
	{
		protected var responder:IResponder;
		protected var remoteObject:RemoteObject;
		private var updateFieldsToIgnore:Array;
		private var specialUpdateHandlingInfo:Object;
		
		/*	Sometimes we want to use a view method that adds extra data to the
			typical get_filtered output. That method must take the same number
			of parameters as get_filtered. Specify the name of the remote
			method here. */
		protected var getFilteredMethodName:String = 'get_filtered';
		
		/*	some attributes need a small touch of type translation or such before
			being shipped off to the server.  Set this attribute in subclasses
			such that keys are names of attributes you want to mangle, and values
			are functions which will do the mangling.  See mangleForeignKey() for
			an example of such a method.
			
			Example which is good for an object like a user which has an foreign
			key to an organization:
			
			mangleMap = {'organization' : mangleForeignKey};
		*/
		protected var mangleMap:Object = {};
		
		/*
		some attributes need special care when being updated.  The following data
		structure can be defined on a delegate to help sort things out.  Currently,
		this only supports cases where a through table is used in a many-to-many
		relationship.  Thus, in the example below, 'category_relationships' will
		be an array of items each defining a relationship.
		
		protected static const SPECIALUPDATEHANDLINGINFO:Object = {
			// name of the attribute as seen on the flex object
			'category_relationships' : {
				// name of the corresponding attribute on the back end.
				'attribute_to_update' : 'categories',
				// in each relationship definition, this is the name of
				// the attribute holding the FK of M2M relationship
				'foreign_attribute_name' : 'category',
				// Considering the attributes of each relationship's object,
				// include this list of attributes in the update request
				'attributes_to_include' : ['status']
			}
		*/
		
		public function BaseDelegate(responder:IResponder, managerName:String, updateFieldsToIgnore:Array=null, specialUpdateHandlingInfo:Object=null)
		{
			this.responder = responder;
			this.updateFieldsToIgnore = updateFieldsToIgnore ? updateFieldsToIgnore : [];
			this.updateFieldsToIgnore.push('mx_internal_uid');
			this.specialUpdateHandlingInfo = specialUpdateHandlingInfo ? specialUpdateHandlingInfo : {};
			remoteObject = RemoteObjectFactory.getInstance().getRemoteObject(managerName);
		}
		
		public function getFiltered(authToken:String, filters:Object, fields:Array, getFilteredMethodName:String = null):AsyncToken
		{
			if (getFilteredMethodName == null)
				getFilteredMethodName = this.getFilteredMethodName;
			var token:AsyncToken = remoteObject.getOperation(getFilteredMethodName).send(authToken, filters, fields);
			token.addResponder(responder);
			return token;
		}
		
		public function deleteObject(authToken:String, id:Number):AsyncToken
		{
			var token:AsyncToken = remoteObject.getOperation('delete').send(authToken, id);
			token.addResponder(responder);
			return token;
		}
		
		public function update(authToken:String, oldItem:Object, newItem:Object):void
		{
			var updateDict:Object = {};
			
			/*	Does a diff of the old and new items to construct an updateDict
				suitable for the backend */
			for (var attribute:String in oldItem)
			{
				if (updateFieldsToIgnore.indexOf(attribute) == -1 && newItem.hasOwnProperty(attribute) && newItem[attribute] != oldItem[attribute])
				{
					if (newItem[attribute] is Array)
					{
						// Figure out what to add and what to remove
						var oldArray:PKArrayCollection = new PKArrayCollection(oldItem[attribute]);
						var newArray:PKArrayCollection = new PKArrayCollection(newItem[attribute]);
						var newDataSet:DataSet = new DataSet(newItem[attribute]);
						var add:Array = [];
						var remove:Array = [];
						
						/*	iterate through subitems, each of which should represent a relationship,
							looking for items to add */
						for each (var subItem:Object in newItem[attribute])
							if (subItem is Number && (oldArray.contains(subItem) == false))
								add.push(subItem);
							// This item must be special and will require instructions since it's doesn't have an id
							// Usually this is a relationship defining a through-table
							else if (!subItem.hasOwnProperty('id'))
							{
								// if there are special instructions...
								if (specialUpdateHandlingInfo.hasOwnProperty(attribute))
								{
									var addDict:Object = {'id' : subItem[specialUpdateHandlingInfo[attribute]['foreign_attribute_name']]}
									for each (var metaAttributeName:String in specialUpdateHandlingInfo[attribute]['attributes_to_include'])
									{
										addDict[metaAttributeName] = subItem[metaAttributeName];
									}
									add.push(addDict);
								}
							}
							else
							{
								if (!oldArray.contains(subItem['id']))
									add.push(subItem['id']);
							}
						
						/*	Look for subitems to remove
							If there are special handling instruction, then we
							must obtain the relationship's foreign key by using
							those instructions. */
						if (specialUpdateHandlingInfo.hasOwnProperty(attribute))
						{
							for each (var subItem2:Object in oldItem[attribute] as Array)
								if (!newArray.contains(subItem2['id']))
									remove.push(subItem2[specialUpdateHandlingInfo[attribute]['foreign_attribute_name']]);
						}
						else
						{
							for each (var pk2:Number in oldArray)
								if (!newArray.contains(pk2))
									remove.push(pk2);
						}
						
						// only include this if there are changes to be made
						if (add.length + remove.length > 0)
						{
							if (specialUpdateHandlingInfo.hasOwnProperty(attribute))
								updateDict[specialUpdateHandlingInfo[attribute]['attribute_to_update']] = {'add' : add, 'remove' : remove};
							else
								updateDict[attribute] = {'add' : add, 'remove' : remove};
						}
					}
					else
					{
						oldItem[attribute] = newItem[attribute];
						updateDict[attribute] = newItem[attribute];
					}
				}
			}
			
			// gives us an opportunity to do any data mangling that might be necessary.
			updateDict = mangleDict(updateDict, oldItem, newItem);
			
			// make sure we actually have some items to update before making a remote call
			var updateItemCount:int = 0;
			for (var item:* in updateDict)
				if (item != 'mx_internal_uid')
					updateItemCount++;
			
			if (updateItemCount > 0)
			{
				var token:AsyncToken = remoteObject.getOperation('update').send(authToken, newItem['id'], updateDict);
				token.addResponder(responder);
				token['updatedItem'] = oldItem;
			}
			else
			{
				dispatchEvent(new DelegateEvent(DelegateEvent.NOUPDATE));
			}
		}
		
		public function create(...args):void
		{
			convertDatesToISO8601(args);
			
			var token:AsyncToken = remoteObject.getOperation('create').send.apply(this, args);
			token.addResponder(responder);
		}
		
		/*	convert Date instances to ISO8601 Strings, recursively descending into
			dictionaries and arrays to find them. Passing an object to this method
			that is not an Array or dictionary is harmless to that object as long
			as it has no dynamically-added attributes which happen to be Dates. */
		protected function convertDatesToISO8601(args:Object):void
		{
			if (args is Array)
			{
				var argsArray:Array = args as Array;
				for (var i:Number=0; i<argsArray.length; i++)
				{
					if (argsArray[i] is Date)
						argsArray[i] = DateUtil.toW3CDTF(argsArray[i]);
					else
						convertDatesToISO8601(argsArray[i]);
				}
			}
			/*	args is not an array. It might be a dictionary, or might not be.
				If it is a dictionary, the for..in loop will iterate over its
				members. If it is some other kind of object (probably a String
				or number, because we don't support anything else I think),
				the for..in loop will be harmless since it only iterates over
				dynamically-added attributes. */
			else
			{
				for (var attr:String in args)
				{
					if (args[attr] is Date)
						args[attr] = DateUtil.toW3CDTF(args[attr]);
					else
						convertDatesToISO8601(args[attr]);
				}
			}
		}

		// processes named attributes through pre-defined manglers
		protected function mangleDict(dict:Object, oldItem:Object, newItem:Object):Object
		{
			for (var prop:String in mangleMap)
			{
				if (dict.hasOwnProperty(prop))
				{
					var func:Function = mangleMap[prop] as Function;
					dict[prop] = func(dict[prop], prop, oldItem, newItem);
				}
			}
			return dict;
		}
		
		protected function mangleForeignKey(value:Object, attributeName:String, oldItem:Object, newItem:Object):Object
		{
			if (value != null && value.hasOwnProperty('id'))
				return value['id'];
			else
				return value ? value : null;
		}
		
		protected function mangleDate(value:Date, attributeName:String=null, oldItem:Object=null, newItem:Object=null):String
		{
			var ret:String = null;
			if (value != null)
				ret = DateUtil.toW3CDTF(value);
			return ret;
		}

	}
}