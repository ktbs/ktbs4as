package com.ithaca.traces
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;

	public class Trace extends Resource
	{
		internal var _base:Base;
		internal var _model:Model;
		internal var _origin:String;
		
		internal var _arTraceSources:ArrayCollection;
		internal var _arTraceTransformed:ArrayCollection;
		
		[Bindable]
		internal var _arObsels:ObselCollection;
		//we define a way the obsel array collection will be maintained sorted. The array will be searchable more efficiently on the field we declare here.
		//internal var arObselSortFields:Array = [new SortField("begin"), new SortField("end")]; 	
		
		public function Trace(base:Base, model:Model, origin:String = null, uri:String=null, uri_attribution_policy:String = null)
		{
			super(uri, uri_attribution_policy);
			_base = base;
			_model = model;
			if(origin)			
				this._origin = origin;
			else
				; // TODO : set origin to now()
			
			//Creating the arObsels ArrayCollection and applying sortfield
			_arObsels = new ObselCollection();
			/*var arObselsSort:Sort = new Sort();
			arObselsSort.fields = arObselSortFields;
			_arObsels.sort = arObselsSort;*/
			
			this._arTraceSources = new ArrayCollection();
			this._arTraceTransformed = new ArrayCollection();
		}
		
		public function get services():ArrayCollection
		{
			return _base.ktbs.arServices;
		}

		public function get base():Base
		{
			return _base;
		}

		public function get model():Model
		{
			return _model;
		}

		[Bindable]
		public function get origin():String
		{
			return _origin;
		}
		


		[Bindable(event="listSourcesChange")]
		public function listSources():ArrayCollection
		{
			return _arTraceSources;
		}


		[Bindable(event="listTransformedChange")]
		public function listTransformedTraces():ArrayCollection
		{
			return _arTraceTransformed;
		}

		[Bindable]
		public function get obsels():ObselCollection
		{
			return _arObsels;
		}	
		
		/*protected function findClosestBeginingObsel(t:Number, start:Number, end:Number):Object
		{
			if(isNaN(start))
				return findClosestSmaller(ar,t,0,arTimes.length-1)
			else if(start == end)
				return ar[start];
			else
			{
				var middle:Number = Math.floor((end-start)/2);
				
				if(middle >= 1)
				{
					middle += start;
					
					if(ar[middle] > n)
						return findClosestSmaller(ar,n,start, middle);
					else
						return findClosestSmaller(ar,n,middle, end);
				}
				else
					return ar[start];
			}
		}*/
		
		public function getEarliestObsel():Obsel
		{
			var earliest:Obsel = null;
			if(_arObsels.length > 0)
			{
				earliest = _arObsels._obsels[0];
				for each(var obs:Obsel in _arObsels._obsels)
				{
					if(obs.begin < earliest.begin)
						earliest = obs;						
				}
			}
			
			return earliest;
		}
		
		public function getLatestObsel():Obsel
		{
			var latest:Obsel = null;
			if(_arObsels.length > 0)
			{
				latest = _arObsels._obsels[0];
				for each(var obs:Obsel in _arObsels._obsels)
				{
					if(obs.end > latest.end)
						latest = obs;						
				}
			}
			
			return latest;
		}
		
		public function listObsels(begin:Number = NaN, end:Number = NaN, reverse:Boolean = false):ObselCollection
		{
			var ar:ObselCollection = new ObselCollection();
			
			for each(var obs:Obsel in this._arObsels._obsels)
			{
				if(			(	isNaN(begin) || (!isNaN(obs.begin) && obs.begin > begin)	)
					&& 	( 	isNaN(end) || (!isNaN(obs.end) && obs.end < end) || (!isNaN(obs.begin) && obs.begin < end)	)
				)
				{
					ar.push(obs)		
				}
			}
			
			return ar;
			
			//ArrayCOllection Implementation
			/*var ar:Array = [];
			this._arObsels.refresh(); // we order the obsels by begin time
			
			if(isNaN(begin) && isNaN(end))
				return _arObsels.source;
			
			for each(var obs:Obsel in this._arObsels)
			{
				if(			(	isNaN(begin) || (!isNaN(obs.begin) && obs.begin > begin)	)
						&& 	( 	isNaN(end) || (!isNaN(obs.end) && obs.end < end) || (!isNaN(obs.begin) && obs.begin < end)	)
					)
					{
							ar.push(obs)		
					}
			}
			
			if(reverse) 
				ar.reverse();
					 
			return ar;*/
			
			
		}
		
		public function getObsel(uri:String):Obsel
		{
			
			return _base.get(uri) as Obsel;
			
			
			//ArrayCOllection Implementation
			//here we use a cursor on our sorted table. This approach is said to be more efficient.
			/*this._arObsels.refresh();
			
			var cursor:IViewCursor = this._arObsels.createCursor();
			
			if(cursor.findAny({"uri":uri}))
				if(cursor.current is Obsel)
					return cursor.current as Obsel;*/
		
			return null;
		}
		
		public function getObselsAsAray():Array //depreciated
		{
			var ar:Array = [];
			
			for each(var obs:Obsel in this._arObsels._obsels)
			{
					ar.push(obs)		
			}
			
			return ar;
		}
		
		public function getObselsAsArayCollection():ArrayCollection //depreciated
		{
			
			//WARNING : won't update with the trace, depreciated
			
			return new ArrayCollection(getObselsAsAray());
		}

	}
}