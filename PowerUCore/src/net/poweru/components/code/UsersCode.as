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
	import mx.controls.DataGrid;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.controls.Tree;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.utils.ObjectUtil;
	
	import net.poweru.Constants;
	import net.poweru.Places;
	import net.poweru.components.interfaces.IUsers;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.model.HierarchicalDataSet;
	import net.poweru.proxies.UserProxy;
	import net.poweru.utils.CompareLabels;
	import net.poweru.utils.PKArrayCollection;
	import net.poweru.utils.SortedDataSetFactory;
	
	public class UsersCode extends HBox implements IUsers
	{
		[Bindable]
		public var grid:AdvancedDataGrid;
		[Bindable]
		public var bulkGrid:AdvancedDataGrid;
		[Bindable]
		public var curriculumEnrollmentGrid:DataGrid;
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
		[Bindable]
		public var eventGrid:DataGrid;
		[Bindable]
		public var taskBundleToAssign:Object;
		[Bindable]
		public var examToAssign:Object;
		[Bindable]
		public var fileDownloadToAssign:Object;
		[Bindable]
		public var achievementGrid:DataGrid;
		[Bindable]
		protected var gridDataProvider:DataSet;
		public var emailSubjectInput:TextInput;
		public var emailBodyInput:TextArea;
		
		public function UsersCode()
		{
			super();
		}
		
		public function clear():void
		{
			populate([], [], [], [], [], [], []);
		}
		
		public function populate(users:Array, organizations:Array, orgRoles:Array, groups:Array, choices:Object, curriculumEnrollments:Array, events:Array):void
		{
			gridDataProvider.source = users;
			gridDataProvider.refresh();
			
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
			
			curriculumEnrollmentGrid.dataProvider = new DataSet(curriculumEnrollments);
			
			eventGrid.dataProvider.source = events;
			eventGrid.dataProvider.refresh();
			
			examToAssign = null;
			fileDownloadToAssign = null;
		}
		
		public function receiveChoice(choice:Object, type:String):void
		{
			switch (type)
			{
				case Places.CHOOSEEXAM:
					examToAssign = choice;
					break;
				
				case Places.CHOOSEFILEDOWNLOAD:
					fileDownloadToAssign = choice;
					break;
				
				case Places.CHOOSETASKBUNDLE:
					taskBundleToAssign = choice;
					break;
			}
		}

		protected function onCreationComplete(event:FlexEvent):void
		{
			gridDataProvider = SortedDataSetFactory.singleFieldSort('last_name');
			bulkGrid.dataProvider = SortedDataSetFactory.singleFieldSort('last_name');
			bulkDataSet.filterFunction = filterBulkUsers;
			eventGrid.dataProvider = new DataSet();
			organizationTree.dataProvider = new DataSet();
			orgRoleCB.dataProvider = new DataSet();
			statuses.dataProvider = new DataSet();
			statusFilterCB.dataProvider = new DataSet();
			orgFilterCB.dataProvider = new DataSet();
			achievementGrid.dataProvider = new DataSet();
			
			var statusSort:Sort = new Sort();
			statusSort.compareFunction = CompareLabels;
			statusFilterDataSet.sort = statusSort;
			
			var orgSort:Sort = new Sort();
			orgSort.compareFunction = CompareLabels;
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
		
		public function emailSent():void
		{
			emailSubjectInput.text = '';
			emailBodyInput.text = '';
		}
		
		protected function assignTask(taskID:Number):void
		{
			var userIDs:PKArrayCollection = new PKArrayCollection(bulkGrid.selectedItems);
			dispatchEvent(new ViewEvent(ViewEvent.SUBMIT, {'users': userIDs.toArray(), 'task': taskID}, 'BulkAssign'))
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
		
		protected function onAddToCurriculumEnrollment(event:Event):void
		{
			var curriculum:Object = curriculumEnrollmentGrid.selectedItem;
			for each (var user:Object in bulkGrid.selectedItems)
			{
				if ((curriculum.users as Array).indexOf(user['id']) == -1)
					(curriculum.users as Array).push(user['id']);
				dispatchEvent(new ViewEvent(ViewEvent.SUBMIT, curriculum, 'CurriculumEnrollment'));
			}
		}
		
		protected function onEnrollInEvent(event:Event):void
		{
			//var event:Object = eventGrid.selectedItem;
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
		
		protected function onAssignTaskBundle(event:Event):void
		{
			if (taskBundleToAssign != null && taskBundleToAssign.hasOwnProperty('tasks'))
			{
				for each (var task:Object in taskBundleToAssign['tasks'])
				{
					assignTask(task['id']);
				}
			}
		}
		
		protected function onAssignExam(event:Event):void
		{
			assignTask(examToAssign.id);
		}
		
		protected function onAssignFileDownload(event:Event):void
		{
			assignTask(fileDownloadToAssign.id);
		}
		
		protected function onSendEmail(event:Event):void
		{
			var info:Object = {
				'users' : new PKArrayCollection(bulkGrid.selectedItems).toArray(),
				'body' : emailBodyInput.text,
				'subject' : emailSubjectInput.text
			};
			dispatchEvent(new ViewEvent(ViewEvent.SUBMIT, info, Constants.SENDEMAIL));	
		}
		
		protected function onShowViewingActivityReport(event:MouseEvent):void
		{
			dispatchEvent(new ViewEvent(ViewEvent.SHOWDIALOG, [Places.VIEWINGACTIVITYREPORT, [grid.selectedItem.id]]));
		}
		
		protected function onUserSelected(event:ListEvent):void
		{
			if (grid.selectedItem != null)
				dispatchEvent(new ViewEvent(ViewEvent.FETCH, grid.selectedItem.id));
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