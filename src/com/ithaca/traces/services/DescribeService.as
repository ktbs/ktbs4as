package com.ithaca.traces.services
{
	import com.ithaca.traces.Attribute;
	import com.ithaca.traces.AttributeType;
	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.utils.RDFconverter;
	import com.serialization.json.JSON;
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.system.Security;
	
	import mx.controls.TextArea;
	import mx.rpc.AsyncToken;
	
	public class DescribeService extends Socket implements ITraceService
	{
		private var response:String = "";
		public var console:TextArea;
		private var _host:String;
		private var _port:int;
		
		public function DescribeService(host:String=null, port:int=32145, policyPort:int=32145 )
		{
			_host = host;
			_port = port;

			configureListeners();
			super(host, port);
			Security.allowDomain("localhost");
			
			if (host && port)  {
				super.connect(host, port);
			}
			
		}
		
		private function configureListeners():void {
			addEventListener(Event.CLOSE, closeHandler);
			addEventListener(Event.CONNECT, connectHandler);
			addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
		public function addObsel(obs:Obsel):AsyncToken
		{
			var o:Object = {"uri":obs.uri, "type":obs.obselType.label, "begin":obs.begin, "end":obs.end, "subject":obs.subject, "traceUri":obs.trace.uri, "props":{}};
			
			for each(var at:Attribute in obs.attributes)
				o.props[at.attributeType.label] = at.value;
				
			var d:String = JSON.serialize(o); 
			
			logToConsole("sending obsel : "+d);
			
			writeln(d);
			return null;
		}
		
		public function deleteObsel(obs:Obsel):AsyncToken
		{
			return null;
		}
		
		public function updateObsel(obs:Obsel):AsyncToken
		{
			return null;
			
		}
		
		
		private function writeln(str:String):void {
			
			if(!connected)
				super.connect(_host, _port);
			
			str += "\n";
			try {
				writeUTFBytes(str);
			}
			catch(e:IOError) {
				logToConsole(e.toString());
			}
		}
		
		private function sendRequest():void {
			logToConsole("sendRequest");
			response = "";
			writeln("GET /");
			flush();
		}
		
		private function readResponse():void {
			var str:String = readUTFBytes(bytesAvailable);
			response += str;
		}
		
		private function closeHandler(event:Event):void {
			logToConsole("closeHandler: " + event);
			logToConsole(response.toString());
			//connected = false;
		}
		
		private function connectHandler(event:Event):void {
			logToConsole("connectHandler: " + event);
			//connected = true;
			//sendRequest();
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			logToConsole("ioErrorHandler: " + event);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			logToConsole("securityErrorHandler: " + event);
		}
		
		private function socketDataHandler(event:ProgressEvent):void {
			logToConsole("socketDataHandler: " + event);
			readResponse();
		}
		
		private function logToConsole(str:String):void
		{
			if(console)
				console.text += new Date().toString()+ " : \t" +str + "\n";
		}
	}
}