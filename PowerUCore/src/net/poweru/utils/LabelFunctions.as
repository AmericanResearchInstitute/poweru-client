package net.poweru.utils
{
	import mx.controls.dataGridClasses.DataGridColumn;

	public class LabelFunctions
	{
		protected static var TASK_TYPE_MAP:Object = {
			'file_tasks.file download' : 'File Download',
			'file_tasks.file upload' : 'File Upload',
			'pr_services.session user role requirement' : 'Session',
			'pr_services.exam' : 'Exam'
		};
		
		protected static const LEAD_TIME_UNITS:Array = [
			{'name' : 'seconds', 'multiplier' : 1},
			{'name' : 'minutes', 'multiplier' : 60},
			{'name' : 'hours', 'multiplier' : 60*60},
			{'name' : 'days', 'multiplier' : 60*60*24}
		];
		
		public function LabelFunctions()
		{
		}
		
		public static function taskType(item:Object, column:DataGridColumn):String
		{
			var rawType:String = item[column.dataField];
			var ret:String = rawType;
			if (TASK_TYPE_MAP.hasOwnProperty(rawType))
				ret = TASK_TYPE_MAP[rawType];
			return ret;
		}
		
		public static function getLeadTimeFormatInfo(seconds:Number):Object
		{
			var ret:Object;
			var i:uint;
			for (i=LEAD_TIME_UNITS.length - 1; i >= 0; i--)
			{
				if (seconds % LEAD_TIME_UNITS[i]['multiplier'] == 0)
				{
					ret = {'value' : seconds/LEAD_TIME_UNITS[i]['multiplier'], 'units' : LEAD_TIME_UNITS[i]['name']};
					break;
				}
			}
			return ret;
		}
		
		public static function formatLeadTime(seconds:Number):String
		{
			var info:Object = getLeadTimeFormatInfo(seconds);
			return info['value'] + ' ' + info['units'];
		}
	}
}