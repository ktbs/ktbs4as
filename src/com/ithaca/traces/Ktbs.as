package com.ithaca.traces
{
	import mx.collections.ArrayCollection;

	public class Ktbs extends Resource
	{
		
		protected var arBases:ArrayCollection = new ArrayCollection();
		
		public function Ktbs(item:Object=null, uid:String=null, proxyDepth:int=-1)
		{
			super(item, uid, proxyDepth);
		}
		
		[Bindable("listBasesChange")]
		public function listBases():ArrayCollection
		{
			return arBases;
		}
	}
}