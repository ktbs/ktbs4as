package com.ithaca.traces
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.utils.ObjectProxy;

	public class Ktbs extends Resource
	{
		
		internal var mapUriToResource:ObjectProxy;
		
		[Bindable]
		public var arBases:ArrayCollection;		
		
		public var arServices:ArrayCollection;

		public function Ktbs(uri:String=null, uri_attribution_policy:String = null)
		{
			super(uri, uri_attribution_policy);
			arBases = new ArrayCollection();
			arServices = new ArrayCollection();
			mapUriToResource = new ObjectProxy();
			registerResource(this);
		}
		
		[Bindable("listBasesChange")]
		public function listBases():ArrayCollection
		{
			return arBases;
		}
		
		public function getBase(uri:String):Base
		{
			for each(var o:Object in arBases)
				if(o is Base && (o as Base).uri == uri)
					return o as Base;
			
			return null;
		}
		
		public function createBase(uri:String = null):Base
		{
			var newBase:Base = new Base(this,uri,this.uri_attribution_policy);
			arBases.addItem(newBase);
			registerResource(newBase);
			this.dispatchEvent(new Event("listBasesChange"));
			return newBase;
		}
		
		public function get(uri:String):Resource
		{
			if(this.mapUriToResource.hasOwnProperty(uri))
				return this.mapUriToResource[uri];
			
			return null;
		}
		
		public function registerResource(r:Resource):void
		{
			mapUriToResource[r.uri] = r;
			r._ktbs = this;
			//TODO : handle changing of uri
		}
		
		public function unRegisterResource(r:Resource):void
		{
			delete mapUriToResource[r.uri];
		}
	}
}