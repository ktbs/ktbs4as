package com.ithaca.traces
{
	import flash.events.Event;

	public class StoredTrace extends Trace
	{
		protected var _defaultSubject:String;
		
		public function StoredTrace(base:Base, model:Model, origin:String = null, defaultSubject:String = null, uri:String = null, uri_attribution_policy:String = null)
		{
			super(base,model,origin,uri,uri_attribution_policy);
			this._defaultSubject = defaultSubject;
			
		}
		
		public function set origin(value:String):void
		{
			if( _origin !== value)
			{
				//TODO
				_origin = value;
				dispatchEvent(new Event("originChange"));
			}
		}
		
		public function set model(value:Model):void
		{
			if( _model !== value)
			{
				//TODO
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
							begin:Number,
							end:Number = NaN,
							uri:String = null,
							subject:String = null,
							attributes:Array = null,
							relations:Array = null,
							inverse_relations:Array = null,
							source_obsels:Array = null):Obsel
		{
			//TODO
			return new Obsel();
		}
	}
}