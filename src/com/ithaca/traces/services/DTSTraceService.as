package com.ithaca.traces.services
{
	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.utils.RDFconverter;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.rpc.AbstractInvoker;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class DTSTraceService extends HTTPService implements ITraceService
	{
		private var clock:Timer;
		public var obsToSync:String; 
		public var obsSyncing:String;	
		public var batchDelay:uint = 10 * 1000;
		
		public var uid_trace:String;
		public var uri_trace:String;
		
		[Bindable]
		public var status:String = "synchronized";
		
		public function DTSTraceService(rootURL:String=null, destination:String=null)
		{
			super(rootURL, destination);
			this.rootURL = rootURL;
			this.url = rootURL;
			this.method = "POST";
			
			obsToSync = "";
			
			clock = new Timer(batchDelay);
			clock.addEventListener(TimerEvent.TIMER, sendObsels);
			clock.start();
			
			this.addEventListener(ResultEvent.RESULT, onRequestResult);
			this.addEventListener(FaultEvent.FAULT, onRequestFault);
		}
		
		
		
		public function addObsel(obs:Obsel):AsyncToken
		{
			//return this.send({ "user":obs.uid, "trace": obs.trace, "content": obs.rdf });
			
			obsToSync += RDFconverter.toRDF(obs);
			uid_trace = obs.subject;
			uri_trace = obs.trace.uri;
			
			if(status != "error")
				status = "unsynchronized";
			
			this.dispatchEvent(new Event("status_update"));
			
			return null;
		}
		
		public function sendObsels(e:Event = null):AsyncToken
		{
			obsSyncing += obsToSync;	
			obsToSync = "";
			
			if(obsSyncing != "")
			{
				status = "synchronizing";
				this.dispatchEvent(new Event("status_update"));
				return this.send({ "user":uid_trace, "trace": uri_trace , "content": obsSyncing });
			}
			
			return null;
		}
		
		
		public function deleteObsel(obs:Obsel):AsyncToken
		{
			//TODO
			return null;
		}
		
		public function updateObsel(obs:Obsel):AsyncToken
		{
			//TODO
			return null;
		}
		
		protected function onRequestResult(e:ResultEvent):void
		{
			obsSyncing = "";
			status = "synchronized";
			this.dispatchEvent(new Event("status_update"));
		}
		
		protected function onRequestFault(e:FaultEvent):void
		{
			status = "error";
			this.dispatchEvent(new Event("status_update"));
		}
		
		public function syncNow(e:Event = null):AsyncToken
		{
			return sendObsels();
		}
	}
}