package com.asbox.components.interfaces 
{
	import flash.events.IEventDispatcher;
	/**
	 * ...
	 * @author Poluosmak Andrew
	 */
	public interface IComponent extends IEventDispatcher 
	{
		function get OwnerComponent():IComponent;
		function set OwnerComponent(value:IComponent):void;
		
		function get ComponentName():String;
		function set ComponentName(value:String):void;
		
		function get ComponentHash():String;
		function set ComponentHash(value:String):void;
			
		function Initialize(name:String):void;
		function Dispose():void;
		function ActivateComponent():void;
		function DeactivateComponent():void;
		function Status():int;
		
		function AddComponent(hash:String):Boolean;
		function RemoveComponent(hash:String, system:Boolean = true):Boolean;				
		function GetComponentByName(name:String):IComponent;
		function GetComponentByClass(component:Class):Array;
		function GetComponentByHash(hash:String):IComponent;
		
		function get Components():Array;
		
		function Listener(callback:Function, type:String, component:String = "", autoRemove:Boolean = false):void;
		function UnregisterListener(callback:Function, type:String, component:String = ""):void;
		
		function PreInitialize():void;
	}
	
}