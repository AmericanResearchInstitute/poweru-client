package net.poweru.utils
{
	import mx.controls.Alert;
	import mx.rpc.IResponder;

	public class PowerUResponder implements IResponder
	{
		protected var _result:Function;
		protected var _error:Function;
		protected var _fault:Function;
		protected var _supressErrorMessage:Boolean;
		
		/*	success() will be called when the request was successful. error()
			will be called when the request was processed, but PowerU returned
			an error.  fault() will be called when the request could not be
			processed, such as if a network failure occurs. By default, if error()
			is called, it will display the error message to the user, unless
			supressErrorMessage==true */
		public function PowerUResponder(success:Function, error:Function, fault:Function, supressErrorMessage:Boolean=false)
		{
			_result = success;
			_error = error;
			_fault = fault;
			_supressErrorMessage = supressErrorMessage;
		}

		public function result(data:Object):void
		{
			var powerUResult:PowerUResult = new PowerUResult(data.result);
			if (powerUResult.statusOK)
			{
				_result(data);
			}
			else
			{
				if (!_supressErrorMessage)
					Alert.show(powerUResult.errorMessage, 'ERROR!');
				_error(data);
			}
		}
		
		public function fault(info:Object):void
		{
			_fault(info);
		}
		
	}
}