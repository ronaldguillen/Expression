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

package Neo.Expression
{
	import Neo.Expression.Media.*;
	import Neo.Expression.Net.*;
	import Neo.Expression.SlideShow.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	import flash.printing.*;
	import flash.system.*;
	import flash.utils.*;
	import flash.xml.*;
	import fl.video.*;
	
	public class Expression extends Sprite
	{
		// @ Properties.
		private var m_Skin:String;		
		public function get skin():String {return m_Skin;}
		public function set skin(value:String):void {m_Skin = value;}
		
		private var m_FullScreen:Boolean;		
		public function get fullScreen():Boolean {return m_FullScreen;}
		public function set fullScreen(value:Boolean):void {m_FullScreen = value;}
		
		private var m_AutoScale:Boolean;		
		public function get autoScale():Boolean {return m_AutoScale;}
		public function set autoScale(value:Boolean):void {m_AutoScale = value;}
		
		private var m_Time:Number;		
		public function get time():Number {return m_Time;}
		public function set time(value:Number):void {m_Time = value;}
		
		private var m_DefaultGroup:String;		
		public function get defaultGroup():String {return m_DefaultGroup;}
		public function set defaultGroup(value:String):void {m_DefaultGroup = value;}
		
		private var m_Sequence:Boolean;		
		public function get useSequence():Boolean {return m_Sequence;}
		public function set useSequence(value:Boolean):void {m_Sequence = value;}
		
		private var m_SlidesCount;
		public function get slidesCount():Number {return m_SlidesCount;}
		
		// @ External Vars
		
		public var showMenu:Boolean;
		public var enableSound:Boolean;
		
		public var slideContainer:MovieClip;
		public var interfaceContainer:MovieClip;
		public var overlayContainer:MovieClip;
		
		// @ Internal vars.
		protected var BridgeConnection:LocalConnection;
		protected var ExternalConnection:LocalConnection;
		protected var CurrentPosition:Number;
		protected var CurrentLenght:Number;
		protected var CurrentGroup:SlideCollection;
		protected var CurrentInstance:DisplayObject;

		protected var SoundProvider:SoundManager;
		protected var Groups:Array;
		
		// @ Constructor.
		public function Expression()
		{
			
			// Inicializando Objetos.
			SoundProvider = new SoundManager();
			Groups = new Array();
			
			BridgeConnection = new LocalConnection();
			BridgeConnection.client = this;
			
			ExternalConnection = new LocalConnection();
			
			try
			{
				BridgeConnection.connect("ExpressionBridge");
			}
			catch(ex:ArgumentError)
			{
				trace("Can't connect...the connection is already being used.");
			}
		}
		
		public function switchSoundVolume(min:int, max:int)
		{
			if(SoundProvider.volume > 0)
			{
				SoundProvider.volume = 0;
			}
			else
			{
				SoundProvider.volume = 0.08;
			}
		}
		
		public function playSoundByName(sound:String):void 
		{
			SoundProvider.loadMediaByName(sound);
            SoundProvider.play();
        }
		
		public function playBackgroundSound()
		{
			SoundProvider.loadBackgroundSound();
			SoundProvider.playBackground();
			trace("trace background")
		}
		
		public function stopSound()
		{
			SoundProvider.stop();
		}
		
		public function addGroup(name:String, parent:String)
		{
			Groups[Groups.length] = new SlideCollection(name, parent);
		}
		
		public function addSlide(name:String, group:String, contentPath:String, level:Number = 2, parameters:Array = null)
		{
			var groupObj= FindGroupByName(group);
			groupObj.AddSlide(new Slide(name, group, contentPath, level, parameters));
		}
		
		public function addMedia(name:String, path:String, type:String)
		{
			SoundProvider.addMedia(name, path, type);
		}
		
		public function addBackground(name:String, path:String, type:String, loop:Number)
		{
			SoundProvider.addBackground(name, path, type, loop);
		}
		
		public function start(mode:String = SlideShow.MANUAL_MODE)
		{
			switch(mode)
			{
				case SlideShow.AUTOMATIC_MODE:
						//startAutomaticMode();
					break;
				case SlideShow.MANUAL_MODE:
						startManualMode();
					break;
			}
			
			// @ Estableciendo opciones del proyector.
			if(this.m_FullScreen)
			{
				fscommand("fullscreen","true");
			}
			else
			{
				fscommand("fullscreen","false");
			}
			
			if(this.m_AutoScale)
			{
				fscommand("allowscale","true");
			}
			else
			{
				fscommand("allowscale","false");
			}
			
			this.enableSound = true;
		}
		
		public function LoadGroupByName(name:String)
		{
			var groupObj:SlideCollection = FindGroupByName(name);
			for(var n = 0; n < groupObj.Count(); n++)
			{
				var slideObj:Slide = groupObj.GetSlideAt(n)
				var slideLoader:SlideLoader = new SlideLoader();
				
				slideLoader.slide = slideObj;
				slideLoader.load(new URLRequest(slideObj.contentPath));
				slideLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleSlideLoad);
			}
		}
		
		public function LoadSlideByIndex(index:Number)
		{
			var slideObj:Slide = CurrentGroup.GetSlideAt(index);
			var slideLoader:SlideLoader = new SlideLoader();
			var slideParams:Array = slideObj.parameters as Array;
			
			slideLoader.slide = slideObj;
			slideLoader.load(new URLRequest(slideObj.contentPath));
			slideLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleSlideLoad);
		}
		
		public function LoadSlideByReference(object:Slide)
		{
			var slideObj:Slide = object;
			var slideLoader:SlideLoader = new SlideLoader();

			slideLoader.slide = slideObj;
			slideLoader.load(new URLRequest(slideObj.contentPath));
			slideLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleSlideLoad);
		}
		
		public function LoadSlideInOverlay(name:String)
		{
			var slideObject:Slide = GetSlideByName(name);
			
			var slideLoader:SlideLoader = new SlideLoader();

			slideLoader.slide = slideObject;
			slideLoader.load(new URLRequest(slideObject.contentPath));
			slideLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleOverlayLoad);
		}
		
		public function LoadSlideInSequence(name:String)
		{
			var tempGroup:SlideCollection = null;
			var tempSlide:Slide = null;
			
			for(var n = 0; n < Groups.length; n++)
			{
				tempGroup = Groups[n] as SlideCollection; 
				for(var m = 0; m < tempGroup.Count(); m++)
				{
					tempSlide = tempGroup.GetSlideAt(m) as Slide;
					if(tempSlide.name == name)
					{
						CurrentGroup = tempGroup;
						CurrentLenght =  tempGroup.Count();
						CurrentPosition = m;
						LoadSlideByIndex(CurrentPosition);
						
						break;
					}
				}
			}
		}
		
		public function LoadSlideWithoutSequence(name:String)
		{
			var tempGroup:SlideCollection = null;
			var tempSlide:Slide = null;
			
			for(var n = 0; n < Groups.length; n++)
			{
				tempGroup = Groups[n] as SlideCollection; 
				for(var m = 0; m < tempGroup.Count(); m++)
				{
					tempSlide = tempGroup.GetSlideAt(m) as Slide;
					if(tempSlide.name == name)
					{
						LoadSlideByReference(tempSlide);
						break;
					}
				}
			}
		}
		
		public function GetSequenceLength():Number
		{
			var sequenceLength:Number = 0;
			
			for(var n = 0; n < Groups.length; n++)
			{
				var tempGroup:SlideCollection = Groups[n] as SlideCollection;
				if(tempGroup.name != "Interface" && tempGroup.name != "Others")
				{
					sequenceLength += tempGroup.Count();
				}
			}
			
			return sequenceLength;
		}
		
		public function GetSequencePosition():Number
		{
			var sequencePosition:Number = 0;
			
			for(var n = 0; n < GetGroupIndex(CurrentGroup); n++)
			{
				var tempGroup:SlideCollection = Groups[n] as SlideCollection;
				if(tempGroup.name != "Interface" && tempGroup.name != "Others")
				{
					sequencePosition += tempGroup.Count();
				}
			}
			
			sequencePosition += CurrentPosition;
			return sequencePosition;
		}
		
		public function ReloadCurrentSlide()
		{
			LoadSlideByIndex(CurrentPosition);
		}
		
		// @ Helper Fuctions.
		
		protected function ProcessParameters(params:Array)
		{
			if(params != null)
			{
				if(params[0])
				{
					showMenu = false;
				}	
			}
			else
			{
				showMenu = true;	
			}
		}
		
		protected function startManualMode()
		{
			var defaultGroup:SlideCollection = FindGroupByName("Default");
			
			if(defaultGroup != null)
			{
				CurrentLenght = defaultGroup.Count();
				CurrentGroup = defaultGroup;
				CurrentPosition = 0;
				
				LoadSlideByIndex(CurrentPosition);
			}
			else if(this.m_DefaultGroup != null)
			{
				defaultGroup = FindGroupByName(this.m_DefaultGroup);
				CurrentLenght = defaultGroup.Count();
				CurrentGroup = defaultGroup;
				CurrentPosition = 0;
				
				LoadSlideByIndex(CurrentPosition);
			}
		}
		
		protected function startAutomaticMode()
		{
			// Not implemented.
		}
		
		protected function handleSlideLoad(event:Event)
		{
			var loaderContext:SlideLoader = event.currentTarget.loader as SlideLoader;
			var slideObj:Slide = loaderContext.slide as Slide;
			
			if(slideObj.group == "Interface")
			{
				this.interfaceContainer.addChild(event.currentTarget.content);
			}
			else
			{
				if(CurrentInstance != null)
				{
					var tempChild:DisplayObjectContainer = CurrentInstance as DisplayObjectContainer;
					for(var n:int = 0; n < tempChild.numChildren; n++)
					{
						if(getQualifiedClassName(tempChild.getChildAt(n)) == "fl.video::FLVPlayback")
						{
							var tempObject:FLVPlayback = tempChild.getChildAt(n) as FLVPlayback;
							if(tempObject.playing){ tempObject.stop(); };
						}
					}
					this.slideContainer.removeChild(CurrentInstance);
				}
				
				CurrentInstance = this.slideContainer.addChild(event.currentTarget.content)
			}
			
			//ExternalConnection.send("ExpressionExternal", "handleProgressEvent",this.GetSequencePosition(), this.GetSequenceLength());
		}
		
		protected function handleOverlayLoad(event:Event)
		{
			var loaderContext:SlideLoader = event.currentTarget.loader as SlideLoader;
			var slideObj:Slide = loaderContext.slide as Slide;
			
			for(var n:int = 0; n < this.overlayContainer.numChildren; n++)
			{
				this.overlayContainer.removeChildAt(n);
			}
			
			this.overlayContainer.addChild(event.currentTarget.content);
		}
		
		protected function FindGroupByName(name:String):SlideCollection
		{
			var groupObj = null;
			
			for(var n = 0; n < Groups.length; n++)
			{
				if(Groups[n].name == name)
				{
					groupObj = Groups[n];
					break;
				}
			}
			
			return groupObj;
		}
		
		protected function FindGroupByIndex(index:Number):SlideCollection
		{
			var groupObj = null
			
			if(Groups[index] != null)
			{
				groupObj = Groups[index];
			}
			
			return groupObj;
		}
		
		protected function GetGroupIndex(group:SlideCollection)
		{
			var index = null;
			
			for(var n = 0; n < Groups.length; n++)
			{
				if(Groups[n].name == group.name)
				{
					index = n;
					break;
				}
			}
			
			return index;
		}
		
		protected function GetSlideByName(name:String)
		{
			var tempGroup:SlideCollection = null;
			var tempSlide:Slide = null;
			
			for(var n = 0; n < Groups.length; n++)
			{
				tempGroup = Groups[n] as SlideCollection; 
				for(var m = 0; m < tempGroup.Count(); m++)
				{
					tempSlide = tempGroup.GetSlideAt(m) as Slide;
					if(tempSlide.name == name)
					{
						return tempSlide;
					}
				}
			}
			
			return tempSlide;
		}
		
		protected function LoadNextSlide()
		{
			if(this.m_Sequence)
			{
				if(CurrentPosition < (CurrentLenght - 1))
				{
					CurrentPosition += 1;
					LoadSlideByIndex(CurrentPosition);
				}
				else
				{
					var nextIndex = GetGroupIndex(CurrentGroup) + 1;
					
					if(Groups[nextIndex] != null)
					{
						if(Groups[nextIndex].name != "Others")
						{
							CurrentGroup = Groups[nextIndex];
							CurrentLenght = CurrentGroup.Count();
							CurrentPosition = 0;
							LoadSlideByIndex(CurrentPosition);
						}
					}
				}
			}
			else
			{
				if(CurrentPosition < (CurrentLenght - 1))
				{
					CurrentPosition += 1;
					LoadSlideByIndex(CurrentPosition);
				}
			}
		}
		
		protected function LoadPrevSlide()
		{
			if(this.m_Sequence)
			{
				if(CurrentPosition > 0)
				{
					CurrentPosition -= 1;
					LoadSlideByIndex(CurrentPosition);
				}
				else
				{
					var prevIndex = GetGroupIndex(CurrentGroup) - 1;
			
					if(Groups[prevIndex] != null)
					{
						if(Groups[prevIndex].name != "Interface")
						{
							CurrentGroup = Groups[prevIndex];
							CurrentLenght = CurrentGroup.Count();
							CurrentPosition = (CurrentLenght - 1);
							LoadSlideByIndex(CurrentPosition);
						}
					}
				}
			}
			else
			{
				if(CurrentPosition > 0)
				{
					CurrentPosition -= 1;
					LoadSlideByIndex(CurrentPosition);
				}
			}
		}
		
		// @ Delegates
		public function NextSlide()
		{
			SoundProvider.stop();
			LoadNextSlide();
		}
		
		public function PrevSlide()
		{
			SoundProvider.stop();
			LoadPrevSlide();
		}		
	}
}