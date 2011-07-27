package com.ithaca.traces
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectProxy;

	public class Base extends Resource
	{
		internal var mapUriToResource:ObjectProxy;
		
		internal var _arTraces:ArrayCollection;
		
		internal var _arModels:ArrayCollection;
		
		internal var _arMethods:ArrayCollection;
		
		internal var _ktbs:Ktbs;
		
		
		public function Base(ktbs:Ktbs, uri:String=null, uri_attribution_policy:String = null)
		{
			super(uri, uri_attribution_policy);
			
			_arTraces = new ArrayCollection();
			_arModels = new ArrayCollection();
			_arMethods = new ArrayCollection();
			_ktbs = ktbs;
		}
		
		public function get ktbs():Ktbs
		{
			return _ktbs;
		}
		
		public function get(uri:String):Resource
		{
			if(this.mapUriToResource.hasOwnProperty(uri))
				return this.mapUriToResource[uri];
			
			return null;
		}

		[Bindable(event="listTracesChange")]
		public function listTraces():ArrayCollection
		{
			return _arTraces;
		}

		[Bindable(event="listModelsChange")]
		public function listModels():ArrayCollection
		{
			return _arModels;
		}
		
		[Bindable(event="listMethodsChange")]
		public function listMethods():ArrayCollection
		{
			return _arMethods;
		}
		
		public function createStoredTrace(model:Model, defaultSubject:String = null, origin:String = null, uri:String = null):StoredTrace
		{
			var newTrace:StoredTrace = new StoredTrace(this,model,defaultSubject, origin,uri);
			
			this._arTraces.addItem(newTrace);
			this.dispatchEvent(new Event("listTracesChange"));
			
			return newTrace;
		}
		
		public function createComputedTrace(model:Model, method:Method, sources:Array):ComputedTrace
		{
			var newTrace:ComputedTrace = new ComputedTrace(this, model, null, uri, this.uri_attribution_policy);
			//TODO : computed trace initialization
			this._arTraces.addItem(newTrace);
			this.dispatchEvent(new Event("listTracesChange"));
			
			return newTrace;
		}
		
		public function createModel(uri:String = null):Model
		{
			var newModel:Model = new Model(this, uri, this.uri_attribution_policy);
			this._arModels.addItem(newModel);
			this.dispatchEvent(new Event("listModelsChange"));
			
			return newModel;
		}
		
		public function createMethod(inherits:Method, uri:String = null, parameters:Object = null):Method
		{
			var newMethod:Method = new Method(uri, this.uri_attribution_policy);
			//TODO : method initialization
			this._arMethods.addItem(newMethod);
			this.dispatchEvent(new Event("listMethodsChange"));
			
			return newMethod;
		}
		
		[Bindable(event="listTracesChange")]
		public function getTraceByName(name:String):Array
		{
			var returnAr:Array = [];
			
			for each(var tr:Trace in this._arTraces)
			{
				if(tr.label == name)
					returnAr.push(tr);
			}
			
			return returnAr;
		}
		
	}
}