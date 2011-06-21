package com.ithaca.traces
{
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.utils.ObjectProxy;

	public class Ktbs extends Resource
	{
			
		protected var arBases:ArrayCollection;		
		
		public function Ktbs(uri:String=null, uri_attribution_policy:String = null)
		{
			
			
		}
		
		[Bindable("listBasesChange")]
		public function listBases():ArrayCollection
		{
			return arBases;
		}
		
		public function getBase(uri:String):Base
		{
			if(Resource.isUriWellFormed(uri))
				for each(var o:Object in arBases)
					if(o is Base && (o as Base).uri == uri)
						return o as Base;
			
			return null;
		}
		
		public function createBase(uri:String = null):Base
		{
			var newBase:Base = new Base(uri,this.uri_attribution_policy);
			return newBase;
		}
	}
}