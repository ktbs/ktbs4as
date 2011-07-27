package com.ithaca.traces
{
	import flash.events.Event;

	public class ExtensibleResource extends Resource
	{
		internal var _directSubTypes:Array = [];
		internal var _directSuperTypes:Array = [];
		
		public function ExtensibleResource(uri:String=null, uri_attribution_policy:String=null, superTypes:Array = null)
		{
			super(uri, uri_attribution_policy);
			
			if(superTypes)
			{
				for each(var sup:ExtensibleResource in superTypes)
				{
					this.internal_addSupertype(sup);
					
				}
			}
		}
		
		[Bindable(event="directSuperTypesChange")]
		protected function internal_listDirectSupertypes():Array
		{
			return _directSuperTypes;
		}
		
		[Bindable(event="directSubTypesChange")]
		protected function internal_listDirectSubtypes():Array
		{
			return _directSubTypes;
		}
		
		[Bindable(event="superTypesChange")]
		protected function internal_listAllSupertypes():Array
		{
			var ar:Array = [];
			
			for each(var rt:ExtensibleResource in this._directSuperTypes)
			{
				ar = ar.concat(rt.internal_listAllSupertypes());
				
				if(ar.indexOf(rt) < 0)
					ar.push(rt)
				
			}
			
			ar.filter(isUniqueInArray); // remove duplicates
			return ar;
		}
		
		[Bindable(event="subTypesChange")]
		protected function internal_listAllSubtypes():Array
		{
			var ar:Array = [];
			
			for each(var rt:ExtensibleResource in this._directSubTypes)
			{
				ar = ar.concat(rt.internal_listAllSubtypes());
				
				if(ar.indexOf(rt) < 0)
					ar.push(rt)
			}
			
			ar.filter(isUniqueInArray); // remove duplicates
			
			return ar;
		}
		
		protected function internal_addSupertype(rt:ExtensibleResource):void
		{
			if(this._directSuperTypes.indexOf(rt) < 0  && typeof(this) == typeof(rt))
			{
				this._directSuperTypes.push(rt);
				onSuperTypeChange(true);
				
				rt.internal_addSubtype(this);
			}
		}
		
		protected function internal_addSubtype(rt:ExtensibleResource):void
		{
			if(this._directSubTypes.indexOf(rt) < 0 && typeof(this) == typeof(rt))
			{
				this._directSubTypes.push(rt);
				onSubTypeChange(true);
				
				rt.internal_addSupertype(this);
			}
		}
		
		protected function internal_removeSubtype(rt:ExtensibleResource):void
		{
			var i:int = this._directSubTypes.indexOf(rt)
			if(i < 0)
			{
				this._directSubTypes.splice(i,1);
				onSubTypeChange(true);
				
				rt.internal_removeSupertype(this);
			}
		}
		
		protected function internal_removeSupertype(rt:ExtensibleResource):void
		{
			var i:int = this._directSuperTypes.indexOf(rt)
			if(i < 0)
			{
				this._directSuperTypes.splice(i,1);
				onSuperTypeChange(true);
				
				rt.internal_removeSubtype(this);
			}
		}
		
		protected function onSuperTypeChange(direct:Boolean = false):void
		{
			if(direct)
				this.dispatchEvent(new Event("directSuperTypesChange"));
			
			this.dispatchEvent(new Event("superTypesChange"));
			
			for each(var rt:ExtensibleResource in this._directSuperTypes)
				rt.onSuperTypeChange(false);
		}
		
		protected function onSubTypeChange(direct:Boolean = false):void
		{
			if(direct)
				this.dispatchEvent(new Event("directSubTypesChange"));
			
			this.dispatchEvent(new Event("subTypesChange"));
			
			for each(var rt:ExtensibleResource in this._directSubTypes)
				rt.onSubTypeChange(false);
		}
		
		protected function listInheritedProperties(propertyType:Class, propertyContainerName:String, includeOwnProperties:Boolean = false):Array
		{
			var ar:Array = [];
			
			for each(var otp:ExtensibleResource in this._directSuperTypes)
				ar = ar.concat(otp.listInheritedProperties(propertyType,propertyContainerName,true));
				
			if(includeOwnProperties && this[propertyContainerName] != null && this[propertyContainerName] is Array)
			{
				for each(var at:* in this[propertyContainerName])
					if(at is propertyType)
						ar.push(at);
			}
			
			ar.filter(isUniqueInArray); // remove duplicates
			
			return ar;	
		}
		
		protected function onPropertyChange(directPropertyMessage:String, indirectPropertyMessage:String, direct:Boolean = false):void
		{
			if(direct)
				this.dispatchEvent(new Event(directPropertyMessage));
			else
				this.dispatchEvent(new Event(indirectPropertyMessage));
			
			for each(var rt:ExtensibleResource in this._directSubTypes)
				rt.onPropertyChange(directPropertyMessage, indirectPropertyMessage, false);
		}
		
		
		private  function isUniqueInArray(item:*, index:int, array:Array):Boolean 
		{
			return array.indexOf(item,index + 1) == -1;
		};


		

	}
}