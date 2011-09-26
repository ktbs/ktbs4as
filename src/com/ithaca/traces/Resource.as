package com.ithaca.traces
{
	import com.ithaca.traces.services.ITraceService;
	
	import flash.events.Event;
	
	import mx.utils.ObjectProxy;
	
	public class Resource extends ObjectProxy
	{
		public static var RESOURCE_SYNC_STATUS_SYNCHRONIZED:String = "synchronized";
		public static var RESOURCE_SYNC_STATUS_SYNCHRONIZING:String = "synchronizing";
		public static var RESOURCE_SYNC_STATUS_UNSYNCHRONIZED:String = "unsynchronized";
		public static var RESOURCE_SYNC_STATUS_ERROR:String = "error";
		public static var RESOURCE_SYNC_STATUS_UNKNOWN:String = "unknown";
		public static var RESOURCE_SYNC_STATUS_WAITING:String = "waiting";
		public static var RESOURCE_SYNC_STATUS_NOSERVER:String = "noserver";
		public static var RESOURCE_SYNC_STATUS_UNLOADED:String = "unloaded";

		
		public static var RESOURCE_URI_ATTRIBUTION_POLICY_CLIENT_IS_KING:String = "clientIsKing";
		public static var RESOURCE_URI_ATTRIBUTION_SERVER_ATTRIBUTED:String = "serverAtributed";
		
		public static var RESOURCE_DEFAULT_LABEL_VALUE:String = "noname";
		
		internal var _uri:String;
		internal var _sync_status:String = Resource.RESOURCE_SYNC_STATUS_UNKNOWN;
		internal var _label:String = RESOURCE_DEFAULT_LABEL_VALUE;
		
		public var uri_attribution_policy:String = Resource.RESOURCE_URI_ATTRIBUTION_POLICY_CLIENT_IS_KING;
		internal var _ktbs:Ktbs;
		
		public function Resource(uri:String=null, uri_attribution_policy:String = null)
		{
		
			//TODO : do something when uri is not well formed or the given uri already exists
			
			if(uri_attribution_policy)
				this.uri_attribution_policy = uri_attribution_policy;
			
			if(uri)
				this._uri = uri;
			else if(this.uri_attribution_policy == Resource.RESOURCE_URI_ATTRIBUTION_POLICY_CLIENT_IS_KING)
				this._uri = this.uid;
			else
				;//TODO

			
			this._label = this._uri;
			
			this._sync_status = RESOURCE_SYNC_STATUS_UNLOADED; // TO REDO, should take into account the case where a resource is client-side created here.
			
			super();
			
		}

		[Bindable]
		public function get label():String
		{
			return _label;
		}
		
		public function get ktbs():Ktbs
		{
			return _ktbs;
		}

		public function set label(value:String):void
		{
			if( _label !== value)
			{
				_label = value;
			}
		}
		
		public function delLabel():void
		{
			label = Resource.RESOURCE_DEFAULT_LABEL_VALUE;
		}

		[Bindable]
		public function get uri():String
		{
			return _uri;
		}

		public function set uri(value:String):void
		{
			//TODO : do something when uri is not well formed or the given uri already exists
			
			if( _uri !== value && Resource.isUriWellFormed(value))
			{
				_uri = value;
			}
			
		}

		[Bindable]
		public function get sync_status():String
		{
			return _sync_status;
		}

		public function set sync_status(value:String):void
		{
			if( _sync_status && _sync_status !== value)
			{
				_sync_status = value;
			}
		}
		
		public static function isUriWellFormed(value:String):Boolean
		{
			//TODO
			return true;
			
		}
		
		public function deleteResource():void
		{
			//TODO
		}
		
		public function sync():void
		{
			//TODO : sending modification to the server !
			if(ktbs && ktbs.arServices)
			{
				for each(var s:ITraceService in ktbs.arServices)
				{
					s.syncResource(this);
				}
			}
		}

	}
}