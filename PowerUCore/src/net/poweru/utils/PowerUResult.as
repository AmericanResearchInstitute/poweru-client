package net.poweru.utils
{
	import mx.utils.ObjectProxy;
	
	public class PowerUResult
	{
		protected var _result:Object;
		public function PowerUResult(result:Object)
		{
			super();
			this._result = result;
		}
		
		public function get result():Object
		
		{
			return _result;
		}
		
		public function get statusOK():Boolean
		{
			return (status == 'OK');
		}
		
		public function get status():String
		{
			return _result.status;
		}
		
		public function get value():Object
		{
			return _result.value;
		}
		
		public function get errorMessage():String
		{
			if (_result.hasOwnProperty('error'))
				return _result.error[1];
			else
				return '';
		}
		
	}
}