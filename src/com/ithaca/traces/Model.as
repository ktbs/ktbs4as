package com.ithaca.traces
{
	public class Model extends ExtensibleResource
	{
		protected var _base:Base;
		
		internal var _directAttributeTypes:Array;
		internal var _directRelationTypes:Array;
		internal var _directObselTypes:Array;
		
		internal var _unit:String;
		internal var _readOnly:Boolean;
		
		public function Model(base:Base, uri:String=null, uri_attribution_policy:String = null)
		{
			super(uri, uri_attribution_policy);
			_base = base;
			
			_directAttributeTypes = new Array();
			_directRelationTypes = new Array();
			_directObselTypes = new Array();
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
			_unit = value;
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
			this.onPropertyChange("listObselTypesChange","listObselTypesChange",true);
			return ot;
		}

		public function createAttributeType(uri:String = null, domain:ObselType = null, range:String = null, range_is_list:Boolean = false):AttributeType
		{
			//TODO : check if uri not taken and similar type not already declared
			var at:AttributeType = new AttributeType(this, domain, range, range_is_list, uri,this.uri_attribution_policy);
			this._directAttributeTypes.push(at);
			this.onPropertyChange("listAttributeTypesChange","listAttributeTypesChange",true);
			return at;
		}
		
		public function createRelationType(uri:String = null, domain:ObselType = null, range:ObselType = null, supertypes:Array = null):RelationType
		{
			//TODO : check if uri not taken and similar type not already declared
			var rt:RelationType = new RelationType(this,domain,range,supertypes,uri,this.uri_attribution_policy);
			this._directRelationTypes.push(rt);
			this.onPropertyChange("listRelationTypesChange","listRelationTypesChange",true);
			return rt;
		}
		
		[Bindable(event="listAttributeTypesChange")]
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
		
		[Bindable(event="listAttributeTypesChange")]
		public function getAttributeTypesByName(name:String, include_inherited:Boolean = true):Array
		{
			var returnAr:Array = [];
			for each (var atType:AttributeType in this.listAttributeTypes(include_inherited))
			{
				if(atType.label == name)
					returnAr.push(atType);
			}
			
			return returnAr; 
		}
		
		[Bindable(event="listRelationTypesChange")]
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
		
		[Bindable(event="listObselTypesChange")]
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
		
		[Bindable(event="listObselTypesChange")]
		public function getObselTypesByName(name:String, include_inherited:Boolean = true):Array
		{
			var returnAr:Array = [];
			for each (var obsType:ObselType in this.listObselTypes(include_inherited))
			{
				if(obsType.label == name)
					returnAr.push(obsType);
			}
			
			return returnAr; 
		}
		
		public function addInherited(m:Model):void
		{
			this.internal_addSupertype(m);
			this.onPropertyChange("listInheritedChange","listInheritedChange",true);
	
		}
		
		public function removeInherited(m:Model):void
		{
			this.internal_removeSupertype(m);
			this.onPropertyChange("listInheritedChange","listInheritedChange",true);
		}
		
		public function get(uri:String):Resource
		{
			//TODO : more performant implementation
			
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