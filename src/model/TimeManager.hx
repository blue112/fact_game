package model;

import haxe.Timer;

class TimeManager
{
    var mainTimer:Timer;
    var map:Map;

    public function new(map:Map)
    {
        this.map = map;

        mainTimer = new Timer(100); //0.1s
        mainTimer.run = tick;
    }

    private function tick()
    {
        //Every 0.1s
        for (i in map.getAllBuildings())
        {
            i.tryToWork();
        }
    }
}
