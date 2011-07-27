package com.ithaca.traces
{
	import com.ithaca.traces.services.ITraceService;
	
	import flash.events.Event;

	public class StoredTrace extends Trace
	{
		internal var _defaultSubject:String;
		
		public function StoredTrace(base:Base, model:Model, defaultSubject:String = null, origin:String = null, uri:String = null, uri_attribution_policy:String = null)
		{
			super(base,model,origin,uri,uri_attribution_policy);
			this._defaultSubject = defaultSubject;
			
		}
		
		public function set origin(value:String):void
		{
			if( _origin !== value)
			{
				//TODO :implementation
				_origin = value;
				dispatchEvent(new Event("originChange"));
			}
		}
		
		public function set model(value:Model):void
		{
			if( _model !== value)
			{
				//TODO : implementation
				_model = value;
				dispatchEvent(new Event("modelChange"));
			}
		}

		public function get defaultSubject():String
		{
			return _defaultSubject;
		}

		public function set defaultSubject(value:String):void
		{
			_defaultSubject = value;
		}

		public function createObsel( type:ObselType,
							begin:Number = NaN,
							end:Number = NaN,
							uri:String = null,
							subject:String = null,
							attributes:Array = null,
							relations:Array = null,
							inverse_relations:Array = null,
							source_obsels:Array = null):Obsel
		{
			//TODO : check if uri not taken
			if(subject == null)
				subject = this.defaultSubject;
			
			if(isNaN(begin))
				begin = new Date().time;
			
			var o:Obsel = new Obsel(this,type,begin,end,uri,subject,attributes,relations,source_obsels);
			
			this._arObsels.addItem(o);
			
			//TODO : MAKE CLEANER
			for each(var s:ITraceService in  this.services)
				s.addObsel(o);
			
			return o;
		}
	}
}