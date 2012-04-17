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
	import mx.containers.VBox;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.Button;
	import mx.controls.ComboBox;
	import mx.controls.DataGrid;
	import mx.controls.DateField;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.utils.ObjectUtil;
	
	import net.poweru.Constants;
	import net.poweru.Places;
	import net.poweru.components.interfaces.IUsers;
	import net.poweru.components.parts.UserFilters;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.ChooserResult;
	import net.poweru.model.DataSet;
	import net.poweru.proxies.UserProxy;
	import net.poweru.utils.ChooserRequestTracker;
	import net.poweru.utils.CompareLabels;
	import net.poweru.utils.PKArrayCollection;
	import net.poweru.utils.SortedDataSetFactory;
	
	public class UsersCode extends BaseComponent implements IUsers
	{
		[Bindable]
		public var grid:AdvancedDataGrid;
		[Bindable]
		public var bulkGrid:AdvancedDataGrid;
		[Bindable]
		public var curriculumEnrollmentGrid:DataGrid;
		public var orgRoleCB:ComboBox;
		public var accordion:Accordion;
		public var userFilters:UserFilters;
		public var bulkUserFilters:UserFilters;
		public var statuses:ComboBox;
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
		protected var chosenGroup:Object;
		[Bindable]
		public var examToAssign:Object;
		[Bindable]
		public var fileDownloadToAssign:Object;
		[Bindable]
		public var achievementGrid:DataGrid;
		public var credentialExpirationInput:DateField;
		[Bindable]
		protected var gridDataProvider:DataSet;
		[Bindable]
		protected var bulkGridDataProvider:DataSet;
		public var emailSubjectInput:TextInput;
		public var emailBodyInput:TextArea;
		[Bindable]
		protected var chosenOrganizationForBulkMembership:Object;
		protected var chooserRequestTracker:ChooserRequestTracker;
		protected var filterChooserRequestTracker:ChooserRequestTracker;
		protected var bulkFilterChooserRequestTracker:ChooserRequestTracker;
		[Bindable]
		protected var credentialTypeToGrant:Object;
		
		public function UsersCode()
		{
			super();
			chooserRequestTracker = new ChooserRequestTracker();
			filterChooserRequestTracker = new ChooserRequestTracker();
			bulkFilterChooserRequestTracker = new ChooserRequestTracker();
		}
		
		public function clear():void
		{
			populate([], [], [], [], []);
			chosenOrganizationForBulkMembership = null;
			chosenGroup = null;
			taskBundleToAssign = null;
			examToAssign = null;
			emailSubjectInput.text = '';
			emailBodyInput.text = '';
			accordion.selectedIndex = 0;
			credentialTypeToGrant = null;
			credentialExpirationInput.selectedDate = null;
		}
		
		/*	The accordion gets angry if you try to remove children that are
			above the selected index.
		*/
		override public function setState(state:String):void
		{
			accordion.validateNow();
			accordion.selectedIndex = 0;
			accordion.validateNow();
			super.setState(state);
			//accordion.selectedIndex = accordion.numChildren - 1;
		}
		
		public function populate(users:Array, orgRoles:Array, choices:Object, curriculumEnrollments:Array, events:Array):void
		{
			gridDataProvider.source = users;
			gridDataProvider.refresh();

			orgRoleDataSet.source = orgRoles;
			orgRoleDataSet.refresh();
			statusesDataSet.source = choices['status'] as Array;
			statusesDataSet.refresh();
			
			bulkGridDataProvider.source = users;
			bulkGridDataProvider.refresh();
			
			curriculumEnrollmentGrid.dataProvider = SortedDataSetFactory.singleFieldDateSort('start');
			curriculumEnrollmentGrid.dataProvider.source = curriculumEnrollments;
			curriculumEnrollmentGrid.dataProvider.refresh();
			
			eventGrid.dataProvider.source = events;
			eventGrid.dataProvider.refresh();
			
			examToAssign = null;
			fileDownloadToAssign = null;
		}
		
		public function receiveChoice(choice:ChooserResult, type:String):void
		{
			if (chooserRequestTracker.doIWantThis(type, choice.requestID))
			{
				switch (type)
				{
					case Places.CHOOSECREDENTIALTYPE:
						credentialTypeToGrant = choice.value;
						break;
					
					case Places.CHOOSEEXAM:
						examToAssign = choice.value;
						break;
					
					case Places.CHOOSEFILEDOWNLOAD:
						fileDownloadToAssign = choice.value;
						break;
				
					case Places.CHOOSEGROUP:
						chosenGroup = choice.value;
						break;
					
					case Places.CHOOSETASKBUNDLE:
						taskBundleToAssign = choice.value;
						break;
					
					case Places.CHOOSEORGANIZATION:
						chosenOrganizationForBulkMembership = choice.value;
						break;
				}
			}
			else if (filterChooserRequestTracker.doIWantThis(type, choice.requestID))
			{
				userFilters.receiveChoice(choice, type);
			}
			else if (bulkFilterChooserRequestTracker.doIWantThis(type, choice.requestID))
			{
				bulkUserFilters.receiveChoice(choice, type);
			}
		}

		protected function onCreationComplete(event:FlexEvent):void
		{
			gridDataProvider = SortedDataSetFactory.singleFieldSort('last_name');
			bulkGridDataProvider = SortedDataSetFactory.singleFieldSort('last_name');
			eventGrid.dataProvider = new DataSet();
			orgRoleCB.dataProvider = new DataSet();
			statuses.dataProvider = new DataSet();
			achievementGrid.dataProvider = new DataSet();
			
			// Show the accordion "collapsed" will all options at the top
			//accordion.selectedIndex = accordion.numChildren - 1;
			
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
			
			// call a chooser dialog (please "fetch" a choice)
			userFilters.addEventListener(ViewEvent.FETCH, onUserFiltersFetch);
			bulkUserFilters.addEventListener(ViewEvent.FETCH, onBulkUserFiltersFetch);
			// refresh the data provider ("submitting" its filters)
			userFilters.addEventListener(ViewEvent.SUBMIT, onUserFiltersSubmit);
			bulkUserFilters.addEventListener(ViewEvent.SUBMIT, onBulkUserFiltersSubmit);
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
		
		// event.body is the place name of a chooser
		protected function onUserFiltersFetch(event:ViewEvent):void
		{
			dispatchEvent(new ViewEvent(ViewEvent.SHOWDIALOG, [event.body as String, filterChooserRequestTracker.getChooserRequest(event.body as String)]));
		}
		
		// event.body is the place name of a chooser
		protected function onBulkUserFiltersFetch(event:ViewEvent):void
		{
			dispatchEvent(new ViewEvent(ViewEvent.SHOWDIALOG, [event.body as String, bulkFilterChooserRequestTracker.getChooserRequest(event.body as String)]));
		}
		
		// when "Apply" button is clicked
		protected function onUserFiltersSubmit(event:ViewEvent):void
		{
			gridDataProvider.refresh();
		}
		
		// when "Apply" button is clicked
		protected function onBulkUserFiltersSubmit(event:ViewEvent):void
		{
			bulkGridDataProvider.refresh();
		}
		
		// Add users in bulk to the selected group.
		protected function onAddToGroup(event:Event):void
		{
			for each (var user:Object in bulkGrid.selectedItems)
			{
				var currentGroups:DataSet = new DataSet(user['groups'] as Array);
				if (!currentGroups.findByPK(chosenGroup['id']))
				{
					user['groups'].push(chosenGroup);
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
				dispatchEvent(new ViewEvent(ViewEvent.SUBMIT, curriculum, Constants.CURRICULUMENROLLMENT));
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
					'organization' : chosenOrganizationForBulkMembership.id
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
		
		protected function onGrantCredentialType(event:Event):void
		{
			var newCredentials:ArrayCollection = new ArrayCollection();
			for each (var user:Object in bulkGrid.selectedItems)
			{
				var credential:Object = {
					'user' : user.id,
					'credential_type' : credentialTypeToGrant.id,
					'status' : 'granted'
				};
				if (credentialExpirationInput.selectedDate != null)
					credential['date_expires'] = credentialExpirationInput.selectedDate;
				
				newCredentials.addItem(credential);
			}
			dispatchEvent(new ViewEvent(ViewEvent.SUBMIT, newCredentials.toArray(), Constants.CREDENTIAL));
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
		
		protected function onClickChooseOrgForBulkAction(event:Event):void
		{
			dispatchEvent(new ViewEvent(ViewEvent.SHOWDIALOG, [Places.CHOOSEORGANIZATION, chooserRequestTracker.getChooserRequest(Places.CHOOSEORGANIZATION)]))
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
		
		protected function get orgRoleDataSet():DataSet
		{
			return orgRoleCB.dataProvider as DataSet;
		}
		
		protected function get statusesDataSet():DataSet
		{
			return statuses.dataProvider as DataSet;
		}
	}
}