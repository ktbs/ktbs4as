package com.ithaca.traces
{
	import flash.events.Event;
	
	import mx.utils.ObjectProxy;
	
	public class Resource extends ObjectProxy
	{
		public static var RESOURCE_SYNC_STATUS_SYNCHRONIZED:String = "synchronized";
		public static var RESOURCE_SYNC_STATUS_SYNCHRONIZING:String = "synchronizing";
		public static var RESOURCE_SYNC_STATUS_UNSYNCHRONIZED:String = "unsynchronized";
		public static var RESOURCE_SYNC_STATUS_ERROR:String = "error";
		public static var RESOURCE_SYNC_STATUS_UNKNOWN:String = "unknown";
		
		public static var RESOURCE_URI_ATTRIBUTION_POLICY_CLIENT_IS_KING:String = "clientIsKing";
		public static var RESOURCE_URI_ATTRIBUTION_SERVER_ATTRIBUTED:String = "clientIsKing";
		
		public static var RESOURCE_DEFAULT_LABEL_VALUE:String = "noname";
		
		protected var _uri:String;
		protected var _sync_status:String = Resource.RESOURCE_SYNC_STATUS_UNKNOWN;
		protected var _label:String = RESOURCE_DEFAULT_LABEL_VALUE;
		
		public var uri_attribution_policy:String = Resource.RESOURCE_URI_ATTRIBUTION_POLICY_CLIENT_IS_KING;
		
		public function Resource(uri:String=null, uri_attribution_policy:String = null)
		{
			super();
			
			if(uri_attribution_policy)
				this.uri_attribution_policy = uri_attribution_policy;
			
			if(uri)
				this.uri = uri;
			else if(this.uri_attribution_policy == Resource.RESOURCE_URI_ATTRIBUTION_POLICY_CLIENT_IS_KING)
				this.uri = this.uid;
			else
				;//TODO
			
		}

		[Bindable(event="labelChange")]
		public function get label():String
		{
			return _label;
		}

		public function set label(value:String):void
		{
			if( _label !== value)
			{
				_label = value;
				dispatchEvent(new Event("labelChange"));
			}
		}
		
		public function deleteLabel():void
		{
			label = Resource.RESOURCE_DEFAULT_LABEL_VALUE;
		}

		[Bindable(event="uriChange")]
		public function get uri():String
		{
			return _uri;
		}

		public function set uri(value:String):void
		{
			if( _uri !== value && Resource.isUriWellFormed(value))
			{
				_uri = value;
				dispatchEvent(new Event("uriChange"));
			}
			//TODO : do something when uri is not well formed
		}

		[Bindable(event="sync_statusChange")]
		public function get sync_status():String
		{
			return _sync_status;
		}

		public function set sync_status(value:String):void
		{
			if( _sync_status !== value)
			{
				_sync_status = value;
				dispatchEvent(new Event("sync_statusChange"));
			}
		}
		
		public static function isUriWellFormed(value:String):Boolean
		{
			//TODO
			return true;	
		}

	}
}