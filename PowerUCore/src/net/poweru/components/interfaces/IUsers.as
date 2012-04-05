package net.poweru.components.interfaces
{
	import mx.collections.ArrayCollection;
	
	import net.poweru.model.ChooserResult;
	
	public interface IUsers extends IClearableComponent
	{
		function populate(users:Array, orgRoles:Array, choices:Object, curriculumEnrollments:Array, events:Array):void;
		function receiveChoice(choice:ChooserResult, type:String):void;
		function emailSent():void;
		function setState(state:String):void;
	}
}