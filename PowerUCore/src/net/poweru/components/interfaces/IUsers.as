package net.poweru.components.interfaces
{
	import mx.collections.ArrayCollection;
	
	public interface IUsers extends IClearableComponent
	{
		function populate(users:Array, organizations:Array, orgRoles:Array, groups:Array, choices:Object, curriculumEnrollments:Array, events:Array):void;
		function receiveChoice(choice:Object, type:String):void;
		function emailSent():void;
	}
}