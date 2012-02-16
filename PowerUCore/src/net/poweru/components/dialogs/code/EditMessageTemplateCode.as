package net.poweru.components.dialogs.code
{
	import mx.controls.TextArea;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	
	public class EditMessageTemplateCode extends BaseCRUDDialog implements IEditDialog
	{
		public var subjectInput:TextArea;
		public var bodyInput:TextArea;
		
		[Bindable] protected var template:Object;
		
		public function EditMessageTemplateCode()
		{
			super();
			validators = [];
		}
		
		public function clear():void
		{
			populate({})
		}
		
		public function populate(data:Object, ...args):void
		{
			template = data;
			subjectInput.text = data.subject;
			bodyInput.text = data.body;
		}
		
		override public function getData():Object
		{
			return {
				'id' : template.id,
				'message_type' : template.message_type,
				'message_format' : template.message_format,
				'subject' : subjectInput.text,
				'body' : bodyInput.text
			}
		}
	}
}