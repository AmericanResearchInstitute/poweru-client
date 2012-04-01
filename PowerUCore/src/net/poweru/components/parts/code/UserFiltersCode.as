package net.poweru.components.parts.code
{
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.controls.DataGrid;
	import mx.events.FlexEvent;
	
	import net.poweru.Places;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.ChooserResult;
	import net.poweru.model.DataSet;
	import net.poweru.utils.SortedDataSetFactory;
	
	public class UserFiltersCode extends VBox
	{
		protected static const GROUP_NAME:String = 'Group';
		protected static const STATUS_NAME:String = 'Status';
		protected static const CREDENTIAL_NAME:String = 'Credential';
		protected static const ACHIEVEMENT_NAME:String = 'Achievement';
		protected static const ORGANIZATION_NAME:String = 'Organization';
		protected static const ORG_ROLE_NAME:String = 'Org Role';
		
		public static var filterObjects:Array = [
			{'name': GROUP_NAME, 'constraint' : null},
			{'name': STATUS_NAME, 'constraint' : null},
			{'name': CREDENTIAL_NAME, 'constraint' : null},
			{'name': ACHIEVEMENT_NAME, 'constraint' : null},
			{'name': ORGANIZATION_NAME, 'constraint' : null},
			{'name': ORG_ROLE_NAME, 'constraint' : null}
		];
		
		[Bindable]
		public var availableGrid:DataGrid;
		[Bindable]
		public var activeGrid:DataGrid;
		[Bindable]
		protected var availableDataSet:DataSet;
		[Bindable]
		protected var activeDataSet:DataSet;
		
		protected var chosenGroup:Object;
		protected var chosenStatus:String;
		protected var chosenAchievement:Object;
		protected var chosenOrganization:Object;
		protected var chosenOrgRole:Object;
		
		public function UserFiltersCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		protected function activateFilter(name:String, constraintName:String):void
		{
			var item:Object = availableDataSet.findByKey('name', name);
			availableDataSet.removeByKey('name', name);
			item['constraint'] = constraintName;
			activeDataSet.addItem(item);
			activeDataSet.refresh();
		}
		
		public function receiveChoice(choice:ChooserResult, type:String):void
		{
			switch (type)
			{
				case Places.CHOOSEACHIEVEMENT:
					chosenAchievement = choice.value;
					activateFilter(ACHIEVEMENT_NAME, chosenAchievement['name']);
					break;
				
				case Places.CHOOSEGROUP:
					chosenGroup = choice.value;
					activateFilter(GROUP_NAME, chosenGroup['name']);
					break;
				
				case Places.CHOOSEORGANIZATION:
					chosenOrganization = choice.value;
					activateFilter(ORGANIZATION_NAME, chosenOrganization['name']);
					break;
				
				case Places.CHOOSEORGROLE:
					chosenOrgRole = choice.value;
					activateFilter(ORG_ROLE_NAME, chosenOrgRole['name']);
					break;
				
				case Places.CHOOSEUSERSTATUS:
					chosenStatus = choice.value as String;
					activateFilter(STATUS_NAME, chosenStatus);
					break;
			}
		}
		
		public function filterFunction(item:Object):Boolean
		{
			var ret:Boolean = true; 
			if (chosenGroup != null && ret)
				ret = filterByGroup(item);
			if (chosenStatus != null && ret)
				ret = filterByStatus(item);
			if (chosenAchievement != null && ret)
				ret = filterByAchievement(item);
			if (chosenOrganization != null && ret)
				ret = filterByOrganization(item);
			if (chosenOrgRole != null && ret)
				ret = filterByOrgRole(item);
			
			return ret;
		}
		
		/*	returns false for any user who does not have the specified org role.
			if there is a chosen organization, this will also enforce that the
			user must have the chosen org role in the chosen org. */
		protected function filterByOrgRole(item:Object):Boolean
		{
			var ret:Boolean = true;
			if (chosenOrgRole != null)
			{
				ret = false;
				for each (var userOrgRole:Object in item.owned_userorgroles)
				{
					if (userOrgRole.role_name == chosenOrgRole.name)
					{
						if (chosenOrganization != null)
						{
							if (userOrgRole.organization == chosenOrganization.id)
							{
								ret = true;
								break;
							}
						}
						else
						{
							ret = true;
							break;
						}
					}
				}
			}
			return ret;
		}
		
		protected function filterByOrganization(item:Object):Boolean
		{
			var ret:Boolean = true;
			if (chosenOrganization != null)
			{
				ret = false;
				for each (var userOrgRole:Object in item.owned_userorgroles)
				{
					if (userOrgRole.organization == chosenOrganization.id)
					{
						ret = true;
						break;
					}
				}
			}
			return ret;
		}
		
		protected function filterByAchievement(item:Object):Boolean
		{
			var ret:Boolean = true;
			if (chosenAchievement != null)
			{
				ret = false;
				for each (var achievement:Object in item.achievements)
				{
					if (achievement.name == chosenAchievement.name)
					{
						ret = true;
						break;
					}
				}
			}
			return ret;
		}
		
		protected function filterByStatus(item:Object):Boolean
		{
			return (item['status'] == chosenStatus);
		}
		
		protected function filterByGroup(item:Object):Boolean
		{
			var ret:Boolean = true;
			if (chosenGroup != null)
			{
				ret = false;
				for each (var group:Object in item.groups)
				{
					if (group.name == chosenGroup.name)
					{
						ret = true;
						break;
					}
				}
			}
			return ret;
		}
		
		protected function launchChooser(filterName:String):void
		{
			switch (filterName)
			{
				case ACHIEVEMENT_NAME:
					dispatchEvent(new ViewEvent(ViewEvent.FETCH, Places.CHOOSEACHIEVEMENT));
					break;
				
				case GROUP_NAME:
					dispatchEvent(new ViewEvent(ViewEvent.FETCH, Places.CHOOSEGROUP));
					break;
				
				case ORGANIZATION_NAME:
					dispatchEvent(new ViewEvent(ViewEvent.FETCH, Places.CHOOSEORGANIZATION));
					break;
				
				case ORG_ROLE_NAME:
					dispatchEvent(new ViewEvent(ViewEvent.FETCH, Places.CHOOSEORGROLE));
					break;
				
				case STATUS_NAME:
					dispatchEvent(new ViewEvent(ViewEvent.FETCH, Places.CHOOSEUSERSTATUS));
					break;
			}
		}
		
		protected function removeChosenItemByName(name:String):void
		{
			switch (name)
			{
				case ACHIEVEMENT_NAME:
					chosenAchievement = null;
					break;
				
				case GROUP_NAME:
					chosenGroup = null;
					break;
				
				case ORGANIZATION_NAME:
					chosenOrganization = null;
					break;
				
				case STATUS_NAME:
					chosenStatus = null;
					break;
				
				case ORG_ROLE_NAME:
					chosenOrgRole = null;
					break;
			}
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			availableDataSet = SortedDataSetFactory.singleFieldSort('name');
			availableDataSet.source = filterObjects;
			availableDataSet.refresh();
			activeDataSet = SortedDataSetFactory.singleFieldSort('name');
		}
		
		protected function onClickActivate(event:MouseEvent):void
		{
			launchChooser(availableGrid.selectedItem.name);
		}
		
		protected function onClickRemove(event:MouseEvent):void
		{
			var item:Object = activeGrid.selectedItem;
			if (item != null)
			{
				activeDataSet.removeByKey('name', item.name);
				activeDataSet.refresh();
				removeChosenItemByName(item.name);
				item.constraint = null;
				availableDataSet.addItem(item);
				availableDataSet.refresh();
			}
		}
	}
}