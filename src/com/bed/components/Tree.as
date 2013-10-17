package com.bed.components
{
	import com.bed.renderers.TreeListItemRenderer;
	import com.bed.supportClasses.TreeItem;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.core.ClassFactory;
	
	import spark.components.List;
	
	public class Tree extends List
	{
		public function Tree()
		{
			
			super();
			itemRenderer = new ClassFactory(TreeListItemRenderer);
			
			addEventListener("item_update", onItemUpdate);
		}
		
		private function onItemUpdate(e:Event):void
		{
			(this.dataProvider as ArrayCollection).refresh();
		}
		
		public static function toggleChildren(dataProvider:ArrayCollection, treeItem:TreeItem):void
		{
			if (!treeItem.isOpen)
			{
				addItemsAt(dataProvider, dataProvider.getItemIndex(treeItem), treeItem.getChildren());
				treeItem.isOpen = true;
			}
			else
			{
				removeItems(dataProvider, treeItem.getChildren());
				treeItem.isOpen = false;
			}
			
			dataProvider.refresh();
		}
		
		private static function addItemsAt(dataProvider:ArrayCollection, index:int, items:Array):void
		{
			for (var i:int = 0; i<items.length; i++)
			{
				var item:TreeItem = items[i];
				dataProvider.addItemAt(item, index + 1);
				
				if (item.isParent && item.isOpen)
				{
					addItemsAt(dataProvider, index + 1, item.getChildren());
				}
			}
		}
		
		private static function removeItems(dataProvider:ArrayCollection, items:Array):void
		{
			for (var i:int = 0; i<items.length; i++)
			{
				var item:TreeItem = items[i];
				item.visible = false;
				var index:int = dataProvider.getItemIndex(item);
				
				if (index != -1)
				{
					if (item.isParent && item.isOpen)
					{
						removeItems(dataProvider, item.getChildren());
					}
					
					dataProvider.removeItemAt(index);
				}
			}
		}
	}
}