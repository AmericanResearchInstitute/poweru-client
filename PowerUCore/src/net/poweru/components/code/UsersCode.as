package net.poweru.components.code
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.containers.Accordion;
	import mx.containers.HBox;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.Button;
	import mx.controls.ComboBox;
	import mx.controls.Tree;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.events.FlexEvent;
	import mx.utils.ObjectUtil;
	
	import net.poweru.Constants;
	import net.poweru.Places;
	import net.poweru.components.interfaces.IUsers;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.model.HierarchicalDataSet;
	
	public class UsersCode extends HBox implements IUsers
	{
		[Bindable]
		public var grid:AdvancedDataGrid;
		[Bindable]
		public var bulkGrid:AdvancedDataGrid;
		[Bindable]
		public var organizationTree:Tree;
		public var orgRoleCB:ComboBox;
		public var accordion:Accordion;
		public var statuses:ComboBox;
		[Bindable]
		public var statusFilterCB:ComboBox;
		[Bindable]
		public var orgFilterCB:ComboBox;
		[Bindable]
		public var groupCB:ComboBox;
		[Bindable]
		public var buttonBox:HBox;
		[Bindable]
		public var viewingActivityButton:Button;
		[Bindable]
		public var editButton:Button;
		
		public function UsersCode()
		{
			super();
		}
		
		public function clear():void
		{
			populate([], [], [], [], []);
		}
		
		public function populate(users:Array, organizations:Array, orgRoles:Array, groups:Array, choices:Object):void
		{
			grid.dataProvider.source = users;
			grid.dataProvider.refresh();
			
			organizationDataSet.source = organizations;
			organizationDataSet.refresh();
			orgRoleDataSet.source = orgRoles;
			orgRoleDataSet.refresh();
			statusesDataSet.source = choices['status'] as Array;
			statusesDataSet.refresh();
			
			statusFilterDataSet.source = ObjectUtil.copy(choices['status']) as Array;
			statusFilterDataSet.source.push(Constants.ALL);
			statusFilterDataSet.refresh();
			
			var orgHDS:HierarchicalDataSet = new HierarchicalDataSet();
			orgHDS.source = ObjectUtil.copy(organizations) as Array;
			orgHDS.source.push({'name' : Constants.ALL});
			orgHDS.source.push({'name' : Constants.NONE});
			orgHDS.refresh();
			
			orgFilterDataSet.source = orgHDS.getDescendants();
			orgFilterDataSet.refresh();
			
			statusFilterCB.selectedItem = Constants.ALL;
			orgFilterCB.selectedItem = orgFilterDataSet.findByKey('name', Constants.ALL);
			
			groupCB.dataProvider = groups;
			
			bulkDataSet.source = users;
			bulkDataSet.refresh();
		}

		protected function onCreationComplete(event:FlexEvent):void
		{
			grid.dataProvider = new ArrayCollection();
			bulkGrid.dataProvider = new DataSet();
			bulkDataSet.filterFunction = filterBulkUsers;
			organizationTree.dataProvider = new DataSet();
			orgRoleCB.dataProvider = new DataSet();
			statuses.dataProvider = new DataSet();
			statusFilterCB.dataProvider = new DataSet();
			orgFilterCB.dataProvider = new DataSet();
			
			var statusSort:Sort = new Sort();
			statusSort.compareFunction = compareLabels;
			statusFilterDataSet.sort = statusSort;
			
			var orgSort:Sort = new Sort();
			orgSort.compareFunction = compareLabels;
			orgSort.fields = [new SortField('name')];
			orgFilterDataSet.sort = orgSort;
			
			// Show the accordion "collapsed" will all options at the top
			accordion.selectedIndex = accordion.getChildren().length - 1;
			
			/*	If the Viewing Activity button isn't included yet in the layout,
				make it an orphan so it will be garbage collected. */
			if (viewingActivityButton.includeInLayout == false)
			{
				buttonBox.removeChild(viewingActivityButton);
				viewingActivityButton = null;
			}
			else
			{
				viewingActivityButton.addEventListener(MouseEvent.CLICK, onShowViewingActivityReport);
				BindingUtils.bindProperty(viewingActivityButton, 'enabled', editButton, 'enabled');
			}
			
		}
		
		/*	Compare labels, considering that "All" and "None" should come first.
			Don't ever use this with more than one sort field. */
		protected function compareLabels(a:Object, b:Object, fields:Array=null):int
		{
			var aLabel:String;
			var bLabel:String;
			var ret:int = 0;
			
			if (fields != null && fields.length == 1)
			{
				/*	In the first round, we get SortField objects, and every
					time after we get strings.  I don't know why. */
				var field:Object = fields[0];
				if (field is SortField)
				{
					aLabel = a[(field as SortField).name];
					bLabel = b[(field as SortField).name];
				}
				else
				{
					aLabel = a[field as String];
					bLabel = b[field as String];
				}
			}
			else
			{
				aLabel = a as String;
				bLabel = b as String;
			}
			
			if (aLabel == Constants.ALL)
				ret = -1;
			else if (aLabel == Constants.NONE && bLabel != Constants.ALL)
				ret = -1;
			else if (bLabel == Constants.ALL)
				ret = 1;
			else if (bLabel == Constants.NONE && aLabel != Constants.ALL)
				ret = 1;
			else
				ret = ObjectUtil.stringCompare(aLabel, bLabel);
				
			return ret;
		}
		
		protected function labelUsername(item:Object, column:AdvancedDataGridColumn):String
		{
			return item['default_username_and_domain']['username'];
		}
		
		// Filter based on selections in the filter controls
		protected function filterBulkUsers(item:Object):Boolean
		{
			var ret:Boolean = true;
			
			switch (statusFilterCB.selectedLabel)
			{
				// Leave it as true
				case Constants.ALL:
					break;
				
				// true if user has selected status
				default:
					ret = Boolean(statusFilterCB.selectedLabel == item['status']);
			}
			
			if (ret)
			{
				var orgAssociations:DataSet = new DataSet(item['owned_userorgroles'] as Array);
				
				switch (orgFilterCB.selectedLabel)
				{
					// Leave it as true
					case Constants.ALL:
						break;
					
					// true only if there are no org associations
					case Constants.NONE:
						ret = Boolean(orgAssociations.length == 0);
						break;
					
					// true if selected org is found among user's org associations
					default:
						ret = Boolean(orgAssociations.findByKey('organization_name', orgFilterCB.selectedLabel) != null);
				}
			}
				
			return ret;
		}
		
		// Add users in bulk to the selected group.
		protected function onAddToGroup(event:Event):void
		{
			for each (var user:Object in bulkGrid.selectedItems)
			{
				var currentGroups:DataSet = new DataSet(user['groups'] as Array);
				if (!currentGroups.findByPK(groupCB.selectedItem['id']))
				{
					user['groups'].push(groupCB.selectedItem);
					dispatchEvent(new ViewEvent(ViewEvent.SUBMIT, user));
				}
			}
		}
		
		protected function onUpdateStatus(event:Event):void
		{
			for each (var item:Object in bulkGrid.selectedItems)
			{
				item['status'] = statuses.selectedLabel;
				dispatchEvent(new ViewEvent(ViewEvent.SUBMIT, item));
			}
		}
		
		// Adds selected users in bulk to an org with the chosen role.
		protected function onAddToOrg(event:Event):void
		{
			for each (var user:Object in bulkGrid.selectedItems)
			{
				var itemsAdded:Boolean = false;
				var newRelationship:Object = {
					'role' : orgRoleCB.selectedItem['id'],
					'organization' : organizationTree.selectedItem['id']
				}
				if (!userAlreadyHasOrgRole(user, newRelationship))
				{
					(user['owned_userorgroles'] as Array).push(newRelationship);
					itemsAdded = true;
				}
				if (itemsAdded)
					dispatchEvent(new ViewEvent(ViewEvent.SUBMIT, user));
			}
		}
		
		protected function onShowViewingActivityReport(event:MouseEvent):void
		{
			dispatchEvent(new ViewEvent(ViewEvent.SHOWDIALOG, [Places.VIEWINGACTIVITYREPORT, [grid.selectedItem.id]]));
		}
		
		// Determine if a user already has the specified userOrgRole
		protected function userAlreadyHasOrgRole(user:Object, orgRole:Object):Boolean
		{
			var ret:Boolean = false;
			for each (var relationship:Object in (user['owned_userorgroles'] as Array))
			{
				if (relationship['role'] == orgRole['role'] && relationship['organization'] == orgRole['organization'])
				{
					ret = true;
					break;
				}
			}
			
			return ret;
		}

		public function get bulkDataSet():DataSet
		{
			return bulkGrid.dataProvider as DataSet;
		}
		
		protected function get organizationDataSet():DataSet
		{
			return organizationTree.dataProvider as DataSet;
		}
		
		protected function get orgRoleDataSet():DataSet
		{
			return orgRoleCB.dataProvider as DataSet;
		}
		
		protected function get statusesDataSet():DataSet
		{
			return statuses.dataProvider as DataSet;
		}
		
		protected function get statusFilterDataSet():DataSet
		{
			return statusFilterCB.dataProvider as DataSet;
		}
		
		protected function get orgFilterDataSet():DataSet
		{
			return orgFilterCB.dataProvider as DataSet;
		}
	}
}