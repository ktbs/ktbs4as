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
		internal var _arObsels:ArrayCollection;
		//we define a way the obsel array collection will be maintained sorted. The array will be searchable more efficiently on the field we declare here.
		internal var arObselSortFields:Array = [new SortField("begin"), new SortField("uri")]; 	
		
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
			_arObsels = new ArrayCollection();
			var arObselsSort:Sort = new Sort();
			arObselsSort.fields = arObselSortFields;
			_arObsels.sort = arObselsSort;
			
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
		public function get obsels():ArrayCollection
		{
			return _arObsels;
		}	
		
		public function getEarliestObsel():Obsel
		{
			var earliest:Obsel = null;
			var arObsel:Array = this.listObsels();
			if(arObsel.length > 0)
			{
				earliest = arObsel[0];
				for each(var obs:Obsel in arObsel)
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
			var arObsel:Array = this.listObsels();
			if(arObsel.length > 0)
			{
				latest = arObsel[0];
				for each(var obs:Obsel in arObsel)
				{
					if(obs.end > latest.end)
						latest = obs;						
				}
			}
			
			return latest;
		}
		
		public function listObsels(begin:Number = NaN, end:Number = NaN, reverse:Boolean = false):Array
		{
			var ar:Array = [];
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
		


	}
}