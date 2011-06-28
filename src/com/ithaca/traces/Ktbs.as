package com.ithaca.traces
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.utils.ObjectProxy;

	public class Ktbs extends Resource
	{
			
		protected var arBases:ArrayCollection;		

		
		public function Ktbs(uri:String=null, uri_attribution_policy:String = null)
		{
			super(uri, uri_attribution_policy);
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
			var newBase:Base = new Base(uri,this.uri_attribution_policy);
			arBases.addItem(newBase);
			this.dispatchEvent(new Event("listBasesChange"));
			return newBase;
		}
	}
}