package com.ithaca.traces.utils
{
	import com.ithaca.traces.Attribute;
	import com.ithaca.traces.AttributeType;
	import com.ithaca.traces.Base;
	import com.ithaca.traces.Model;
	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.ObselType;
	import com.ithaca.traces.Relation;
	import com.ithaca.traces.StoredTrace;
	import com.ithaca.traces.Trace;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.utils.StringUtil;

	public class RDFconverter
	{
		private static var quote_regexp: RegExp = /"/g;
		private static var eol_regexp: RegExp = /\r/g;
		
		private static var logger:ILogger = Log.getLogger("com.ithaca.traces.RDFconverter");
        
        private static var bench_instanciate_obsel:Number = 0;
        private static var bench_getting_type:Number = 0;
        private static var bench_creating_type:Number = 0;        
        private static var bench_getting_Attribut_type:Number = 0;
        private static var bench_creating_Attribut_type:Number = 0;
		
		public function RDFconverter()
		{
		}
		
		public static function updateTraceBaseFromTurtle(ttl:String, theBase:Base, theModel:Model = null):Object
		{
				//we split the ttl on each "." line (kind of an "end of instruction" in ttl (?))
				var ar:Array = ttl.split("\n.\n");
				
				var arCreatedTraces:Array = [];
                var arObjectObs:Array = [];
				
				if(!theModel)
					theModel = theBase.createModel();
				
                var timeParsing:Number = 0;
                var timeConstructing:Number = 0;
                
                var dg:Number = new Date().time;
				for each (var l: String in ar)
				{
					//if(l.substr(0,7) != "@prefix")
					//{
					l = l + "\n.\n"; //we (re)add the "." line at the end of instruction (because the "split function" has not include it)
					
					//for each "ttl instruction", we create a temporary object to hold all the obsel data
					var dp:Number = new Date().time;
                    var objectObs:Object = getObjectifiedObselFromRDF(l);
                    timeParsing += new Date().time - dp;
					
					
					if(objectObs.type)
					{
						var relatedTrace:StoredTrace = null;
						
						if(objectObs.trace.isUri) //
							relatedTrace = theBase.get(objectObs.trace.value) as StoredTrace;
						else
						{
							var correspondingTraces:Array = theBase.getTraceByName(objectObs.trace.value);
							
							if(correspondingTraces.length > 0)
								relatedTrace = correspondingTraces[0]; //To make better
						}
						
						if(!relatedTrace) //if a corresponding obsel type has not been found in an existing trace, we create it 
						{
							var newObsTraceUri:String = objectObs.trace.isUri ? objectObs.trace.value : null; 
							
							relatedTrace = theBase.createStoredTrace(theModel,null,null,newObsTraceUri);
	
							if(!objectObs.trace.isUri)
								relatedTrace.label = objectObs.trace.value;
							
							arCreatedTraces.push(relatedTrace);
						}
						
                        var dc:Number = new Date().time;
						initObselFromData(objectObs,relatedTrace, true, true);
                        timeConstructing += new Date().time - dc;
                        
                        arObjectObs.push(objectObs);
						
					}

                    
				}
                
                var timeGen:Number = new Date().time - dg;
                trace("general",timeGen,"parsing",timeParsing,"constructing",timeConstructing,"other",timeGen-timeParsing-timeConstructing);
				
				return {traces:arCreatedTraces, object: arObjectObs};
		}

        public static function updateTraceBaseFromObjects(arObjectObs:Array, theBase:Base, theModel:Model = null):Object
        {

            var arCreatedTraces:Array = [];
            
            bench_instanciate_obsel = 0;
            bench_getting_type = 0;
            bench_creating_type = 0;        
            bench_getting_Attribut_type = 0;
            bench_creating_Attribut_type = 0;
            
            if(!theModel)
                theModel = theBase.createModel();
            
            var timeParsing:Number = 0;
            var timeConstructing:Number = 0;
            
            var dg:Number = new Date().time;
            for each (var objectObs: Object in arObjectObs)
            { 
                //for each "ttl instruction", we create a temporary object to hold all the obsel data

                
                
                if(objectObs.type)
                {
                    var relatedTrace:StoredTrace = null;
                    
                    if(objectObs.trace.isUri) //
                        relatedTrace = theBase.get(objectObs.trace.value) as StoredTrace;
                    else
                    {
                        var correspondingTraces:Array = theBase.getTraceByName(objectObs.trace.value);
                        
                        if(correspondingTraces.length > 0)
                            relatedTrace = correspondingTraces[0]; //To make better
                    }
                    
                    if(!relatedTrace) //if a corresponding obsel type has not been found in an existing trace, we create it 
                    {
                        var newObsTraceUri:String = objectObs.trace.isUri ? objectObs.trace.value : null; 
                        
                        relatedTrace = theBase.createStoredTrace(theModel,null,null,newObsTraceUri);
                        
                        if(!objectObs.trace.isUri)
                            relatedTrace.label = objectObs.trace.value;
                        
                        arCreatedTraces.push(relatedTrace);
                    }
                    
                    var dc:Number = new Date().time;
                    initObselFromData(objectObs,relatedTrace, true, true);
                    timeConstructing += new Date().time - dc;
                     
                    
                }
                
                
            }
            
            var timeGen:Number = new Date().time - dg;
            trace("general",timeGen,"constructing",timeConstructing,"other",timeGen-timeParsing-timeConstructing);
            trace("instanciate obsel", bench_instanciate_obsel, "getting obsel type", bench_getting_type, 
                "creating obsel type", bench_creating_type, "getting attribute type", bench_getting_Attribut_type, 
                "creating attribute type",bench_creating_Attribut_type);
            
            return {traces:arCreatedTraces, object: arObjectObs};
        }

		
		/**
		 * Convert a value to its turtle representation
		 */
		private static function value2repr(val: *, isTime: Boolean = false, isUri:Boolean = false): String
		{
			var res: String = "";
			
			if (val == null)
			{
				res = '"[null value]"';
			}
			else if(isUri)
			{
				res = "<"+val.toString()+">";
			}
			else if (val is Number || val is int || val is uint)
			{
				if (isTime)
				{
					// Not used for the moment, but we could have special handling here.
					res = val.toString();
				}
				else
				{
					res = val.toString();
				}
			}
			else if (val is Array)
			{
				res="(\n";
				for each (var v: * in val)
				{
					res = res + "        " + value2repr(v) + "\n";
				}
				res = res + ")";
			}
			else
			{
				// FIXME: quoting is not robust: we should double-escape \
				res = '"' + val.toString().replace(quote_regexp, '\\"').replace(eol_regexp, "\\n") + '"';
			}
			return res;
		}
		
		/**
		 * Convert a turtle representation to its value
		 */
		private static function repr2value(s: String, isTime: Boolean = false): *
		{
			var res: *;
			var a: Array;
			
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
					}
					else if(isTime)
						res = Number(s);
					else
						res = s;
				}
			}
			return res;
		}
		
		private static function isReprAnUri(s: String):Boolean
		{
			var a:Array = StringUtil.trim(s).match(/^<(.+)>$/);
			if(a != null)
				return a.length > 0;
			else
				return false
		}
		
		private static function repr2valueWithMeta(s: String, isTime: Boolean = false): Object
		{
			return {isUri:isReprAnUri(s), value:repr2value(s,isTime)};
		}
		
		/**
		 * Generate the RDF/turtle representation of the obsel
		 *
		 * @return The generated RDF
		 */
		public static function toRDF(obs:Obsel): String
		{
			var res: Array = new Array();
			
			var modelReference:String = "";
			
			if(obs.trace && obs.trace.model)
				modelReference = "@prefix : <../"+ obs.trace.model.label +"/> .";
			
			//TODO : fix the time expression to make it works with ktbs (or fix ktbs !)
			res.push("@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .",
				"@prefix ktbs: <http://liris.cnrs.fr/silex/2009/ktbs#> .",
				modelReference,
				"",
				"<" + obs.uri + "> a :" + obs.obselType.label + " ;",
				"  ktbs:hasTrace <" + obs.trace.uri + "> ;",
				"  ktbs:hasBegin " + value2repr(obs.begin, true) + " ;",
				"  ktbs:hasEnd " + value2repr(obs.end, true) + " ;",
				'  ktbs:hasSubject "' + obs.subject + '" ;');
			
			//for each attribute we add it to the rdf
			for each(var at:Attribute in obs.attributes)
			{
				if(at.attributeType)
					res.push("  "+value2repr(at.attributeType.uri, false, true) + " " + value2repr(at.value, ((at.value is String && at.value.indexOf('timestamp') == -1) ? false : true) ) + " ;");
			}
			
			//for each outcoming relation we add it to the rdf
			for each(var r:Relation in obs.outcomingRelations)
			{
				if(r.relationType)
					res.push("  "+value2repr(r.relationType.uri, false, true) + " " + value2repr(r.targetObsel.uri,false,true) + " ;");
			}
			
			/*for (var prop: String in this.props)
			{
				res.push("  :has" + prop.charAt(0).toUpperCase() + prop.substr(1) + " " + value2repr(this.props[prop], (prop.indexOf('timestamp') == -1 ? false : true) ) + " ;");
			}*/
			
			res.push(".\n\n");
			
			return res.join("\n");
		}
		
		
		public static function getObjectifiedObsel(obs: Obsel):Object
		{
			return getObjectifiedObselFromRDF(toRDF(obs));
		}
		/**
		 * Instantiate an object that gather all the data of an Obsel from a RDF/turtle serialization
		 *
		 * <p>Some constraints on the formatting: 
		 *     * semicolons must end each line (except for lists)
		 *     * lists are begun with a single ( as data at the end of a
		 *       line, then one value per line, then ended with );
		 *     * the obsel must end with a . alone on a line.
		 *
		 * @param rdf The RDF string
		 */
		public static function getObjectifiedObselFromRDF(rdf: String):Object
		{
			//TODO : support relations
			//TODO : support source obsels
			
			var obs:Object = {uri:null, type:null, begin:null, end:null, subject:null, trace:null, props:[]};
			
			var a: Array = null;
			var inData: Boolean = false;
			var listData: Array = null;
			
			for each (var l: String in rdf.split(/\n/))
			{
				l = StringUtil.trim(l);
				if (l == ".")
					break;
				//trace("Processing " + l);
				a = l.match(/(.+)\s+a\s+:(\w+)\s*;/);
				if(a) 
				{
					//we have to deal with the typename (or type uri possibly ?)
					obs.type = repr2valueWithMeta(a[2]);			
					


					//we potentially get an URI for the Obsel
					if(isReprAnUri(a[1]))
						obs.uri = repr2value(a[1]);
					
					a = null;
					inData = true;
					
					continue;
				}
				if (! inData)
					continue;
				if (listData)
				{
					a=l.match(/(.*)\s*\)\s*;$/);
					if (a)
					{
						// End of list
						if (StringUtil.trim(a[1]).length != 0)
						{
							// There is a last item
							listData.push(repr2valueWithMeta(StringUtil.trim(a[1])));
						}
						listData = null;
						continue;
					}
					listData.push(repr2valueWithMeta(l));
					continue;
				}
				a = l.match(/^(?:ktbs|):has(\w+)\s+(.+?)\s*;?$/);
				if (a)
				{
					/*
					for (var i: int = 0 ; i < a.length ; i++)
					{
					trace("Property " + i + ": " + a[i]);
					}
					*/
					var prop:Object = repr2valueWithMeta(a[1]);
					var data: String = a[2];
					
					if (data == "(")
					{
						// Beginning of a list
						// FIXME: there may be data just after the (, this case is not taken into account here.
						listData = new Array();
						obs.props.push({prop:prop, value:listData});
						continue;
					}
					else switch ((prop.value as String).toLowerCase())
					{
						case "begin":
						case "end":
							// Convert seconds back to ms
							obs[(prop.value as String).toLowerCase()] = repr2valueWithMeta(data, true);
							// Let's hope actionscript will use this
							// break to get out the switch scope, and
							// not out of the loop.
							break;
						case "subject":
							obs.subject = repr2valueWithMeta(a[2]);
							break;
						case "trace":
							// We should check against the destination trace URI/id
							obs.trace = repr2valueWithMeta(data);
							break;
						default:
							if (prop.value && prop.value is String && prop.value.indexOf("timestamp") > -1)
								// Time value
								obs.props.push({prop:prop, value:repr2valueWithMeta(data, true)});
							else
								obs.props.push({prop:prop, value:repr2valueWithMeta(data)});
							break;
					}
				}
				else
				{
					logger.error("Error in fromRDF : " + l);
				
				}	
			}
			
			return obs;
		}
		
		
		public static function getObjectFromRDF(rdf: String):Object
		{
			//TODO : support relations
			//TODO : support source obsels
			
			var obs:Object = {uri:null, type:null, props:[]};
			
			var a: Array = null;
			var inData: Boolean = false;
			var listData: Array = null;
			
			for each (var l: String in rdf.split(/\n/))
			{
				l = StringUtil.trim(l);
				if (l == ".")
					break;
				//trace("Processing " + l);
				a = l.match(/(.+)\s+a\s+:(\w+)\s*;/);
				if(a) 
				{
					//we have to deal with the typename (or type uri possibly ?)
					obs.type = repr2valueWithMeta(a[2]);			
					
					
					
					//we potentially get an URI for the Obsel
					if(isReprAnUri(a[1]))
						obs.uri = repr2value(a[1]);
					
					a = null;
					inData = true;
					
					continue;
				}
				if (! inData)
					continue;
				if (listData)
				{
					a=l.match(/(.*)\s*\)\s*;$/);
					if (a)
					{
						// End of list
						if (StringUtil.trim(a[1]).length != 0)
						{
							// There is a last item
							listData.push(repr2valueWithMeta(StringUtil.trim(a[1])));
						}
						listData = null;
						continue;
					}
					listData.push(repr2valueWithMeta(l));
					continue;
				}
				a = l.match(/^(?:ktbs|):has(\w+)\s+(.+?)\s*;?$/);
				if (a)
				{
					/*
					for (var i: int = 0 ; i < a.length ; i++)
					{
					trace("Property " + i + ": " + a[i]);
					}
					*/
					var prop:Object = repr2valueWithMeta(a[1]);
					var data: String = a[2];
					
					if (data == "(")
					{
						// Beginning of a list
						// FIXME: there may be data just after the (, this case is not taken into account here.
						listData = new Array();
						obs.props.push({prop:prop, value:listData});
						continue;
					}
					else 
					{
							if (prop.value && prop.value is String && prop.value.indexOf("timestamp") > -1)							
								obs.props.push({prop:prop, value:repr2valueWithMeta(data, true)});
							else
								obs.props.push({prop:prop, value:repr2valueWithMeta(data)});
							break;
					}
				}
				else
				{
					logger.error("Error in fromRDF : " + l);
					
				}	
			}
			
			return obs;
		}
		
		private static function initObselFromData(odata:Object, parentTrace:StoredTrace, updateModel:Boolean = true, considerTypeNameAsUri:Boolean = false):Obsel
		{
			//TODO : support updateModel with false value


            
            
			if(odata.type && odata.hasOwnProperty("type") && odata.type)
			{
				//Obsel Type
				var obsType:ObselType = null;
				
                var bench_getting_type_timer:Number = new Date().time;
				if(odata.type.isUri || considerTypeNameAsUri )
					obsType = parentTrace.model.get(odata.type.value) as ObselType;
				else
				{
					var correspondingObselTypes:Array = parentTrace.model.getObselTypesByName(odata.type.value);
				
					if(correspondingObselTypes.length > 0)
						obsType = correspondingObselTypes[0]; //To make better
				}
                bench_getting_type += new Date().time - bench_getting_type_timer;
                
                var bench_creating_type_timer:Number = new Date().time;
				if(!obsType) //if a corresponding obsel type has not been found in the trace model
				{
					var newObsTypeUri:String = (odata.type.isUri || considerTypeNameAsUri) ? odata.type.value : null; 
					
					if(updateModel)
						obsType = parentTrace.model.createObselType(newObsTypeUri);
					else
						; //TODO
					
					if(!odata.type.isUri)
						obsType.label = odata.type.value;
				}
                bench_creating_type += new Date().time - bench_creating_type_timer;
				
				//Properties
				var arAttributes:Array = [];
				for each(var pdata:Object in odata.props)
				{
					var atType:AttributeType = null;
                    
                    var bench_getting_Attribut_type_timer:Number = new Date().time;
					if(pdata.prop.isUri  || considerTypeNameAsUri )
						atType = parentTrace.model.get(pdata.prop.value) as AttributeType;
					else
					{
						var correspondingAttributeTypes:Array = parentTrace.model.getAttributeTypesByName(pdata.prop.value);
						
						if(correspondingAttributeTypes.length > 0)
							atType = correspondingAttributeTypes[0]; //To make better
					}
                    bench_getting_Attribut_type += new Date().time - bench_getting_Attribut_type_timer;
					
                    var bench_creating_Attribut_type_timer:Number = new Date().time;
					if(!atType) //if a corresponding attribute type  has not been found in the trace model
					{
						var newAtTypeUri:String = (pdata.prop.isUri  || considerTypeNameAsUri) ? pdata.prop.value : null; 
						
						if(updateModel)
							atType = parentTrace.model.createAttributeType(newAtTypeUri);
						else
							; //TODO
						
						if(!pdata.prop.isUri)
							atType.label = pdata.prop.value;
					}
                    bench_creating_Attribut_type += new Date().time - bench_creating_Attribut_type_timer;
                    
					//We consolid the model
					if(atType.domain != obsType)
					{
						//it is already a dummy abstract type
						
						//or not...
					}
					
					arAttributes.push(new Attribute(atType,pdata.value.value));
				}
					

                var bench_instanciate_obsel_timer:Number = new Date().time;
				var valueToReturn:Obsel = parentTrace.createObsel(obsType, odata.begin.value, odata.end.value, odata.uri, odata.subject.value, arAttributes);   
                bench_instanciate_obsel += new Date().time - bench_instanciate_obsel_timer;
                return valueToReturn;
            }
			
            
            
			return null;
		}
		
		
		
	}
}