package com.ithaca.traces
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;

	public class Trace extends Resource
	{
		protected var _base:Base;
		protected var _model:Model;
		protected var _origin:String;
		
		protected var _arTraceSources:ArrayCollection;
		protected var _arTraceTransformed:ArrayCollection;
		
		protected var _arObsels:ArrayCollection;
		//we define a way the obsel array collection will be maintained sorted. The array will be searchable more efficiently on the field we declare here.
		protected var arObselSortFields:Array = [new SortField("begin"), new SortField("uri")]; 	
		
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
		
		public function listObsels(begin:Number = NaN, end:Number = NaN, reverse:Boolean = false):Array
		{
			var ar:Array = [];
			this._arObsels.refresh(); // we order the obsels by begin time
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
					 
			return ar;	
		}
		
		public function getObsel(uri:String):Obsel
		{
			//here we use a cursor on our sorted table. This approach is said to be more efficient.
			this._arObsels.refresh();
			
			var cursor:IViewCursor = this._arObsels.createCursor();
			
			if(cursor.findAny({"uri":uri}))
				if(cursor.current is Obsel)
					return cursor.current as Obsel;
		
			return null;
		}

	}
}