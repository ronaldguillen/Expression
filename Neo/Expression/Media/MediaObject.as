package Neo.Expression.Media
{
	public class MediaObject
	{
		// @ Properties.
		private var m_Name:String;		
		public function get name():String {return m_Name;}
		public function set name(value:String):void {m_Name = value;}
		
		private var m_Path:String;		
		public function get path():String {return m_Path;}
		public function set path(value:String):void {m_Path = value;}
		
		private var m_Type:String;		
		public function get type():String {return m_Type;}
		public function set type(value:String):void {m_Type = value;}
		
		private var m_Loop:Number;		
		public function get loop():Number {return m_Loop;}
		public function set loop(value:Number):void {m_Loop = value;}
		
		public function MediaObject(name:String, path:String, type:String, loop:Number = 1)
		{
			this.m_Name = name;
			this.m_Path = path;
			this.m_Type = type;
			this.m_Loop = loop;
		}
	}
}