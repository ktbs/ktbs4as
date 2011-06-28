package com.ithaca.traces
{
	public class AttributeType extends Resource
	{	
		protected var _model:Model;
		protected var _domain:ObselType;
		protected var _range:String;
		protected var _isRangeList:Boolean;
		
		public function AttributeType(model:Model, domain:ObselType = null, range:String = null, range_is_list:Boolean = false, uri:String=null, uri_attribution_policy:String = null)
		{
			super(uri, uri_attribution_policy);
			
			_model = model;
			_range = range;
			this.setDomain(domain)
			_isRangeList = range_is_list;
		}

		public function get isRangeList():Boolean
		{
			return _isRangeList;
		}

		public function get range():String
		{
			return _range;
		}

		public function setRange(value:String, isList:Boolean = false):void
		{
			_range = value;
			_isRangeList = isList;
		}

		public function get domain():ObselType
		{
			return _domain;
		}

		public function setDomain(value:ObselType):void
		{
			if(_domain != value)
			{
				if(_domain)
					_domain.unRegisterAttributeType(this);
				
				_domain = value;
				
				if(_domain)
					_domain.registerAttributeType(this);
			}	
		}

		public function get model():Model
		{
			return _model;
		}
	}
}