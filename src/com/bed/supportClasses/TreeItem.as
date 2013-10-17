package com.bed.supportClasses
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class TreeItem extends EventDispatcher
	{
		public var name:String;
		public var parent:TreeItem;
		public var rank:int;
		public var visible:Boolean;
		
		public override function toString():String
		{
			return name;
		}
		
		public var data:Object;
		
		public var isOpen:Boolean = false;
		
		public function get isParent():Boolean
		{
			if (_children != null && _children.length > 0)
				return true;
			else
				return false;
		}
		
		private var _children:Array;
		
		[Bindable(event="child_added")]
		public function addChild(child:TreeItem):void
		{
			if (_children == null)
				_children = new Array();
			
			child.parent = this;
			child.rank = this.rank + 1;
			_children.push(child);
			dispatchEvent(new Event("child_added"));
		}
		
		public function getChildIndex(name:String):int
		{
			if (_children != null)
			{
				for (var i:int = 0; i < _children.length;i++)
				{
					var child:TreeItem = _children[i];
					if (child.name == name)
						return i;
				}
			}
			
			return -1;
		}
		
		public function getChild(name:String):TreeItem
		{
			var index:int = getChildIndex(name)
			if (index == -1)
				return null
			else
				return _children[index];
		}
		
		public function getChildren(parentsOnTop:Boolean = true):Array
		{
			if (parentsOnTop)
			{
				var parents:Array = new Array();
				var others:Array = new Array();
				for each (var child:TreeItem in _children)
				{
					if (child.isParent)
						parents.push(child);
					else
						others.push(child);
				}
				
				parents.sort(Array.DESCENDING);
				others.sort(Array.DESCENDING);
				
				return others.concat(parents);
			}
			else
			{
				_children.sort(Array.DESCENDING);
				trace(_children);
				return _children;
			}
		}
		
		public function TreeItem(name:String, data:Object = null)
		{
			this.name = name;
			this.data = data;
			this.parent = null;
			this.rank = 0;
			this.visible = false;
		}
	}
}