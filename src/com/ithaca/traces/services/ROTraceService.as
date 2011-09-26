package com.ithaca.traces.services
{
	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.Resource;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.remoting.RemoteObject;
	
	public class ROTraceService extends RemoteObject implements ITraceService
	{
		private var _serverRole:String = ServiceUtility.SERVER_ROLE_LISTEN;
		
		public function ROTraceService(pServer:String, pDestination:String="ObselService", pMakeObjectsBindable:Boolean=true, pShowBusyCursor:Boolean = false)
		{
			super(pDestination);
			endpoint=pServer;
			destination = pDestination;
			makeObjectsBindable=pMakeObjectsBindable;
			showBusyCursor= pShowBusyCursor;
		}
		
		public function addObsel(obs:Obsel):AsyncToken
		{
			return this.getOperation("addObsel").send(obs);		
		}
		
		public function deleteObsel(obs:Obsel):AsyncToken
		{
			return getOperation("deleteObsel").send(obs);
		}
		
		public function updateObsel(obs:Obsel):AsyncToken
		{
			return getOperation("updateObsel").send(obs);
		}
		
		public function set serverRole(value:String):void
		{
			_serverRole = value;
		}
		
		public function get serverRole():String
		{
			return _serverRole;
		}
		
		public function syncResource(res:Resource):AsyncToken
		{
			//TODO
			return null;
		}
		
		
	}
}