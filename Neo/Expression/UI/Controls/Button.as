//****************************************************************************
//Copyright (C) 2008 Neo Consulting. All Rights Reserved.
//The following is Sample Code and is subject to all restrictions on
//such code as contained in the End User License Agreement accompanying
//this product.
//****************************************************************************
/*
 * Expression Button Class.
 *
 * @author Ronald Guillen.
*/

package Neo.Expression.UI.Controls
{
	import flash.display.*;
	import flash.events.*;
	
	import Neo.Expression.Expression;
		
	public class Button extends MovieClip
	{
		// @ Constants.
		public const BUTTON_NORMAL = "normal";
		public const BUTTON_ROLLOVER = "rollover";
		public const BUTTON_ACTIVE = "active";
		
		// @ Properties.
		private var m_SkinObject:Sprite;		
		public function get SkinObject():Sprite {return m_SkinObject;}
		public function set SkinObject(value:Sprite):void {m_SkinObject = value;}
		
		private var m_Controller:Expression;		
		public function get controller():Expression {return m_Controller;}
		public function set controller(value:Expression):void {m_Controller = value;}
		
		private var m_Delegate:String;		
		public function get delegate():String {return m_Delegate;}
		public function set delegate(value:String):void {m_Delegate = value;}
		
		public function Button()
		{
			// Not Implemented
		}	
	}
}