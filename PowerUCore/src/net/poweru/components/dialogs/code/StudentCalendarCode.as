package net.poweru.components.dialogs.code
{
	import com.flexcalendar.components.calendar.core.dataModel.CalendarItem;
	import com.flexcalendar.components.calendar.core.dataModel.CalendarItemSet;
	
	import net.poweru.components.interfaces.ICalendarDialog;

	public class StudentCalendarCode extends BaseCalendarDialogCode implements ICalendarDialog
	{
		public function StudentCalendarCode()
		{
			super();
		}
		
		public function populate(data:Array):void
		{
			var itemSet:CalendarItemSet = new CalendarItemSet();
			for each (var item:Object in data)
			{
				var session:Object = item['task']['session'];
				if (session.hasOwnProperty('start') && session.hasOwnProperty('end'))
				{
					var calItem:CalendarItem = new CalendarItem(session['start'], session['end'], item['task']['title'], item['task']['description']);
					calItem.data = item;
					itemSet.addItem(calItem);
				}
			}
			dp.addItemSet(itemSet);
		}
	}
}