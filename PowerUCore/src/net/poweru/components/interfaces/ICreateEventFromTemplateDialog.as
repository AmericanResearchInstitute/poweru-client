package net.poweru.components.interfaces
{
	public interface ICreateEventFromTemplateDialog extends ICreateDialog
	{
		function populate(eventTemplate:Object, sessionTemplates:Array):void;
	}
}