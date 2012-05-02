package net.poweru.components.item_renderers.code
{
	import mx.containers.VBox;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.core.IFactory;
	
	public class AddressListRendererCode extends VBox
	{
		[Bindable]
		protected var addressString:String;
		
		public function AddressListRendererCode()
		{
			super();
		}
		
		override public function set data(value:Object):void
		{
			if (value != null)
			{
				var address:Object = value.address;
				addressString = address.label + '\n' + address.locality + ', ' + address.region + ' ' + address.postal_code + ' ' + address.country;
			}
			super.data = value;
		}
	}
}