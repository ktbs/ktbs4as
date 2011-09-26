package com.ithaca.traces.services
{
	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.utils.RDFconverter;
	
	import mx.rpc.AbstractInvoker;
	import mx.rpc.AsyncToken;
	import mx.rpc.http.HTTPService;
	
	public class KTBSTraceService extends HTTPService implements ITraceService
	{
		public function KTBSTraceService(rootURL:String=null, destination:String=null)
		{
			super(rootURL, destination);
			this.rootURL = rootURL;
			this.method = "POST";
			this.contentType="text/turtle";
		}
		
		public function addObsel(obs:Obsel):AsyncToken
		public function set serverRole(value:String):void
		{
			_serverRole = value;
		}
		
		public function get serverRole():String
		{
			return _serverRole;
		}
		{

			this.url = rootURL+obs.uid+"/"+obs.trace.uri+"/";
			return this.send(RDFconverter.toRDF(obs));
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
		
		public function getModel(obs:Obsel):AsyncToken
		{
			return null;
		}
		
		private function logToConsole(str:String):void
		{
			if(console)
				console.text += new Date().toString()+ " : \t" +str + "\n";
		}
	}
}