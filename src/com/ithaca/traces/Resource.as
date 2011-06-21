package com.ithaca.traces
{
	import mx.utils.ObjectProxy;
	import flash.events.Event;
	
	public class Resource extends ObjectProxy
	{
		public static var RESOURCE_SYNC_STATUS_SYNCHRONIZED:String = "synchronized";
		public static var RESOURCE_SYNC_STATUS_SYNCHRONIZING:String = "synchronizing";
		public static var RESOURCE_SYNC_STATUS_UNSYNCHRONIZED:String = "unsynchronized";
		public static var RESOURCE_SYNC_STATUS_ERROR:String = "error";
		public static var RESOURCE_SYNC_STATUS_UNKNOWN:String = "unknown";
		
		public static var RESOURCE_DEFAULT_LABEL_VALUE:String = "noname";
		
		protected var _uri:String;
		protected var _sync_status:String = Resource.RESOURCE_SYNC_STATUS_UNKNOWN;
		protected var _label:String = RESOURCE_DEFAULT_LABEL_VALUE;
		
		public function Resource(item:Object=null, uid:String=null, proxyDepth:int=-1)
		{
			super(item, uid, proxyDepth);
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
			if( _uri !== value)
			{
				_uri = value;
				dispatchEvent(new Event("uriChange"));
			}
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

	}
}