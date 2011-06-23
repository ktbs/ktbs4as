package com.ithaca.traces
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectProxy;

	public class Obsel extends Resource
	{
		protected var _trace:Trace;
		protected var _obselType:ObselType;
		
		protected var _begin:int;
		protected var _end:int;
		
		protected var _subject:String;
		
		protected var arSourceObsels:ArrayCollection = new ArrayCollection();
		
		protected var mapAttribute:Dictionary = new Dictionary();	
		protected var _attributes:ArrayCollection = new ArrayCollection();
		
		protected var mapOutcomingRelations:Dictionary = new Dictionary();
		protected var mapIncomingRelations:Dictionary = new Dictionary();
		protected var _incomingRelations:ArrayCollection = new ArrayCollection();
		protected var _outcomingRelations:ArrayCollection = new ArrayCollection();
		
		public function Obsel(trace:Trace,
							  type:ObselType,
							  begin:Number,
							  end:Number = NaN,
							  uri:String = null,
							  subject:String = null,
							  attributes:Array = null,
							  relations:Array = null,
							  inverse_relations:Array = null,
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

		[Bindable(event="beginChange")]
		public function get begin():int
		{
			return _begin;
		}

		public function set begin(value:int):void
		{
			if( _begin !== value)
			{
				_begin = value;
				dispatchEvent(new Event("beginChange"));
			}
		}

		[Bindable(event="endChange")]
		public function get end():int
		{
			return _end;
		}

		public function set end(value:int):void
		{
			if( _end !== value)
			{
				_end = value;
				dispatchEvent(new Event("endChange"));
			}
		}

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
		
		
		public function getRelatedObsels(rt:RelationType):Array
		{	
			if(this.mapOutcomingRelations.hasOwnProperty(rt))
				return (this.mapIncomingRelations[rt] as Array)
			
			return null;	
		}
		
		public function getRelatingObsels(rt:RelationType):Array
		{	
			if(this.mapIncomingRelations.hasOwnProperty(rt))
				return (this.mapOutcomingRelations[rt] as Array)
			
			return null;	
		}
		
		public function getIncomingRelations(rt:RelationType):Array
		{
			if(this.mapIncomingRelations.hasOwnProperty(rt) && this.mapIncomingRelations[rt] != null && this.mapIncomingRelations[rt] is Array)
				return this.mapIncomingRelations[rt];
			
			return [];
		}
		
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
				
				this.outcomingRelations.addItem(newRelation);
				
				if(this.mapOutcomingRelations.hasOwnProperty(rt) && this.mapOutcomingRelations[rt] != null)
					(this.mapOutcomingRelations[rt] as Array).push(newRelation);
				else
				{
					this.mapOutcomingRelations[rt] = [newRelation];
					this.dispatchEvent(new Event("outcomingRelationTypesChange"));
				}
				
				
				this.dispatchEvent(new Event("outcomingRelationsChange"));
				
				
				targetObsel.registerIncomingRelation(newRelation);
			}
		}
		
		public function registerIncomingRelation(rel:Relation):void
		{
			var alreadyExist:Boolean = false;
			
			for each(var aRelation:Relation in this.getIncomingRelations(rel.relationType))
				if(aRelation.originObsel == rel.originObsel)
					alreadyExist = true;
			
			if(!alreadyExist)
			{ 
				
				this.incomingRelations.addItem(rel);
				
				if(this.mapIncomingRelations.hasOwnProperty(rel.relationType) && this.mapIncomingRelations[rel.relationType] != null)
					(this.mapIncomingRelations[rel.relationType] as Array).push(rel);
				else
				{
					this.mapIncomingRelations[rel.relationType] = [rel];
					this.dispatchEvent(new Event("incomingRelationTypesChange"));
				}
				
				this.dispatchEvent(new Event("incomingRelationsChange"));
				
			}
			
		}
		
		public function unregisterIncomingRelation(rel:Relation):void
		{
			var rels:Array = this.getIncomingRelations(rel.relationType);
			
			for(var i:uint = 0; i < rels.length; i++)
			{
				var aRelation:Relation = rels[i] as Relation;
				
				if(aRelation.originObsel == rel.originObsel)
				{	
					this.incomingRelations.removeItemAt(this.incomingRelations.getItemIndex(aRelation));
					this.dispatchEvent(new Event("incomingRelationsChange"));	
					
					rels.splice(i,1);
					if(rels.length == 0)
					{
						delete this.mapIncomingRelations[rel.relationType];
						this.dispatchEvent(new Event("incomingRelationTypesChange"));
					}
				}
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
					targetObsel.unregisterIncomingRelation(aRelation);
					
					this.outcomingRelations.removeItemAt(this.outcomingRelations.getItemIndex(aRelation));
					this.dispatchEvent(new Event("outcomingRelationsChange"));
					
					
					rels.splice(i,1);
					if(rels.length == 0)
					{
						delete this.mapOutcomingRelations[rt];
						this.dispatchEvent(new Event("outcomingRelationTypesChange"));
					}
				}
			}
		}
	}
}