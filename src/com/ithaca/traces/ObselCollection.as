// inspired by http://flexperiential.com/2011/02/26/an-enhanced-type-safe-data-provider-technique-for-flex-ilist-based-controls/
package com.ithaca.traces
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.collections.Sort;
	import mx.collections.SortField;
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
		
        public function compareObselsBegin(a:Object, b:Object):int
        {
            if((a as Obsel).begin < (b as Obsel).begin)
                return -1;
            else
                return 1;
        }
        
        public function sortByBegin():void
        {
            _obsels.sort(compareObselsBegin);
        }
        
        
        public function compareObselsEnd(a:Object, b:Object):int
        {
            if((a as Obsel).end < (b as Obsel).end)
                return -1;
            else
                return 1;
        }
        
        public function sortByEnd():void
        {
            _obsels.sort(compareObselsEnd);
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
        
        public function pushMultiple(ar:Array):void
        {
            var event:CollectionEvent =	new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            event.location = _obsels.length;
            event.kind = CollectionEventKind.ADD;
            
            for each(var o:Obsel in ar)
            {
                event.items.push(o);
                _obsels.push(o);
            }
            
            dispatchEvent(event);            
        }
        
        public function pushFromOtherObselCollection(ar:Vector.<Obsel>):void
        {
            var event:CollectionEvent =	new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            event.location = _obsels.length;
            event.kind = CollectionEventKind.ADD;
            
            for each(var o:Obsel in ar)
            {
                event.items.push(o);
                _obsels.push(o);
            }
            
            dispatchEvent(event);            
        }
		
		// IList
	
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
        
        public function addAll(ar:IList):void
        {
            var event:CollectionEvent =	new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            event.location = _obsels.length;
            event.kind = CollectionEventKind.ADD;
         
            for each(var o:Obsel in ar)
            {
                event.items.push(o);
                _obsels.push(o);
            }

            dispatchEvent(event);            
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
		
		public function contains(item:Object):Boolean
		{
			if(getItemIndex(item)<0)
				return false;
			else
				return true;
		}
		
		public function itemUpdated(item:Object, property:Object=null, oldValue:Object=null, newValue:Object=null):void
		{
			throw new IllegalOperationError("itemUpdated - no access through IList; use IPersonVectorDP instead");
		}
		
		public function removeAll():void
		{
			while(_obsels.length > 0)
				_obsels.pop();
			
			var event:CollectionEvent =	new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
			event.kind = CollectionEventKind.RESET;
			dispatchEvent(event);
			
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
		
		public function listValuesBrute(noRepetition:Boolean = true, correspondingTypes:Array = null, correspondingAttributes:Array = null):ArrayCollection
		{
			var arReturn:ArrayCollection = new ArrayCollection();
			
			for each(var obs:Obsel in _obsels)
				for each(var a:Attribute in obs._attributes)
					if( (!noRepetition || arReturn.getItemIndex(a.value) < 0)
						&& (!correspondingTypes || correspondingTypes.indexOf(obs.obselType) >= 0)
						&& (!correspondingAttributes || correspondingAttributes.indexOf(a.attributeType) >= 0)
					  )
						arReturn.addItem(a.value);
			
            var sort:Sort = new Sort();
            sort.fields = [new SortField()];
            
            arReturn.sort = sort;
            arReturn.refresh();
            
            return arReturn;				
		}
		
		public function listObselTypesBrute(noRepetition:Boolean = true):ArrayCollection
		{
			var arReturn:ArrayCollection = new ArrayCollection();
			
			for each(var obs:Obsel in _obsels)
					if(	(!noRepetition || arReturn.getItemIndex(obs.obselType) < 0))
						arReturn.addItem(obs.obselType)
			
            var sort:Sort = new Sort();
            sort.fields = [new SortField("label")];
            
            arReturn.sort = sort;
            arReturn.refresh();
            
            return arReturn;			
		}
		
		public function listAttributeTypesBrute(noRepetition:Boolean = true,  correspondingTypes:Array = null, correspondingValues:Array = null):ArrayCollection
		{
			var arReturn:ArrayCollection = new ArrayCollection();
			
			for each(var obs:Obsel in _obsels)
				for each(var a:Attribute in obs._attributes)
					if(	(!noRepetition || arReturn.getItemIndex(a.attributeType) < 0)
						&& (!correspondingTypes || correspondingTypes.indexOf(obs.obselType) >= 0)
						&& (!correspondingValues || correspondingValues.indexOf(a.value) >= 0)
					)
							arReturn.addItem(a.attributeType)
		    
            var sort:Sort = new Sort();
            sort.fields = [new SortField("label")];
            
            arReturn.sort = sort;
            arReturn.refresh();
            
			return arReturn;	
            


            

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