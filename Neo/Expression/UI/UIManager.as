//****************************************************************************
//Copyright (C) 2008 Neo Consulting. All Rights Reserved.
//The following is Sample Code and is subject to all restrictions on
//such code as contained in the End User License Agreement accompanying
//this product.
//****************************************************************************
/*
 * Expression UIManager Class.
 *
 * @author Ronald Guillen.
*/

package Neo.Expression.UI
{
	import Neo.Expression.*;
	import Neo.Expression.UI.Controls.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.xml.*;
	
	public class UIManager
	{
		// @ Constants.
		public const NEXT_BUTTON = "btnNext";
		public const PREV_BUTTON = "btnPrev";
		public const BACKGROUND = "mcBackground";
		
		// @ Properties.
		private var m_SkinURL:String;		
		public function get skinURL():String {return m_SkinURL;}
		public function set skinURL(value:String):void {m_SkinURL = value;}
		
		// @ Internal vars
		private var skinLoader:Loader;
		private var skinContent:Sprite
		private var skinTemplate:Sprite;
		private var mainSprite:Sprite;
		
		// @ Constructor
		public function UIManager(skinURL:String = null)
		{
			this.m_SkinURL = skinURL;
		}
		
		// @ Methods
		public function ApplySkin(mainObj:Sprite)
		{
			mainSprite = mainObj;
			downloadSkin();
		}
		
		// @ Helper Functions
		private function downloadSkin()
		{
			skinLoader = new Loader();
			skinLoader.load(new URLRequest(this.m_SkinURL));
			skinLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleSkinLoad);
		}
		
		private function handleSkinLoad(e:Event)
		{
			skinTemplate = Sprite(skinLoader.content);
			skinContent = skinTemplate;
			
			// Settings.
			ApplyObjectsSkin();
		}
		
		private function ApplyObjectsSkin()
		{
			// @Background Skin
			var backgroundSkin:MovieClip = skinContent.getChildByName("background_mc") as MovieClip;
			setBackgroundSkin(backgroundSkin, BACKGROUND);
			
			// @ Next Button Skin
			var nextButtonSkin:MovieClip = skinContent.getChildByName("next_button_mc") as MovieClip;
			setButtonSkin(nextButtonSkin, NEXT_BUTTON);
			var nextButton:Button = mainSprite.getChildByName(NEXT_BUTTON) as Button;
			nextButton.delegate = "NextSlide";
			
			// @ Prev Button skin
			var prevButtonSkin:MovieClip = skinContent.getChildByName("prev_button_mc") as MovieClip;
			setButtonSkin(prevButtonSkin, PREV_BUTTON);
			var prevButton:Button = mainSprite.getChildByName(PREV_BUTTON) as Button;
			prevButton.delegate = "PrevSlide";
		}
		
		private function setBackgroundSkin(skin:MovieClip, target:String)
		{
			var backgroundLayout:MovieClip = mainSprite.getChildByName(target) as MovieClip;
			backgroundLayout.addChild(skin);
		}
		
		private function setButtonSkin(skin:MovieClip, target:String)
		{
			var buttonLayout:Button = mainSprite.getChildByName(target) as Button;
			
			// @ Button.NORMAL_STATE
			var mcNormal:MovieClip = buttonLayout.getChildByName("mcNormal") as MovieClip;
			var doNormalSkin:DisplayObject = skin.getChildByName("normal_state");
			doNormalSkin.x = 0;doNormalSkin.y = 0;
			mcNormal.addChild(doNormalSkin);
			
			// @ Button.ROLLOVER_STATE
			var mcRollOver:MovieClip = buttonLayout.getChildByName("mcRollOver") as MovieClip;
			var doRollOverSkin:DisplayObject = skin.getChildByName("rollover_state");
			doRollOverSkin.x = 0;doRollOverSkin.y = 0;
			mcRollOver.addChild(doRollOverSkin);
			
			// @ Button.ACTIVE_STATE
			var mcActive:MovieClip = buttonLayout.getChildByName("mcActive") as MovieClip;
			var doActiveSkin:DisplayObject = skin.getChildByName("active_state");
			doActiveSkin.x = 0;doActiveSkin.y = 0;
			mcActive.addChild(doActiveSkin);
			
			// @ Button Controller;
			buttonLayout.controller = (Expression(this.mainSprite));
		}
	}
}