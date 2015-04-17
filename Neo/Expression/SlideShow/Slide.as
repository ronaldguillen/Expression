//****************************************************************************
//Copyright (C) 2008 Neo Consulting. All Rights Reserved.
//The following is Sample Code and is subject to all restrictions on
//such code as contained in the End User License Agreement accompanying
//this product.
//****************************************************************************
/*
 * Expression Slide Class.
 *
 * @author Ronald Guillen.
*/

package Neo.Expression.SlideShow
{	
	public class Slide
	{
		// @ Properties.
		private var m_Name:String;		
		public function get name():String {return m_Name;}
		public function set name(value:String):void {m_Name = value;}
		
		private var m_Group:String;		
		public function get group():String {return m_Group;}
		public function set group(value:String):void {m_Group = value;}
		
		private var m_ContentPath:String;		
		public function get contentPath():String {return m_ContentPath;}
		public function set contentPath(value:String):void {m_ContentPath = value;}
		
		private var m_Level:Number;		
		public function get level():Number {return m_Level;}
		public function set level(value:Number):void {m_Level = value;}
		
		private var m_Parameters:Array;		
		public function get parameters():Array {return m_Parameters;}
		public function set parameters(value:Array):void {m_Parameters = value;}
		
		// @ Constructor.
		public function Slide(name:String, group:String, contentPath:String, level:Number, parameters:Array = null)
		{
			this.m_Name = name;
			this.m_Group = group;
			this.m_ContentPath = contentPath;
			this.m_Level = level;
			this.m_Parameters = parameters;
		}
	}
}