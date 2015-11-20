import flash.events.Event;
import flash.events.EventDispatcher;

class EventManager
{
	static var inst:EventDispatcher;

	static public function removeAll()
	{
		inst = new EventDispatcher();
	}

	static public function dispatch(e:Event)
	{
		if (inst == null)
			inst = new EventDispatcher();

		inst.dispatchEvent(e);
	}

	static public function listen(name:String, f:Dynamic->Void)
	{
		if (inst == null)
			inst = new EventDispatcher();

		inst.addEventListener(name, f);
	}

	static public function listenOnce(name:String, f:Dynamic->Void)
	{
		var f2:Dynamic->Void = null;
		f2 = function(e)
		{
			inst.removeEventListener(name, f2);
			f(e);
		}

		inst.addEventListener(name, f2);
	}

	static public function remove(name:String, f:Dynamic->Void)
	{
		inst.removeEventListener(name, f);
	}
}
