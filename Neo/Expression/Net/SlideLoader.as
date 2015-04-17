package Neo.Expression.Net
{
	import flash.display.Loader;
	import Neo.Expression.SlideShow.*;
	
	public class SlideLoader extends Loader
	{
		private var m_Slide:Slide;
		public function get slide():Slide {return m_Slide;}
		public function set slide(value:Slide):void {m_Slide = value;}
			
		public function SlideLoader()
		{
			// Not implemented.
		}
	}
}