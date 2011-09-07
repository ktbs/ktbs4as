// inspired by http://flexperiential.com/2011/02/26/an-enhanced-type-safe-data-provider-technique-for-flex-ilist-based-controls/
package com.ithaca.traces
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	[Event(name="collectionChange", type="mx.events.CollectionEvent")]
	public class ObselCollection extends EventDispatcher implements IList
	{
		public var _obsels:Vector.<Obsel> = new Vector.<Obsel>;
		private var _listeners:Vector.<Function> = new Vector.<Function>;
		
		public function ObselCollection()
		{

		}
		
		public function pop():Obsel
		{
			var poppedObsel:Obsel = _obsels.pop();
			var event:CollectionEvent =	new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
			event.kind = CollectionEventKind.REMOVE;
			event.items.push(poppedObsel);
			event.location = _obsels.length;
			dispatchEvent(event);
			return poppedObsel;
		}
		
		public function push(value:Obsel):uint
		{
			var count:uint = _obsels.push(value);
			var event:CollectionEvent =	new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
			event.kind = CollectionEventKind.ADD;
			event.items.push(value);
			event.location = count-1;
			dispatchEvent(event);
			return count;
		}
		
		//
		// IList
		//
		public function get length():int
		{
			return _obsels.length;
		}
		
		public function addItem(item:Object):void
		{
			if(item is Obsel)
				this.push(item as Obsel)
			else
				throw new IllegalOperationError("addItem - only accept Obsel");
		}
		
		public function addItemAt(item:Object, index:int):void
		{
			throw new IllegalOperationError("addItem - only accept Obsel");
		}
		
		public function getItemAt(index:int, prefetch:int=0):Object
		{
			return _obsels[index] as Object;
		}
		
		public function getItemIndex(item:Object):int
		{
			for (var i:int = 0; i < _obsels.length; i++)
			{
				var element:Obsel = _obsels[i] as Obsel;
				if(element == item)
				{
					return i;
				}
			}
			return -1;
		}
		
		public function itemUpdated(item:Object, property:Object=null, oldValue:Object=null, newValue:Object=null):void
		{
			throw new IllegalOperationError("itemUpdated - no access through IList; use IPersonVectorDP instead");
		}
		
		public function removeAll():void
		{
			throw new IllegalOperationError("removeAll - no access through IList; use IPersonVectorDP instead");
		}
		
		public function removeItemAt(index:int):Object
		{
			throw new IllegalOperationError("removeItemAt - no access through IList; use IPersonVectorDP instead");
			return null;
		}
		
		public function setItemAt(item:Object, index:int):Object
		{
			throw new IllegalOperationError("setItemAt - no access through IList; use IPersonVectorDP instead");
			return null;
		}
		
		public function toArray():Array
		{
			var ar:Array = [];
			for each(var o in _obsels)
				ar.push(o);
				
			return ar;
		}
		
		
		
	}
}