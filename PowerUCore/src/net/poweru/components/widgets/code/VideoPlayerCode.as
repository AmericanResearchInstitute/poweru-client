package net.poweru.components.widgets.code
{
	import net.poweru.components.akamai.ControlBar;
	import net.poweru.components.dialogs.VideoDialog;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Quadratic;
	
	import flash.display.BitmapData;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.SharedObject;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.Timer;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	import org.openvideoplayer.components.ui.controlbar.view.DualTimeCodeDisplay;
	import org.openvideoplayer.components.ui.controlbar.view.FullscreenButton;
	import org.openvideoplayer.components.ui.controlbar.view.PlayPauseButton;
	import org.openvideoplayer.components.ui.controlbar.view.ScrubBar;
	import org.openvideoplayer.components.ui.controlbar.view.VolumeControl;
	import org.openvideoplayer.components.ui.debug.DebugPanelView;
	import org.openvideoplayer.components.ui.posterframe.PosterFramePlayButton;
	import org.openvideoplayer.components.ui.shared.event.ControlEvent;
	import org.openvideoplayer.components.ui.spinner.SpinnerView;
	import org.openvideoplayer.events.OvpEvent;
	import org.openvideoplayer.net.OvpConnection;
	import org.openvideoplayer.net.OvpDynamicNetStream;
	import org.openvideoplayer.net.OvpNetStream;
	import org.openvideoplayer.net.dynamicstream.DynamicStreamItem;

	public class VideoPlayerCode extends VBox
	{
		public var videoComponent:UIComponent;
		public var controlBox:HBox;
		public var controlComponent:UIComponent;
		public var controlBar:ControlBar;
		
		public var videoDialog:VideoDialog;
		protected var video:Video;
		protected var volumeControl:VolumeControl;
		protected var playPauseButton:PlayPauseButton;
		protected var dualTimeCodeDisplay:DualTimeCodeDisplay;
		protected var scrubBar:ScrubBar;
		protected var spinnerView:SpinnerView;
		protected var debugPanel:DebugPanelView;
		protected var fullscreenButton:FullscreenButton;
		protected var posterFrameButton:PosterFramePlayButton;
		
		protected var stream:OvpNetStream;
		protected var dsi:DynamicStreamItem;
		protected var url:String;
		protected var scrubTimer:Timer;
		protected var streamLength:Number = 0;
		protected var streamLengthString:String;
		protected var volumeSharedObject:SharedObject;
		
		public function VideoPlayerCode()
		{
			super();
			volumeSharedObject = SharedObject.getLocal('PowerUVolume');
			scrubTimer = new Timer(10);
			scrubTimer.addEventListener(TimerEvent.TIMER, onTick);
		}
		
		public function loadURL(connection:OvpConnection, url:String):void
		{
			unload();
			this.url = url;
			stream = new OvpNetStream(connection);
			stream.checkPolicyFile = true;
			stream.addEventListener(OvpEvent.PROGRESS, onProgress);
			loadCommon();
		}
		
		public function loadDSI(connection:OvpConnection, dsi:DynamicStreamItem):void
		{
			unload();
			this.dsi = dsi;
			stream = new OvpDynamicNetStream(connection.netConnection);
			(stream as OvpDynamicNetStream).autoRateLimits = false;
			(stream as OvpDynamicNetStream).rateLimits = 800;
			stream.addEventListener(OvpEvent.DEBUG, onDebug);
			
			// request stream length
			connection.addEventListener(OvpEvent.STREAM_LENGTH, onStreamLength);
			connection.requestStreamLength(dsi.getNameAt(0));
			
			loadCommon();
		}
		
		protected function onDebug(event:OvpEvent):void
		{
			debugPanel.log('debug: ' + event.data);
		}
			
		protected function loadCommon():void
		{
			stream.addEventListener(OvpEvent.COMPLETE, onPlayComplete);
			stream.addEventListener(OvpEvent.METADATA, onMetaData);
			stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			
			video.attachNetStream(stream);
			controlBox.enabled = true;
			if (volumeSharedObject.data.volume)
				stream.volume = volumeSharedObject.data.volume;
			volumeControl.setThumbPosition(stream.volume, 1);
			posterFrameButton.visible = true;
		}
		
		public function unload():void
		{
			scrubBar.setThumbPosition(0, streamLength);
			controlBox.enabled = false;
			if (scrubTimer)
				scrubTimer.stop();
			if (stream)
			{
				stream.removeEventListener(OvpEvent.PROGRESS, onProgress);
				stream.removeEventListener(OvpEvent.COMPLETE, onPlayComplete);
				stream.removeEventListener(OvpEvent.METADATA, onMetaData);
				stream.removeEventListener(OvpEvent.DEBUG, onDebug);
				stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				stream.close();
			}
			stream = null;
			dsi = null;
			streamLength = 0;
			streamLengthString = '';
			playPauseButton.currentState = ControlEvent.PAUSE;
			clearTimeDisplay();
			video.attachNetStream(null);
			video.clear();
			posterFrameButton.visible = false;
		}
		
		protected function clearTimeDisplay():void
		{
			dualTimeCodeDisplay.setTimeCodeText('', '');
		}
		
		protected function setTimeDisplay():void
		{
			// this is only true when playing a file NOT through FMS
			if (stream && (streamLength == 0))
				streamLength = stream.streamLength;
			if (dualTimeCodeDisplay)
				dualTimeCodeDisplay.setTimeCodeText(convertToTimeCode(scrubBar.getThumbPosition(streamLength)), convertToTimeCode(streamLength));
		}
		
		protected function setStatsPanel():void
        {
            var maxBandwidth:Number = Math.round(stream.info.maxBytesPerSecond * 8 / 1024);       
            debugPanel.bandwidthPanel.text = maxBandwidth == 0 ? "Calculating" : isNaN(maxBandwidth) ? "Unavaliable" : maxBandwidth +" kbps";
            debugPanel.streamPanel.text = Math.round(stream.info.playbackBytesPerSecond * 8 / 1024) +" kbps";
            debugPanel.bufferPanel.text = Math.round(stream.bufferLength) + " sec";
        }
		
		protected function addControlEventListeners():void
		{
			controlBar.addEventListener(ControlEvent.FULLSCREEN, onClickFullscreen);
			controlBar.addEventListener(ControlEvent.PLAY, onPlay);
			controlBar.addEventListener(ControlEvent.PAUSE, onPause);
			controlBar.addEventListener(ControlEvent.SEEK_BEGIN, onSeekBegin);
			controlBar.addEventListener(ControlEvent.SEEK_COMPLETE, onSeekComplete);
			controlBar.addEventListener(ControlEvent.VOLUME_CHANGE, onVolumeChange);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullscreen);
			posterFrameButton.addEventListener(ControlEvent.PLAY, onPlay);
		}
		
		public function grabScreenImage():BitmapData
		{
			var screenCapture:BitmapData = new BitmapData(videoComponent.width, videoComponent.height, false);
			screenCapture.draw(videoComponent);
			return screenCapture;
		}
		
		protected function onAddedToStage(event:Event):void
		{
			if (spinnerView)
				videoComponent.removeChild(spinnerView);
			addSpinner();
		}
		
		// Create the spinner and add it to the video component
		protected function addSpinner():void
		{
			spinnerView = new SpinnerView();
			spinnerView.visible = false;
			spinnerView.x = video.width / 2;
			spinnerView.y = video.height / 2;
			videoComponent.addChild(spinnerView);
		}
		
		protected function onCreationComplete(event:Event):void
		{
			video = new Video(640, 360);
			videoComponent.addChild(video);
			
			addSpinner();
			// necessary because the spinner commits suicide when it is removed
			// from the stage.  See Spinner.destroy()
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			debugPanel = new DebugPanelView(video.width, video.height);
			debugPanel.visible = false;
			videoComponent.addChild(debugPanel);
			
			var item:ContextMenuItem = new ContextMenuItem("Toggle Debug Panel", true);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onToggleDebugConsole);
			controlComponent.contextMenu = new ContextMenu();   
            controlComponent.contextMenu.hideBuiltInItems();
            controlComponent.contextMenu.customItems.push(item);
			
			controlBar = new ControlBar();
			controlBar.width = video.width;
			controlBar.height = 30;
			controlBar.alpha = 1;
			
			scrubBar = new ScrubBar();
			dualTimeCodeDisplay = new DualTimeCodeDisplay();
			playPauseButton = new PlayPauseButton();
			volumeControl = new VolumeControl();
			fullscreenButton = new FullscreenButton();
			fullscreenButton.currentState = ControlEvent.NORMALSCREEN;
			controlBar.addControls([playPauseButton, scrubBar, dualTimeCodeDisplay, volumeControl, fullscreenButton]);
			controlComponent.addChild(controlBar);
			
			posterFrameButton = new PosterFramePlayButton(video.width, video.height, 100);
			posterFrameButton.visible = false;
			videoComponent.addChild(posterFrameButton);
			posterFrameButton.x = video.width / 2;
			posterFrameButton.y = video.height / 2;
			
			addControlEventListeners();
		}
		
		// isolate the video display and have it scale
		protected function onClickFullscreen(event:ControlEvent):void
		{
			if (stage.displayState == StageDisplayState.NORMAL && stage.fullScreenSourceRect == null && (stream as OvpDynamicNetStream != null))
			{
				(stream as OvpDynamicNetStream).autoRateLimits = true;
				videoComponent.removeChild(video);
				video.height = 720;
				video.width = 1280;
				videoDialog.videoComponent.addChild(video);
				
				PopUpManager.addPopUp(videoDialog, this);
				PopUpManager.centerPopUp(videoDialog);
				var point:Point = new Point(video.x, video.y);
				var rect:Rectangle = new Rectangle(localToGlobal(point).x, localToGlobal(point).y, video.width, video.height);
				stage.fullScreenSourceRect = rect;
			
				stage.scaleMode = StageScaleMode.EXACT_FIT;
				stage.displayState = (stage.displayState == StageDisplayState.NORMAL) ? StageDisplayState.FULL_SCREEN : StageDisplayState.NORMAL;
			}
		}
		
		// Clean up the button state and the stage scaling.
		protected function onFullscreen(event:FullScreenEvent):void
		{
			if (!event.fullScreen)
			{
				fullscreenButton.currentState = ControlEvent.NORMALSCREEN;
				stage.scaleMode = StageScaleMode.NO_SCALE;
				videoDialog.videoComponent.removeChild(video);
				video.height = 360;
				video.width = 640;
				videoComponent.addChild(video);
				PopUpManager.removePopUp(videoDialog);
				stage.fullScreenSourceRect = null;
				
				(stream as OvpDynamicNetStream).autoRateLimits = false;
			}
		}
		
		protected function onToggleDebugConsole(event:ContextMenuEvent):void
        {
            debugPanel.visible = !debugPanel.visible;
        }
		
		protected function onNetStatus(event:NetStatusEvent):void
		{
			switch (event.info.code) 
			{			
				case "NetStream.Buffer.Full" :
					onBufferFull();
					break;				
				case "NetStream.Play.Start" :
					if(playPauseButton.currentState == ControlEvent.PLAY)
						onBufferStart();
					break;
			}
		}
		
		protected function onMetaData(event:OvpEvent):void
		{
			debugPanel.log("");
			debugPanel.log("BEGIN METADATA");
			for (var key:String in event.data)
				debugPanel.log("metadata: " + key + " = " + event.data[key]);
		}
		
		protected function onBufferStart():void
        {   
        	if (spinnerView)
	            with(spinnerView)
	            {
	                alpha = scaleX = scaleY = 1;
	                visible = true;
	                textfield.text = "Buffering"
	            }
        }
       
        protected function onBufferFull():void
        {
        	if (spinnerView)
        	{
        		var scaleValue:Number = 1.3;
	            var tween:GTween = new GTween(spinnerView, .5);           
	            tween.setValues({ alpha:0, scaleX:scaleValue, scaleY:scaleValue});
	            tween.ease = Quadratic.easeOut;
	            tween.onComplete = onSpinnerFadeOut;           
	            spinnerView.textfield.text = "";
        	}
        }
        
        protected function onSpinnerFadeOut(tween:GTween):void
        {
        	tween.target.visible = false;
        }
		
		protected function onPlayComplete(event:OvpEvent):void
		{
			scrubTimer.stop();
			stream.seek(0);
			if (stream.isProgressive)
				stream.pause();
			else
				stream.close();
			playPauseButton.currentState = ControlEvent.PAUSE;
			setTimeDisplay();
			scrubBar.setThumbPosition(0, streamLength);
		}
		
		protected function onVolumeChange(event:ControlEvent):void
		{
			stream.volume = event.data.value;
			volumeSharedObject.data.volume = event.data.value;
		}
		
		protected function onStreamLength(event:OvpEvent):void
		{
			streamLength = event.data.streamLength;
			streamLengthString = convertToTimeCode(streamLength);
			setTimeDisplay();
			event.target.removeEventListener(OvpEvent.STREAM_LENGTH, onStreamLength);
		}
		
		protected function onSeekBegin(event:ControlEvent):void
		{
			scrubTimer.stop();
			if (playPauseButton.currentState == ControlEvent.PLAY)
				stream.pause();
		}
		
		protected function onSeekComplete(event:ControlEvent):void
		{
			if (stream.time == 0)
			{
				stream.play((dsi) ? dsi : url);
				stream.pause();
			}
			setTimeDisplay();
			var thumbPosition:Number = scrubBar.getThumbPosition(streamLength);
			// let's onPlay() assume that if stream.time == 0, the DSI needs to be loaded.
			if (thumbPosition == 0)
				thumbPosition = 0.001;
			stream.seek(thumbPosition);
			if (playPauseButton.currentState == ControlEvent.PLAY)
			{
				scrubTimer.start();
				stream.resume();	
			}
		}
		
		protected function onTick(event:TimerEvent):void
		{
			if (scrubBar && stream)
			{
				scrubBar.setThumbPosition(stream.time, streamLength);
				setTimeDisplay();
				setStatsPanel();
			}
		}
		
		protected function onProgress(event:OvpEvent):void
		{
			if (scrubBar)
				scrubBar.setProgressiveProgressBar(stream.bytesLoaded, stream.bytesTotal);
		}
		
		protected function onPlay(event:ControlEvent):void
		{
			posterFrameButton.visible = false;
			
			if (stream.time == 0)
			{
				stream.play((dsi) ? dsi : url);
				playPauseButton.currentState = ControlEvent.PLAY;
			}
			else
				stream.togglePause();
			scrubTimer.start();
		}
		
		protected function onPause(event:ControlEvent):void
		{
			stream.pause();
			scrubTimer.stop();
		}
		
		protected static function convertToTimeCode(sec:Number):String
        {
            var h:Number = Math.floor(sec/3600);
            var m:Number = Math.floor((sec%3600)/60);
            var s:Number = Math.floor((sec%3600)%60);
            return (h == 0 ? "":(h<10 ? "0"+h.toString()+":" : h.toString()+":"))+(m<10 ? "0"+m.toString() : m.toString())+":"+(s<10 ? "0"+s.toString() : s.toString());
        }
		
	}
}