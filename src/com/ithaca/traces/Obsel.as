package com.ithaca.traces
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectProxy;

	public class Obsel extends Resource
	{
		internal var _trace:Trace;
		internal var _obselType:ObselType;
		
		internal var _begin:Number;
		internal var _end:Number;
		
		internal var _subject:String;
		
		internal var arSourceObsels:ArrayCollection = new ArrayCollection();
		
		internal var mapAttribute:Dictionary = new Dictionary();	
		internal var _attributes:ArrayCollection = new ArrayCollection();
		
		internal var mapOutcomingRelations:Dictionary = new Dictionary();
		internal var mapIncomingRelations:Dictionary = new Dictionary();
		internal var _incomingRelations:ArrayCollection = new ArrayCollection();
		internal var _outcomingRelations:ArrayCollection = new ArrayCollection();
		
		public function Obsel(trace:Trace,
							  type:ObselType,
							  begin:Number,
							  end:Number = NaN,
							  uri:String = null,
							  subject:String = null,
							  attributes:Array = null,
							  relations:Array = null,
							  source_obsels:Array = null)
		{
			
			super(uri, trace.uri_attribution_policy);
			
			//Trace, ObselType, Begin, End
			this._trace = trace;
			this._obselType = type;
			this._begin = begin;
			this._end = end;
			
			//Subject
			this._subject = subject;
			if(this._subject == null && this._trace is StoredTrace)
				this._subject = (this._trace as StoredTrace).defaultSubject;
			
			//Attributes
			for each(var a:Attribute in attributes)
				this.registerAttribute(a,false,true);
				
			//Relations
			for each(var r:Relation in relations)
				this.registerRelation(r,true);
				
			//Source Obsels
			for each(var os:Obsel in source_obsels)
				this.arSourceObsels.addItem(os);
			
		}

		public function get trace():Trace
		{
			return _trace;
		}

		public function get obselType():ObselType
		{
			return _obselType;
		}

		[Bindable]
		public function get begin():Number
		{
			return _begin;
		}

		public function set begin(value:Number):void
		{
			if( _begin !== value)
			{
				_begin = value;
			}
		}

		[Bindable]
		public function get end():Number
		{
			if(isNaN(_end))
				return _begin;
			else
				return _end;
		}

		public function set end(value:Number):void
		{
			if( _end !== value)
			{
				_end = value;
			}
		}

		[Bindable]
		public function get subject():String
		{
			return _subject;
		}

		public function set subject(value:String):void
		{
			_subject = value;
		}

		[Bindable]
		public function listSourceObsels():ArrayCollection
		{
			return arSourceObsels;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////			ATTRIBUTE 									////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		[Bindable(event="attributesChange")]
		public function get attributes():ArrayCollection
		{
			//TODO : check if the binding is working ok
			return _attributes;
		}
		
		[Bindable(event="attributeTypesChange")]
		public function listAttributeTypes():Array
		{
			var toReturn:Array = [];	
			for(var key:Object in this.mapAttribute)
				toReturn.push(key);
			return toReturn;
		}		
		
		public function getAttribute(at:AttributeType):Attribute
		{
			if(this.mapAttribute.hasOwnProperty(at) && this.mapAttribute[at] != null)
				return (this.mapAttribute[at] as Attribute);
			
			return null;
		}
		
		public function getAttributeValue(at:AttributeType):*
		{
			if(this.mapAttribute.hasOwnProperty(at) && this.mapAttribute[at]  != null)
				return (this.mapAttribute[at] as Attribute).value;
			
			return null;
		}
		
		public function getAttributeValueByTypeUri(uri:String):*
		{
			return getAttributeValue(trace.model.get(uri) as AttributeType);
		}
        
        public function getAttributeValueByLabel(label:String):*
        {
            for each(var at:Attribute in _attributes)
            {
                //TODO : check if wa consider here attributes types of parents obsel types.
                if(at.attributeType.label == label)
                    return this.getAttributeValueByTypeUri(at.attributeType.uri);
            }
            
            return null;
        }
		
		public function setAttributeValue(at:AttributeType, value:*):void
		{
			if(this.getAttribute(at))
				this.getAttribute(at).value = value
			else
				registerAttribute(new Attribute(at,value,this));
		}
		
		protected function registerAttribute(newAttribute:Attribute, overwrite:Boolean = false, silent:Boolean = false):void
		{
			// if an attribute exist already for this type
			if(this.getAttribute(newAttribute.attributeType))
				if(overwrite)
					this.delAttribute(this.getAttribute(newAttribute.attributeType), true)
				else
					return;
			
			//Registration
			
			newAttribute.obselParent = this;
			
			this._attributes.addItem(newAttribute);
			
			var newAttributeType:Boolean = false;
			if(this.mapAttribute.hasOwnProperty(newAttribute.attributeType) && this.mapAttribute[newAttribute.attributeType])
				newAttributeType = true;
			
			this.mapAttribute[newAttribute.attributeType] = newAttribute;

			
			//Event dispatching
			if(!silent)
			{
				if(newAttributeType)
					this.dispatchEvent(new Event("attributeTypesChange"));
				
				this.dispatchEvent(new Event("attributesChange"));
			}
		}
		
		public function delAttributeValue(at:AttributeType):void
		{
			if(this.getAttribute(at))
				delAttribute(this.getAttribute(at));
		}
		
		public function delAttribute(theAttribute:Attribute, silent:Boolean = false):void
		{
			if(this._attributes.getItemIndex(theAttribute) >= 0)
			{
				this._attributes.removeItemAt(this._attributes.getItemIndex(theAttribute));
				if(!silent) this.dispatchEvent(new Event("attributesChange"));
			}
			
			if(this.getAttribute(theAttribute.attributeType))
			{
				theAttribute = null;
				delete this.mapAttribute[theAttribute.attributeType];
				if(!silent) this.dispatchEvent(new Event("attributeTypesChange"));
			}
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////			RELATION 									////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		[Bindable(event="incomingRelationsChange")]
		public function get incomingRelations():ArrayCollection
		{
			return _incomingRelations;
		}
		
		[Bindable(event="outcomingRelationsChange")]
		public function get outcomingRelations():ArrayCollection
		{
			return _outcomingRelations;
		}

		[Bindable(event="incomingRelationTypesChange")]
		public function listIncomingRelationTypes():Array
		{
			var toReturn:Array = [];	
			
			for(var key:Object in this.mapIncomingRelations)
					toReturn.push(key);
			
			return toReturn;
		}
		
		[Bindable(event="outcomingRelationTypesChange")]
		public function listOutcomingRelationTypes():Array
		{
			var toReturn:Array = [];	
			
			for(var key:Object in this.mapOutcomingRelations)
					toReturn.push(key);
			
			return toReturn;
		}
		
		[Bindable(event="outcomingRelationsChange")]
		public function listRelatedObsels(rt:RelationType):Array
		{	
			var ar:Array = [];
			for each(var rel:Relation in this.getOutcomingRelations(rt))
				ar.push(rel.targetObsel);
			
			return ar;	
		}
		
		[Bindable(event="incomingRelationsChange")]
		public function listRelatingObsels(rt:RelationType):Array
		{	
			var ar:Array = [];
			for each(var rel:Relation in this.getIncomingRelations(rt))
				ar.push(rel.originObsel);
			
			return ar;	
		}
		
		[Bindable(event="incomingRelationsChange")]
		public function getIncomingRelations(rt:RelationType):Array
		{
			if(this.mapIncomingRelations.hasOwnProperty(rt) && this.mapIncomingRelations[rt] != null && this.mapIncomingRelations[rt] is Array)
				return this.mapIncomingRelations[rt];
			
			return [];
		}
		
		[Bindable(event="outcomingRelationsChange")]
		public function getOutcomingRelations(rt:RelationType):Array
		{
			if(this.mapOutcomingRelations.hasOwnProperty(rt) && this.mapOutcomingRelations[rt] != null && this.mapOutcomingRelations[rt] is Array)
				return this.mapOutcomingRelations[rt];
			
			return [];
		}
		
		
		public function addRelatedObsel(rt:RelationType, targetObsel:Obsel):void //add 
		{
			var alreadyExist:Boolean = false;
			
			for each(var aRelation:Relation in this.getOutcomingRelations(rt))
				if(aRelation.targetObsel == targetObsel)
					alreadyExist = true;
			
			if(!alreadyExist)
			{
				var newRelation:Relation = new Relation(rt,this,targetObsel); 
				
				this.registerRelation(newRelation)
				
				targetObsel.registerRelation(newRelation);
			}
		}
		
		
		public function delRelatedObsel(rt:RelationType, targetObsel:Obsel):void //add 
		{			
			var rels:Array = this.getOutcomingRelations(rt);
			
			for(var i:uint = 0; i < rels.length; i++)
			{
				var aRelation:Relation = rels[i] as Relation;
				
				if(aRelation.targetObsel == targetObsel)
				{
					this.unregisterRelation(aRelation);
					
					targetObsel.unregisterRelation(aRelation);
					
					return;
				}
			}
		}

		
		public function registerRelation(rel:Relation, silent:Boolean = false):void //should be private
		{
			
			//the relation is maybe not completely initialized  
			if(rel.originObsel == null && rel.targetObsel != null && rel.targetObsel != this)
				rel.originObsel = this;
			else if(rel.targetObsel == null && rel.originObsel != null && rel.originObsel != this)
				rel.targetObsel = this;
			else
				return; //Error
			
			//is the relation incoming or outcoming ?
			var incoming:Boolean;			
			if(rel.originObsel == this)
				incoming = false;
			else if(rel.targetObsel == this)
				incoming = true;
			else
				return; //Error
		
			//Searching if a similar relation is not already registered 
			var alreadyExist:Boolean = false;
			var typeRelations:Array = incoming ? this.getIncomingRelations(rel.relationType) : this.getOutcomingRelations(rel.relationType);
			
			for each(var aRelation:Relation in typeRelations)
				if((incoming && aRelation.originObsel == rel.originObsel) || (!incoming && aRelation.targetObsel == rel.targetObsel)  )
					alreadyExist = true;
			
			//if nothing is found
			if(!alreadyExist)
			{ 
				var relationTypesChangeEventMessage:String = incoming ? "incomingRelationTypesChange" : "outcomingRelationTypesChange";
				var relationsChangeEventMessage:String = incoming ? "incomingRelationsChange" : "outcomingRelationsChange";
				var mapRelations:Dictionary = incoming ? this.mapIncomingRelations : this.mapOutcomingRelations;
				var arRelations:ArrayCollection = incoming ? this.incomingRelations : this.outcomingRelations;
				
				arRelations.addItem(rel);
				
				if(mapRelations.hasOwnProperty(rel.relationType) && mapRelations[rel.relationType] != null)
					(mapRelations[rel.relationType] as Array).push(rel);
				else
				{
					mapRelations[rel.relationType] = [rel];
					if(!silent) this.dispatchEvent(new Event(relationTypesChangeEventMessage));
				}
				
				if(!silent) this.dispatchEvent(new Event(relationsChangeEventMessage));
				
			}
			
		}
		
		public function unregisterRelation(rel:Relation, silent:Boolean = false):void //should be private
		{
			//is the relation incoming or outcoming ?
			var incoming:Boolean;			
			if(rel.originObsel == this)
				incoming = false;
			else if(rel.targetObsel == this)
				incoming = true;
			else
				return;
			
			
			var relationTypesChangeEventMessage:String = incoming ? "incomingRelationTypesChange" : "outcomingRelationTypesChange";
			var relationsChangeEventMessage:String = incoming ? "incomingRelationsChange" : "outcomingRelationsChange";
			var mapRelations:Dictionary = incoming ? this.mapIncomingRelations : this.mapOutcomingRelations;
			var arRelations:ArrayCollection = incoming ? this.incomingRelations : this.outcomingRelations;
			var typeRelations:Array = incoming ? this.getIncomingRelations(rel.relationType) : this.getOutcomingRelations(rel.relationType);
			
			for(var i:uint = 0; i < typeRelations.length; i++)
			{
				var aRelation:Relation = typeRelations[i] as Relation;
				
				if((incoming && aRelation.originObsel == rel.originObsel) || (!incoming && aRelation.targetObsel == rel.targetObsel))
				{	
					arRelations.removeItemAt(arRelations.getItemIndex(aRelation));
					if(!silent) this.dispatchEvent(new Event(relationsChangeEventMessage));	
					
					typeRelations.splice(i,1);
					if(typeRelations.length == 0)
					{
						delete mapRelations[rel.relationType];
						if(!silent) this.dispatchEvent(new Event(relationTypesChangeEventMessage));
					}
				}
			}
		}
		
		public function incomingRelationChange(changingRelation:Relation):void //should be private
		{
			this.dispatchEvent(new Event("incomingRelationsChange"));
		}
		
		public function outcomingRelationChange(changingRelation:Relation):void //should be private
		{
			this.dispatchEvent(new Event("outcomingRelationsChange"));
		}
	
	}
}