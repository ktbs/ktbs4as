package com.ithaca.traces
{
	public class ObselType extends ExtensibleResource
	{
		protected var _model:Model;
		
		protected var _directAttributeTypes:Array;
		protected var _directOutcomingRelationsTypes:Array;
		protected var _directIncomingRelationsTypes:Array;
		
		public function ObselType(model:Model, superTypes:Array, uri:String=null, uri_attribution_policy:String = null)
		{
			super(uri, uri_attribution_policy,superTypes);
			_model = model;	
		}
		
		public function get model():Model
		{
			return _model;
		}
		
		public function addSubtype(rt:ObselType):void
		{
			this.internal_addSubtype(rt);
		}
		
		public function addSupertype(rt:ObselType):void
		{
			this.internal_addSupertype(rt);
		}
		
		public function removeSubtype(rt:ObselType):void
		{
			this.internal_removeSubtype(rt);
		}
		
		public function removeSupertype(rt:ObselType):void
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
		
		public function listAttributeTypes(include_inherited:Boolean = true):Array
		{
			if(include_inherited == false)
				return _directAttributeTypes;
			else
			{
				return listInheritedProperties(AttributeType,"_directAttributeTypes",true);
			}
		}
		
		public function listIncomingRelationsTypes(include_inherited:Boolean = true):Array
		{
			if(include_inherited == false)
				return _directIncomingRelationsTypes;
			else
			{
				return listInheritedProperties(RelationType,"_directIncomingRelationsTypes",true);
			}
		}
		
		public function listOutcomingRelationsTypes(include_inherited:Boolean = true):Array
		{
			if(include_inherited == false)
				return _directOutcomingRelationsTypes;
			else
			{
				return listInheritedProperties(RelationType,"_directOutcomingRelationsTypes",true);
			}
		}
		
		public function createAttributeType(uri:String = null, range:String = null, range_is_list:Boolean = false):AttributeType
		{
			//TODO : check if uri not taken and similar type not already declared
			var at:AttributeType = _model.createAttributeType(uri, this, range, range_is_list);
			this._directAttributeTypes.push(at);
			return at;
		}
		
		public function createRelationType(uri:String = null, range:ObselType = null, supertypes:Array = null):RelationType
		{
			//TODO : check if uri not taken and similar type not already declared
			var rt:RelationType = _model.createRelationType(uri,this,range,supertypes);
			this._directOutcomingRelationsTypes.push(rt);
			return rt;
		}
	}
}