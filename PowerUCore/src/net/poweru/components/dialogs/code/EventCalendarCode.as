package net.poweru.components.dialogs.code
{
	import com.flexcalendar.components.calendar.core.dataModel.CalendarItem;
	import com.flexcalendar.components.calendar.core.dataModel.CalendarItemSet;
	
	import net.poweru.components.dialogs.BaseDialog;
	import net.poweru.components.interfaces.ICalendarDialog;
	
	public class EventCalendarCode extends BaseCalendarDialogCode implements ICalendarDialog
	{
		public function EventCalendarCode()
		{
			super();
		}
		
		public function populate(data:Array):void
		{
			var itemSet:CalendarItemSet = new CalendarItemSet();
			for each (var item:Object in data)
			{
				var label:String = item.shortname;
				if (item.hasOwnProperty('fullname') && (item['fullname'] as String).length > 0)
					label = label + ' (' + item['fullname'] + ')';
				if (item.hasOwnProperty('title') && (item['title'] as String).length > 0)
					label = label + ':' + item['title'];
				var calItem:CalendarItem = new CalendarItem(item['start'], item['end'], label, item['description'], false, null, label);
				calItem.data = item;
				itemSet.addItem(calItem);
			}
			dp.addItemSet(itemSet);
			calendar.refresh();
		}
	}
}