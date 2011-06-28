package com.ithaca.traces
{
	
	public class ComputedTrace extends Trace
	{
		public function ComputedTrace(base:Base, model:Model, origin:String = null, uri:String=null, uri_attribution_policy:String = null)
		{
			super(base, model, origin, uri, uri_attribution_policy);
		}
	}
}