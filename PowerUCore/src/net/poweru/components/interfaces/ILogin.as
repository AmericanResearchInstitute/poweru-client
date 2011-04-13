package net.poweru.components.interfaces
{
	public interface ILogin
	{
		function clearPassword():void;
		function getCredentials():Array;
		function setControlEnabledness(enabled:Boolean):void
	}
}