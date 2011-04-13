package net.poweru.components.interfaces
{
	import mx.core.Container;
	
	public interface IMain extends IMultiState
	{
		function getSpace():Container;
		function setButtonBoxVisibility(visible:Boolean):void;
		function passwordChangeSuccess():void;
	}
}