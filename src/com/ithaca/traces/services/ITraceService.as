package com.ithaca.traces.services
{
	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.Resource;
	
	import flash.events.Event;
	
	import mx.rpc.AbstractInvoker;
	import mx.rpc.AsyncToken;

	public interface ITraceService
	{

		
		function addObsel(obs:Obsel):AsyncToken;
		function deleteObsel(obs:Obsel):AsyncToken;
		function updateObsel(obs:Obsel):AsyncToken;
		function syncResource(res:Resource):AsyncToken;
		
		function set serverRole(value:String):void;
		function get serverRole():String;
		
	}
}