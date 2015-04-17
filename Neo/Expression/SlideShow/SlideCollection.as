//****************************************************************************
//Copyright (C) 2008 Neo Consulting. All Rights Reserved.
//The following is Sample Code and is subject to all restrictions on
//such code as contained in the End User License Agreement accompanying
//this product.
//****************************************************************************
/*
 * Expression SlideCollection Class.
 *
 * @author Ronald Guillen.
*/

package Neo.Expression.SlideShow
{
	public class SlideCollection
	{
		// @ Properties
		private var m_Slides:Array;
		public function get slides():Array {return m_Slides;}
		
		private var m_Name:String;		
		public function get name():String {return m_Name;}
		public function set name(value:String):void {m_Name = value;}
		
		private var m_Parent:String;		
		public function get parent():String {return m_Parent;}
		public function set parent(value:String):void {m_Parent = value;}
		
		public function SlideCollection(name:String, parent:String)
		{
			this.m_Name = name;
			this.m_Parent = parent;
			this.m_Slides = new Array();
		}
		
		// @ Methods
		public function AddSlide(slideObj:Slide)
		{
			m_Slides[m_Slides.length] = slideObj;
		}
		
		public function RemoveSlide(slideName:String)
		{
			//m_Slides[m_Slides] = null;
		}
		
		public function Count()
		{
			return this.m_Slides.length;
		}
		
		public function GetSlideAt(index:Number)
		{
			return this.m_Slides[index];
		}
	}
}