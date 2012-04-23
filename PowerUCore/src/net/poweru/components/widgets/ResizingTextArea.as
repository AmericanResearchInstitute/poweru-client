package net.poweru.components.widgets
{
	import flash.events.Event;
	
	import mx.controls.TextArea;
	import mx.core.mx_internal;

	/*	Adapted from here: http://blog.ankur-arora.com/2010/03/resize-able-textarea-in-flex.html
		Thanks to Ankur Arora for his contribution to the Flex community.
	
		This is a drop-in replacement for TextArea that will automatically
		adjust its vertical size to fit the text.
	*/
	public class ResizingTextArea extends TextArea
	{
		public function ResizingTextArea()
		{
			super();
			addEventListener(Event.CHANGE, onChange);
		}
		
		override public function set text(value:String):void
		{
			super.text = value;
			resizeTextArea();
		}
		
		override public function set htmlText(value:String):void
		{
			super.htmlText = value;
			resizeTextArea();
		}
		
		protected function onChange(event:Event):void
		{
			resizeTextArea();
		}
		
		// resize function for the text area
		protected function resizeTextArea():void
		{
			// initial height value
			// if set to 0 scroll bars will 
			// appear to the resized text area 
			var totalHeight:uint = 10;
			// validating the object
			this.validateNow();
			// find the total number of text lines 
			// in the text area
			var noOfLines:int = this.mx_internal::getTextField().numLines;
			// iterating through all lines of 
			// text in the text area
			
			this.mx_internal::getTextField().mouseWheelEnabled = false;
			
			for (var i:int = 0; i < noOfLines; i++) 
			{
				// getting the height of one text line
				var textLineHeight:int = 
					this.mx_internal::getTextField().getLineMetrics(i).height;
				// adding the height to the total height
				totalHeight += textLineHeight;
			}
			// setting the new calculated height
			totalHeight += textLineHeight;                    
			this.height = totalHeight;
		}
	}
}