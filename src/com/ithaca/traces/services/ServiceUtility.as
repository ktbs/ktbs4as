package com.ithaca.traces.services
{
	public class ServiceUtility
	{
		//these are values to be assigned to the serverRole properties
		static public var SERVER_ROLE_LISTEN:String = "listen"; // the server will only register new obsel, client won't try to load anything from it 
		static public var SERVER_ROLE_MASTER:String = "god"; // the client will load everything from the server and won't try to modify it
		static public var SERVER_ROLE_COMPREHENSIVE:String = "god"; // the client will sync (load and submit changes) to the server
		
		public function ServiceUtility()
		{
		}
	}
}