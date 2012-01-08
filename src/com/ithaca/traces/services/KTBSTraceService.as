		package com.ithaca.traces.services
{
	import com.ithaca.traces.Base;
	import com.ithaca.traces.Ktbs;
	import com.ithaca.traces.Model;
	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.Resource;
	import com.ithaca.traces.StoredTrace;
	import com.ithaca.traces.utils.RDFconverter;
	
	import flash.sampler.NewObjectSample;
	import flash.utils.Dictionary;
	
	import mx.controls.TextArea;
	import mx.rpc.AbstractInvoker;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.StringUtil;
	
	public class KTBSTraceService extends HTTPService implements ITraceService
	{
		
		public static var URI_REL_CONTAINS:String = "http://liris.cnrs.fr/silex/2009/ktbs#contains";
		public static var URI_REL_TYPE:String = "http://www.w3.org/1999/02/22-rdf-syntax-ns#type";
		public static var URI_REL_LABEL:String = "http://www.w3.org/2000/01/rdf-schema#label";
		public static var URI_REL_HAS_BASE:String = "http://liris.cnrs.fr/silex/2009/ktbs#hasBase";
		public static var URI_REL_HAS_SOURCE:String = "http://liris.cnrs.fr/silex/2009/ktbs#hasSource";
		public static var URI_REL_HAS_OBSEL_COLLECTION:String = "http://liris.cnrs.fr/silex/2009/ktbs#hasObselCollection";
		public static var URI_REL_HAS_RELATION_RANGE:String = "http://liris.cnrs.fr/silex/2009/ktbs#hasRelationRange";
		
		
		public static var URI_TYPE_STORED_TRACE:String = "http://liris.cnrs.fr/silex/2009/ktbs#StoredTrace";
		public static var URI_TYPE_COMPUTED_TRACE:String = "http://liris.cnrs.fr/silex/2009/ktbs#ComputedTrace";
		public static var URI_TYPE_OBSEL:String = "http://liris.cnrs.fr/silex/2009/ktbs#Obsel";
		public static var URI_TYPE_KTBS:String = "http://liris.cnrs.fr/silex/2009/ktbs#KtbsRoot";
		
		

		public var console:TextArea;
		
		public var clientKtbs:Ktbs;
		
		protected var unloadedTriplets:Array = new Array();
		
		private var _serverRole:String = ServiceUtility.SERVER_ROLE_LISTEN;
		
		public function KTBSTraceService(theKtbs:Ktbs, destination:String=null)
		{
			super(theKtbs.uri, destination);
			//this.rootURL = rootURL;
			this.contentType="text/nt";
			this.resultFormat="text";
			
			clientKtbs = theKtbs;
			
			this.addEventListener(ResultEvent.RESULT, onResult);
			this.addEventListener(FaultEvent.FAULT, onFault);
			this.loadResource(theKtbs);
		}
		
		public function set serverRole(value:String):void
		{
			_serverRole = value;
		}
		
		public function get serverRole():String
		{
			return _serverRole;
		}
		

		protected function processTriplet(triplet:Array):void
		{
			var sujet:* = triplet[0];
			var predicat:* = triplet[1];
			var objet:* = triplet[2];
			var consumedTriplets:Array = []; 
			var createdRessourcesWithGenuineUri:Array= [];
			
			var predicatUri:String = getUriFromString(predicat); //null if not an uri string in the triplets
			var objetUri:String =  getUriFromString(objet); //null if not an uri string in the triplets
			var sujetUri:String =  getUriFromString(sujet); //null if not an uri string in the triplets
			
			
			if(predicatUri)
			{
				switch(predicatUri)
				{
					case URI_REL_HAS_BASE :
						if(sujet && sujet is Ktbs)
						{
							if(objetUri)
							{
								var newResource:Resource = (sujet as Ktbs).createBase(objetUri);
								createdRessourcesWithGenuineUri.push({"uri":objetUri,"resource":newResource});
								consumedTriplets.push(triplet);
							}
							else
								logToConsole("error");
						}
						break;
					case URI_REL_LABEL :
						if(sujet && sujet is Resource && objet && objet is String)
						{
							sujet.label = objet;
							consumedTriplets.push(triplet);
						}
						else
							logToConsole("error");
						break;
					case URI_REL_CONTAINS :
						if(sujet && sujet is Base && objetUri)
						{
							var typeTriplet:Array = searchUnloadedTriplets(objet,"<"+URI_REL_TYPE+">",null);
							if(typeTriplet && typeTriplet.length == 1)
							{
								if(typeTriplet[0][2] == "<"+URI_TYPE_STORED_TRACE+">")
								{
									var newStoredTrace:StoredTrace = (sujet as Base).createStoredTrace(new Model(sujet as Base),null,null,objetUri);
									consumedTriplets.push(triplet);
									consumedTriplets.push(typeTriplet);
									createdRessourcesWithGenuineUri.push({"uri":objetUri,"resource":newStoredTrace});
								}
							}
						}
						else
							logToConsole("error");
						break;
					default:
						break;
				}
			}
			
			//then we update the global list of unloaded triplets
			for(var i:int = 0 ; i < unloadedTriplets.length ; i++)
			{
				var t:Array = unloadedTriplets[i];
				
				//we remove the t triplet if it has been consumed during the process
				var isCurrentTripletRemoved:Boolean = false;
				for each(var ct:Array in consumedTriplets)
				{
					if(t === ct) //hope === operator compares value of arrays
					{
						unloadedTriplets.splice(i,1);
						isCurrentTripletRemoved = true;
					}
				}
				
				//we replace the value of the newly created resource in the triplets where it appears
				if(!isCurrentTripletRemoved)
					for each(var cr:Object in createdRessourcesWithGenuineUri)
					{
						var isCurrentTripletUpdated:Boolean = false;
						
						if(t[0] == cr.uri)
							unloadedTriplets[i][0] = cr.resource;
						if(t[1] == cr.uri)
							unloadedTriplets[i][1] = cr.resource;
						if(t[2] == cr.uri)
							unloadedTriplets[i][2] = cr.resource;
						
						if(isCurrentTripletUpdated)
							processTriplet(unloadedTriplets[i]);
					}
			}
			
			/*for each(var cr:Object in createdRessourcesWithGenuineUri)
			{
				if(cr.resource is Base)
					loadResource(cr.resource);
			}*/
			
				
		}

		public function searchUnloadedTriplets(sujet:*,predicat:*,objet:*):Array
		{
			var arResult:Array = [];
			for each(var t:Array in unloadedTriplets)
			{
				if((sujet == null || sujet == t[0])
					&&(predicat == null || predicat == t[1])
					&&(objet == null || objet == t[2]))
				{
					arResult.push(t);
				}		
			}
			
			return arResult ? arResult : null;
		}
		
		public function syncResource(res:Resource):AsyncToken
		{
			//TODO : submit client-side modifiation to the server
			if(res.sync_status == Resource.RESOURCE_SYNC_STATUS_UNLOADED)
				return loadResource(res);
			
			return null;
		}
		
		public function loadResource(res:Resource):AsyncToken
		{
			this.method = "GET";
			this.url = res.uri+".nt";
			logToConsole("sending get to "+this.url);
			return this.send();
		}
		
		private static function getUriFromString(s: String):String
		{
			var a:Array = StringUtil.trim(s).match(/^<(.+)>$/);
			if(a != null && a[1])
				return a[1];
			else
				return null;
		}
		
		public function readNTBlock(ntb:String):void
		{
			//we split the ttl on each "." line (kind of an "end of instruction" in ttl (?))
			var ar:Array = ntb.split(".\n");
			//var arReturn:Array = [];
			
			
			for each (var l: String in ar)
			{
				l = StringUtil.trim(l);
				var a:Array = l.match(/"(.*?)"|<(.*?)>|\s?(\S*)\s?/g);
				if(a && a.length == 3)
				{
					var triplet:Array = [];
				
					for(var i:int = 0; i < 3; i++)
					{
						var s:String = a[i];
						s = StringUtil.trim(s);
						
						var a2:Array;
						var res:* = null;
						
						if (s == '"[null value]"')
							res = null;
						else if(a2 = s.match(/^"(.*)"$/)) // String
							res = (a2[1].replace('\\"', '"') as String).replace('\\n', "\n");
						else if(a2 = s.match(/^<(.+)>$/)) //URI
						{
							res = clientKtbs.get(a2[1]); // if the uri point to a known, instanciated resource
							if(res == null) 
								res = s; //else we keep the string value with the < > delimiters
						}
						else 
							res = s;
						
						//TODO : deal with number
						
						triplet.push(res);
					}
					
					unloadedTriplets.push(triplet);
					
				}
				
				for each(var t:Array in unloadedTriplets)
					processTriplet(t);
			}
			

		}
		

		
		private static function repr2valueWithMeta(s: String, isTime: Boolean = false): Object
		{
			var res: *;
			var a: Array;
			
			var isValueAnUri:Boolean = false;
			
			s = StringUtil.trim(s);
			
			if (s == '"[null value]"')
			{
				res = null;
			}
			else
			{
				
				if(s.charAt(0) == "\\" && s.charAt(s.length-2) == "\\" && s.charAt(s.length-1) == "\"") //in case we have string like this as a "s" parameter  :   \"toto\"
					s = s.substr(1,s.length-3)+"\"";
				
				a = s.match(/^"(.*)"$/);
				if (a)
				{
					
					// String
					res = (a[1].replace('\\"', '"') as String).replace('\\n', "\n");
				}
				else
				{
					a = s.match(/^<(.+)>$/);
					if (a)
					{
						// Reference. Consider as a string for the moment.
						res = a[1];
						isValueAnUri = true;
					}
					else if(isTime)
						res = Number(s);
					else
						res = s;
				}
			}
			return {isUri:isValueAnUri, value:res};
		}
		
		protected function onFault(e:FaultEvent):void
		{
			logToConsole(e.message.toString());
		}

		protected function onResult(e:ResultEvent):void
		{
			logToConsole(e.result as String);
			readNTBlock(e.result as String);
			
			//if a resource has been loaded
			if(clientKtbs && clientKtbs.get(e.message.destination))
				clientKtbs.get(e.message.destination).sync_status = Resource.RESOURCE_SYNC_STATUS_SYNCHRONIZED;
				//TODO : get some feed back from the readNTBlock function to be sure that the parsing was "errorless"
		}
		
		public function addObsel(obs:Obsel):AsyncToken
		{
			var traceUri:String = obs.trace.uri;
			if(traceUri.charAt(traceUri.length-1) != "/")
				traceUri += "/";
			
			this.contentType="text/turtle";
			this.url = obs.trace.uri;
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