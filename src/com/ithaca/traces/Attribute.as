package com.ithaca.traces
{
	import flash.events.Event;
	
	import mx.utils.ObjectProxy;
	
	public class Attribute extends ObjectProxy
	{
		protected var _attributeType:AttributeType;
		protected var _value:*;
		protected var _obselParent:Obsel;
		public function Attribute(attributeType:AttributeType, value:* = null, obselParent:Obsel = null)
		{
			this._obselParent = obselParent;
			this._attributeType = attributeType;
			this._value = value;
		}

		public function get obselParent():Obsel
		{
			return _obselParent;
		}
		
		
		public function set obselParent(value:Obsel):void
		{
			_obselParent = value;
		}
		
		public function get attributeType():AttributeType
		{
			return _attributeType;
		}

		[Bindable(event="valueChange")]
		public function get value():*
		{
			return _value;
		}

		public function set value(value:*):void
		{
			if( _value !== value)
			{
				_value = value;
				
				dispatchEvent(new Event("valueChange"));
			}
		}
	}
}