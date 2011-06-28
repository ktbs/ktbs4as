package com.ithaca.traces
{
	public class Model extends ExtensibleResource
	{
		protected var _base:Base;
		
		protected var _directAttributeTypes:Array;
		protected var _directRelationTypes:Array;
		protected var _directObselTypes:Array;
		
		protected var _unit:String;
		protected var _readOnly:Boolean;
		
		public function Model(uri:String=null, uri_attribution_policy:String = null)
		{
			super(uri, uri_attribution_policy);
		}
		
		public function get readOnly():Boolean
		{
			return _readOnly;
		}

		public function get base():Base
		{
			return _base;
		}

		public function get unit():String
		{
			return _unit;
		}

		public function set unit(value:String):void
		{
			//_unit = value;
			//TODO
		}

		
		[Bindable(event="listInheritedChange")]
		public function listInherited(include_inherited:Boolean = true):Array
		{
			if(include_inherited)
				return internal_listAllSupertypes();
			else
				return internal_listDirectSupertypes();
		}
	
		public function createObselType(uri:String = null, supertypes:Array = null):ObselType
		{
			//TODO : check if uri not taken and similar type not already declared
			var ot:ObselType = new ObselType(this, supertypes,uri,this.uri_attribution_policy);
			this._directObselTypes.push(ot);
			return ot;
		}

		public function createAttributeType(uri:String = null, domain:ObselType = null, range:String = null, range_is_list:Boolean = false):AttributeType
		{
			//TODO : check if uri not taken and similar type not already declared
			var at:AttributeType = new AttributeType(this, domain, range, range_is_list, uri,this.uri_attribution_policy);
			this._directAttributeTypes.push(at);
			return at;
		}
		
		public function createRelationType(uri:String = null, domain:ObselType = null, range:ObselType = null, supertypes:Array = null):RelationType
		{
			//TODO : check if uri not taken and similar type not already declared
			var rt:RelationType = new RelationType(this,domain,range,supertypes,uri,this.uri_attribution_policy);
			this._directRelationTypes.push(rt);
			return rt;
		}
		
		public function listAttributeTypes(include_inherited:Boolean = true):Array
		{
			//TODO : make the result of this function bindable
			if(include_inherited == false)
				return _directAttributeTypes;
			else
			{
				return listInheritedProperties(AttributeType,"_directAttributeTypes",true);
			}
		}
		
		public function listRelationTypes(include_inherited:Boolean = true):Array
		{
			//TODO : make the result of this function bindable
			if(include_inherited == false)
				return _directAttributeTypes;
			else
			{
				return listInheritedProperties(RelationType,"_directRelationTypes",true);
			}
		}
		
		public function listObselTypes(include_inherited:Boolean = true):Array
		{
			//TODO : make the result of this function bindable
			if(include_inherited == false)
				return _directAttributeTypes;
			else
			{
				return listInheritedProperties(ObselType,"_directObselTypes",true);
			}
		}
		
		public function addInherited(m:Model):void
		{
			this.internal_addSupertype(m);
		}
		
		public function removeInherited(m:Model):void
		{
			this.internal_removeSupertype(m);
		}
		
		public function get(uri:String):Resource
		{
			//TODO : better
			
			for each(var elt:Resource in this.listAttributeTypes())
				if(elt.uri == uri)
					return elt;
			
			for each(var elt2:Resource in this.listObselTypes())
				if(elt2.uri == uri)
					return elt2;
			
			for each(var elt3:Resource in this.listRelationTypes())
				if(elt3.uri == uri)
					return elt3;
			
			return null;
				
		}
		
		
	}
}