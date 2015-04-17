//****************************************************************************
//Copyright (C) 2008 Neo Consulting. All Rights Reserved.
//The following is Runtime Code and is subject to all restrictions on
//such code as contained in the End User License Agreement accompanying
//this product.
//****************************************************************************
/*
 * Playlist Class.
 *
 * @author Ronald Guillen.
*/
package Neo.Expression.Media
{
	public class PlayList
	{
		protected var Collection:Array;
		
		public function PlayList()
		{	
			Collection = new Array();
		}
		
		public function addMedia(name:String, path:String, type:String, loop:Number = 1)
		{
			Collection.push(new MediaObject(name, path, type, loop));
		}
		
		public function getMediaAt(index:int)
		{
			return Collection[index];
		}
		
		public function count():Number
		{
			return Collection.length;
		}
	}
}