package com.ithaca.traces
{
	import flash.events.Event;

	public class RelationType extends ExtensibleResource
	{
		protected var _model:Model;
		protected var _domain:ObselType;
		protected var _range:ObselType;
	
		public function RelationType(model:Model, domain:ObselType = null, range:ObselType = null, superTypes:Array = null, uri:String=null, uri_attribution_policy:String = null)
		{
			super(uri, uri_attribution_policy,superTypes);
			
			_model = model;
			_domain = domain;
			_range = range;
		}

		public function get model():Model
		{
			return _model;
		}
		

		public function get range():ObselType
		{
			return _range;
		}
		
		public function setRange(value:ObselType):void
		{
			_range = value;
		}
		
		public function get domain():ObselType
		{
			return _domain;
		}
		
		public function setDomain(value:ObselType):void
		{
			_domain = value;
		}
		
		public function addSubtype(rt:RelationType):void
		{
			this.internal_addSubtype(rt);
		}
		
		public function addSupertype(rt:RelationType):void
		{
			this.internal_addSupertype(rt);
		}
		
		public function removeSubtype(rt:RelationType):void
		{
			this.internal_removeSubtype(rt);
		}
		
		public function removeSupertype(rt:RelationType):void
		{
			this.internal_removeSupertype(rt);
		}
		
		[Bindable(event="directSuperTypesChange")]
		public function listDirectSupertypes():Array
		{
			return internal_listDirectSupertypes();
		}
		
		[Bindable(event="directSubTypesChange")]
		public function listDirectSubtypes():Array
		{
			return internal_listDirectSubtypes();
		}
		
		[Bindable(event="superTypesChange")]
		public function listAllSupertypes():Array
		{
			return internal_listAllSupertypes();
		}
		
		[Bindable(event="subTypesChange")]
		public function listAllSubtypes():Array
		{
			return internal_listAllSubtypes();
		}

	}
}