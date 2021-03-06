package com.asbox.managers
{
	import com.adobe.crypto.MD5;
	import com.asbox.components.base.interfaces.IComponentComands;
	import com.asbox.components.base.interfaces.IComponentObject;
	import com.asbox.components.events.ComponentEvent;
	import com.asbox.enums.DebugEnums;
	
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Poluosmak Andrew
	 */
	public class ComponentManager
	{
		private static var _instance:ComponentManager = null;
		
		private var _components:Dictionary = new Dictionary(true);
		
		private var _numComponents:int = 0;
		private var _enqID:int = 0;
		
		public function ComponentManager(caller:Function = null)
		{
			if (caller != ComponentManager.getInstance)
				throw new Error("ComponentManager is a singleton class, use getInstance() instead");
			if (ComponentManager._instance != null)
				throw new Error("Only one ComponentManager instance should be instantiated");
		}
		
		public static function getInstance():ComponentManager
		{
			if (_instance == null)
				_instance = new ComponentManager(arguments.callee);
			
			return _instance;
		}
		
		public function Register(component:IComponentObject):void
		{
			if (_components[component] == null)
			{				
				component.ComponentHash = this.GenerateComponentHash();
				
				if (DebugEnums.DEBUG_MODE)
					trace("Register component " + component.ComponentHash + "");
				
				_components[component] = component;
				_numComponents++;
				
				if (DebugEnums.DEBUG_MODE)
					trace("Total components in system " + _numComponents + "");
			}
		}
		
		public function Get(name:String):IComponentObject
		{
			if (_components != null)
			{
				for (var key:*in _components)
				{
					if (IComponentObject(_components[key]).ComponentName == name)
						return IComponentObject(_components[key]);
				}
			}
			
			return null;
		}
		
		public function GetByHash(hash:String):IComponentObject
		{
			if (_components != null)
			{
				for (var key:* in _components)
				{
					if (IComponentObject(_components[key]).ComponentHash == hash)
						return IComponentObject(_components[key]);
				}
			}
			
			return null;
		}
		
		public function Unregister(hash:String):void
		{
			var _component:IComponentComands = this.GetByHash(hash) as IComponentComands;
			
			if (_component != null)
			{
				if (DebugEnums.DEBUG_MODE)
					trace("Unregister component " + IComponentComands(_component).ComponentHash + "");
				
				_component.Listener(function(event:ComponentEvent):void
					{						
						delete _components[_component];
						_numComponents--;
						
						if (DebugEnums.DEBUG_MODE)
							trace("Total components in system " + _numComponents + "");
					
					}, ComponentEvent.DISPOSED, _component.ComponentHash, true);
				
				_component.Dispose();
			}
		}
		
		private function GenerateComponentHash():String
		{
			_enqID++;
			return MD5.hash(new Date().time + "::" + _enqID);
		}
	}

}