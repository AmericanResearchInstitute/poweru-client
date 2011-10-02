package net.poweru.components.item_renderers.code
{
	import mx.containers.VBox;
	import mx.controls.listClasses.IListItemRenderer;
	
	public class SessionListRendererCode extends VBox implements IListItemRenderer
	{
		public function SessionListRendererCode()
		{
			super();
		}
		
		protected function get start():Date
		{
			return data['start'] as Date;
		}
		
		protected function get end():Date
		{
			return data['end'] as Date;
		}
	}
}