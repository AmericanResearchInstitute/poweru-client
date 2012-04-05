package net.poweru.components.code
{
	import flash.events.Event;
	
	import mx.containers.HBox;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.Tree;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.core.IFlexDisplayObject;
	import mx.events.DragEvent;
	import mx.managers.PopUpManager;
	
	import net.poweru.components.dialogs.ConfirmDialog;
	import net.poweru.components.interfaces.IOrganizations;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.HierarchicalDataSet;

	public class OrganizationsCode extends BaseComponent implements IOrganizations
	{
		[Bindable]
		public var organizations:Tree;
		[Bindable]
		public var users:AdvancedDataGrid;
		
		protected var draggedItem:Object;
		
		public function OrganizationsCode()
		{
			super();
		}
		
		public function populate(data:Array):void
		{
			users.dataProvider.source = [];
			users.dataProvider.refresh();
			
			if (organizations.dataProvider == null)
				organizations.dataProvider = new HierarchicalDataSet([], 'id', 'name');
			organizations.dataProvider.source = data;
			organizations.dataProvider.refresh();
			// make sure all nodes are open
			organizations.validateNow();
			for each (var organization:Object in organizations.dataProvider)
				organizations.expandChildrenOf(organization, true);
		}
		
		public function clear():void
		{
			populate([]);
			users.dataProvider.source = [];
			users.dataProvider.refresh();
		}
		
		public function populateUsers(data:Array):void
		{
			/*	we assume that the mediator is sending us users for the most recently
				requested org */
			if (organizations.selectedItem != null)
			{
				users.dataProvider.source = data;
				users.dataProvider.refresh();
			}
		}
		
		protected function get dataSet():HierarchicalDataSet
		{
			return organizations.dataProvider as HierarchicalDataSet;
		}
		
		// If the item was moved to a new location, open a dialog to confirm.
		protected function onDragComplete(event:DragEvent):void
		{
			if (draggedItem)
			{
				var newParent:Object = dataSet.findParent(draggedItem['id']);
				var newParentPK:Number = (newParent != null) ? newParent['id'] : null;
				var oldParentPK:Number = draggedItem['parent'];
				if (newParentPK != oldParentPK)
				{
					var dialog:ConfirmDialog = new ConfirmDialog();
					dialog.addEventListener(ViewEvent.CONFIRM, onNewParentConfirm);
					dialog.addEventListener(ViewEvent.CANCEL, onNewParentCancel);
					dialog.data = draggedItem;
					dialog.message = 'Are you sure you want to make ' + draggedItem['name'] + (newParent != null ? ' a child of ' + newParent['name'] : ' a top level organization') + '?';
					PopUpManager.addPopUp(dialog, this, true);
					PopUpManager.centerPopUp(dialog);
				}
				draggedItem = null;
			}
		}
		
		// Confirm that the user wants to do the move before actually doing the move.
		protected function onNewParentConfirm(event:ViewEvent):void
		{
			(event.target as ConfirmDialog).removeEventListener(ViewEvent.CONFIRM, onNewParentConfirm);
			(event.target as ConfirmDialog).removeEventListener(ViewEvent.CANCEL, onNewParentCancel);
			PopUpManager.removePopUp(event.target as IFlexDisplayObject);
			event.stopImmediatePropagation();
			
			// Update the item's 'parent' attribute.
			var parent:Object = dataSet.findParent(event.body['id']);
			if (parent == null)
				event.body['parent'] = null;
			else
				event.body['parent'] = parent['id']; 
			dispatchEvent(new ViewEvent(ViewEvent.SUBMIT, event.body));
		}
		
		// Figure out to where the item was moved, and where it originated.
		// Then move it back.
		protected function onNewParentCancel(event:ViewEvent):void
		{
			(event.target as ConfirmDialog).removeEventListener(ViewEvent.CONFIRM, onNewParentConfirm);
			(event.target as ConfirmDialog).removeEventListener(ViewEvent.CANCEL, onNewParentCancel);
			event.stopImmediatePropagation();
			PopUpManager.removePopUp(event.target as IFlexDisplayObject);
			
			var item:Object = event.body;
			var newParent:Object = dataSet.findParent(item['id']);
			var oldParent:Object = dataSet.findByPK(item['parent']);
			
			// Remove item from new location
			if (newParent == null)
				dataSet.removeItemAt(dataSet.getItemIndex(item));
			else
			{
				var newParentChildren:Array = newParent['children'] as Array;
				newParentChildren.splice(newParentChildren.indexOf(item), 1);
			}
			
			// Add item back to old location
			if (oldParent == null)
				dataSet.addOrReplace(item);
			else
			{
				var oldParentChildren:Array = oldParent['children'] as Array;
				if (oldParentChildren.indexOf(item) == -1)
					oldParentChildren.push(item);
			}
			
			dataSet.refresh();
			refreshTree(organizations);
		}
		
		protected function refreshTree(tree:Tree):void
		{
			tree.invalidateList();
			tree.validateNow();
		}
		
		protected function onSelectionChange(event:Event):void
		{
			dispatchEvent(new ViewEvent(ViewEvent.FETCH, organizations.selectedItem['id']))
			users.dataProvider.source = [];
			users.dataProvider.refresh();
		}
		
		protected function onDragBegin(event:DragEvent):void
		{
			draggedItem = organizations.selectedItem;
		}
		
		protected function ownerLabel(item:Object, column:AdvancedDataGridColumn):String
		{
			var ret:String = '';
			if (item.hasOwnProperty('owner') && item['owner'] != null && item['owner'].hasOwnProperty(column.dataField))
				ret = item['owner'][column.dataField];
			return ret;
		}
		
		protected function roleLabel(item:Object, column:AdvancedDataGridColumn):String
		{
			return item['role']['name'];
		}
		
	}
}