//****************************************************************************
//Copyright (C) 2008 Neo Consulting. All Rights Reserved.
//The following is Runtime Code and is subject to all restrictions on
//such code as contained in the End User License Agreement accompanying
//this product.
//****************************************************************************
/*
 * Expression Project Class.
 *
 * @author Ronald Guillen.
*/
package Neo.Expression.Media
{
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	
	public class SoundManager
	{
		// @ Properties.
		private var m_BufferTime:Number;		
		public function get bufferTime():Number {return m_BufferTime;}
		public function set bufferTime(value:Number):void {m_BufferTime = value;}

		private var m_SecurityPolicy:Boolean;		
		public function get securityPolicy():Boolean {return m_SecurityPolicy;}
		public function set securityPolicy(value:Boolean):void {m_SecurityPolicy = value;}
		
		private var m_Loop:Number;		
		public function get loop():Number {return m_Loop;}
		public function set loop(value:Number):void {m_Loop = value;}
		
		private var m_Volume:Number;		
		public function get volume():Number {return m_Volume;}
		public function set volume(value:Number):void
		{
			m_Volume = value;
			
			var transform:SoundTransform = new SoundTransform();
        	transform.volume = value;
        	
        	ChannelObject.soundTransform = transform;
		}
		
		// @ Internal Vars
		protected var SoundObject:Sound;
		protected var ChannelObject:SoundChannel;
		protected var SoundContext:SoundLoaderContext;
		protected var MediaList:PlayList;
		protected var Background:PlayList;
		
		private var currentPosition:Number;
		private var isPlaying:Boolean;
		private var isBackgroundPlaying:Boolean;
		
		public function SoundManager(bufferTime:Number = 1000, securityPolicy:Boolean = false, loop:Number = 1)
		{
			this.m_BufferTime = bufferTime;
			this.m_SecurityPolicy = securityPolicy;
			this.m_Loop = loop;
			this.m_Volume = 1;
			
			SoundObject = new Sound();
			ChannelObject = new SoundChannel();
			SoundContext = new SoundLoaderContext(this.m_BufferTime, this.m_SecurityPolicy);
			MediaList = new PlayList();
			Background = new PlayList();
			
			//SoundObject.addEventListener(Event.COMPLETE, handleSoundComplete);
			ChannelObject.addEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
			
			currentPosition = 0;
			isPlaying = false;
		}
		
		public function addMedia(name:String, path:String, type:String)
		{
			MediaList.addMedia(name, path, type);
		}
		
		public function addBackground(name:String, path:String, type:String, loop:Number)
		{
			Background.addMedia(name, path, type, loop);
		}
		
		public function play():void
		{
			if(!isPlaying)
			{
				var transform:SoundTransform = new SoundTransform();
            	transform.volume = this.m_Volume;

				ChannelObject = new SoundChannel();
				ChannelObject = SoundObject.play(currentPosition, this.m_Loop);
				ChannelObject.soundTransform = transform;
				isPlaying = true;
			}
		}
		
		public function playBackground():void 
		{
			var transform:SoundTransform = new SoundTransform();
             transform.volume = 0.08;
			if(!isBackgroundPlaying)
			{
				trace("into IF")
							
				var tempMedia:MediaObject = Background.getMediaAt(0) as MediaObject;
				
				ChannelObject = new SoundChannel();
				ChannelObject = SoundObject.play(currentPosition, tempMedia.loop);
				ChannelObject.soundTransform = transform;
				
				isBackgroundPlaying = true;
			}
		}
		
		public function stop():void
		{
			ChannelObject.stop();
			currentPosition = 0;
			isPlaying = false;
		}
		
		public function pause():void
		{
			currentPosition = ChannelObject.position;
			ChannelObject.stop();
			isPlaying = false;
		}
		
		public function loadMediaByName(name:String):void
		{
			// @ Stopping Audio.
			this.stop();
			
			for(var n:int = 0; n < MediaList.count(); n++)
			{
				var tempObject:MediaObject = MediaList.getMediaAt(n) as MediaObject;
				if(tempObject.name == name)
				{
					playMediaAt(n);
					break;
				}
			}
		}
		
		public function loadBackgroundSound()
		{
			if(Background.count() > 0)
			{
				var tempMedia:MediaObject = Background.getMediaAt(0) as MediaObject;
				SoundObject = new Sound();
				SoundObject.load(new URLRequest(tempMedia.path), SoundContext);
			}
		}
				
		// @ Internal Functions
		
		protected function playMediaAt(index:int)
		{
			var tempMedia:MediaObject = MediaList.getMediaAt(index) as MediaObject;
			SoundObject = new Sound();
			SoundObject.load(new URLRequest(tempMedia.path), SoundContext);
		}
		
		// @ Event Handlers
		
		protected function handleSoundComplete(event:Event)
		{
			if(Background.count() > 0)
			{
				var tempMedia:MediaObject = Background.getMediaAt(0) as MediaObject;
				SoundObject = new Sound();
				SoundObject.load(new URLRequest(tempMedia.path), SoundContext);
			}
		}
	}
}