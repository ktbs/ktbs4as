package com.ithaca.traces
{
	import flash.events.Event;
	
	import mx.utils.ObjectProxy;
	
	public class Relation extends ObjectProxy
	{
		protected var _relationType:RelationType;
		protected var _originObsel:Obsel;
		protected var _targetObsel:Obsel;
		
		public function Relation(relationType:RelationType, originObsel:Obsel = null, targetObsel:Obsel = null)
		{
			this._relationType = relationType;
			this._originObsel = originObsel;
			this._targetObsel = targetObsel;
		}

		public function get relationType():RelationType
		{
			return _relationType;
		}
		
		
		[Bindable(event="originObselChange")]
		public function get originObsel():Obsel
		{
			return _originObsel;
		}
		
		public function set originObsel(value:Obsel):void
		{
			if( _originObsel !== value)
			{
				if(_originObsel)
				{
					_originObsel.unregisterRelation(this);
					
					if(_targetObsel)
						_targetObsel.outcomingRelationChange(this);
				}			
				
				_originObsel = value;
				dispatchEvent(new Event("originObselChange"));
			}
		}


		[Bindable(event="targetObselChange")]
		public function get targetObsel():Obsel
		{
			return _targetObsel;
		}
		
		public function set targetObsel(value:Obsel):void
		{
			if( _targetObsel !== value)
			{
				if(_targetObsel)
				{
					_targetObsel.unregisterRelation(this);
					
					if(_originObsel)
						_originObsel.incomingRelationChange(this);
				}
				
				_targetObsel = value;
				dispatchEvent(new Event("targetObselChange"));
			}
		}

	}
}