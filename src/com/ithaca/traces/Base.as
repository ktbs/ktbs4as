package com.ithaca.traces
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectProxy;

	public class Base extends Resource
	{
		protected var mapUriToResource:ObjectProxy;
		
		protected var _arTraces:ArrayCollection;
		
		protected var _arModels:ArrayCollection;
		
		
		
		public function Base(uri:String=null, uri_attribution_policy:String = null)
		{
			super(uri, uri_attribution_policy);
		}
		
		public function get(uri:String):Resource
		{
			if(Resource.isUriWellFormed(uri) && this.mapUriToResource.hasOwnProperty(uri))
				return this.mapUriToResource[uri];
			
			return null;
		}

		[Bindable(event="arTracesChange")]
		public function listTraces():ArrayCollection
		{
			return _arTraces;
		}

		[Bindable(event="arModelsChange")]
		public function listModels():ArrayCollection
		{
			return _arModels;
		}
		
		public function createStoredTrace(model:Model, defaultSubject:String = null, origin:String = null, uri:String = null):StoredTrace
		{
			var newTrace:StoredTrace = new StoredTrace(uri, this.uri_attribution_policy);
			//TODO
			
			return newTrace;
			
		}
		
		public function createComputedTrace(model:Model, method:Method, sources:Array):ComputedTrace
		{
			var newTrace:ComputedTrace = new ComputedTrace(uri, this.uri_attribution_policy);
			//TODO
			
			return newTrace;
		}
		
		public function createModel(uri:String = null):Model
		{
			var newModel:Model = new Model(uri, this.uri_attribution_policy);
			//TODO
			
			return newModel;
		}
		
		public function createMethod(inherits:Method, uri:String = null, parameters:Object = null):Method
		{
			var newMethod:Method = new Method(uri, this.uri_attribution_policy);
			//TODO
			
			return newMethod;
		}
		
	}
}