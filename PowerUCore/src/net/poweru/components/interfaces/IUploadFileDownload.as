package net.poweru.components.interfaces
{
	import flash.net.FileReference;

	public interface IUploadFileDownload extends ICreateDialog
	{
		function getFileDownload():FileReference;
	}
}