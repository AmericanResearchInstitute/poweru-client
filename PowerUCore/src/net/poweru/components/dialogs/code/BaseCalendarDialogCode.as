package net.poweru.components.dialogs.code
{
	import com.flexcalendar.components.calendar.FlexCalendar;
	import com.flexcalendar.components.calendar.core.dataModel.CalendarDataProvider;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseDialog;
	
	public class BaseCalendarDialogCode extends BaseDialog
	{
		public var calendar:FlexCalendar;
		[Bindable]
		public var dp:CalendarDataProvider;
		
		public function BaseCalendarDialogCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function set license(value:String):void
		{
			calendar.license = value;
			calendar.visible = true;
		}
		
		public function clear():void
		{
			dp.itemSets = new ArrayCollection();
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			dp = new CalendarDataProvider();
		}
	}
}