//****************************************************************************
//Copyright (C) 2008 Neo Consulting. All Rights Reserved.
//The following is Sample Code and is subject to all restrictions on
//such code as contained in the End User License Agreement accompanying
//this product.
//****************************************************************************
/*
 * Expression NextButton Class.
 *
 * @author Ronald Guillen.
*/

package Neo.Expression.UI.Controls
{
	import flash.display.*;
	import flash.events.*;
	
	import Neo.Expression.Expression;
		
	public class NextButton extends Button
	{
		// @ Constructor.
		public function NextButton()
		{
			mcRollOver.visible = false;
			mcActive.visible = false;
			
			btnShape.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			btnShape.addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
			btnShape.addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
			btnShape.addEventListener(MouseEvent.MOUSE_UP, handleMouseOut);
		}
		
		// @ Event Listeners
		private function handleMouseDown(event:MouseEvent)
		{
			// @ Skin
			mcNormal.visible = false;
			mcRollOver.visible = false;
			mcActive.visible = true;
			
			// @ Delegate
			controller[this.delegate]();
		}
		
		private function handleMouseOver(event:MouseEvent)
		{
			// @ Skin
			mcNormal.visible = false;
			mcActive.visible = false;
			mcRollOver.visible = true;
		}
		
		private function handleMouseOut(event:MouseEvent)
		{
			// @Skin
			mcRollOver.visible = false;
			mcActive.visible = false;
			mcNormal.visible = true;
		}	
	}
}