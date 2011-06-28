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
		
		[Bindable(event="listAttributeTypesChange")]
		public function listAttributeTypes(include_inherited:Boolean = true):Array
		{
			if(include_inherited == false)
				return _directAttributeTypes;
			else
			{
				return listInheritedProperties(AttributeType,"_directAttributeTypes",true);
			}
		}
		
		[Bindable(event="listIncomingRelationTypesChange")]
		public function listIncomingRelationTypes(include_inherited:Boolean = true):Array
		{
			if(include_inherited == false)
				return _directIncomingRelationsTypes;
			else
			{
				return listInheritedProperties(RelationType,"_directIncomingRelationsTypes",true);
			}
		}
		
		[Bindable(event="listOutcomingRelationTypesChange")]
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
			//here the constructor of the attributeType order the registration of the new attributeType in domain obselTypes
			return at;
		}
		
		public function createRelationType(uri:String = null, range:ObselType = null, supertypes:Array = null):RelationType
		{
			//TODO : check if uri not taken and similar type not already declared
			var rt:RelationType = _model.createRelationType(uri,this,range,supertypes);
			//here the constructor of the relationType order the registration of the new relationType in both range and domain obselTypes
			return rt;
		}
		
		public function registerAttributeType(at:AttributeType, silent:Boolean = false):void //called by AttributeType when its domain changes
		{
			if(this._directAttributeTypes.indexOf(at) < 0)
			{
				this._directAttributeTypes.push(at);
				if(!silent) this.onPropertyChange("listAttributeTypesChange","listAttributeTypesChange",true);
			}
		}
		
		public function unRegisterAttributeType(rt:AttributeType, silent:Boolean = false):void //called by AttributeType when its domain changes
		{
			var pos:int = this._directAttributeTypes.indexOf(rt); 
			if(pos > 0)
			{
				this._directAttributeTypes.splice(pos,1);
				if(!silent) this.onPropertyChange("listAttributeTypesChange","listAttributeTypesChange",true);
			}
		}
		
		public function registerRelationType(rt:RelationType, silent:Boolean = false):void //called by RelationType when its domain or range changes
		{
			var incoming:Boolean;
			
			if(rt.domain == this)
				incoming = false;
			else if(rt.range == this)
				incoming = true;
			else
				return;
			
			var arrayOfRelations:Array = incoming ? this._directIncomingRelationsTypes : this._directOutcomingRelationsTypes;
			var message:String = incoming ? "listIncomingRelationTypesChange" : "listOutcomingRelationTypesChange";
			
			if(arrayOfRelations.indexOf(rt) < 0)
			{
				arrayOfRelations.push(rt);
				if(!silent) this.onPropertyChange(message,message,true);
			}
		}
		
		public function unRegisterRelationType(rt:RelationType, silent:Boolean = false):void //called by RelationType when its domain or range changes
		{
			var incoming:Boolean;
			
			if(rt.domain == this)
				incoming = false;
			else if(rt.range == this)
				incoming = true;
			else
				return;
			
			var arrayOfRelations:Array = incoming ? this._directIncomingRelationsTypes : this._directOutcomingRelationsTypes;
			var message:String = incoming ? "listIncomingRelationTypesChange" : "listOutcomingRelationTypesChange";
			
			var pos:int = arrayOfRelations.indexOf(rt); 
			if( pos > 0)
			{
				arrayOfRelations.splice(pos,1);
				if(!silent) this.onPropertyChange(message,message,true);
			}
		}
	}
}