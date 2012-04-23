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
	}
}