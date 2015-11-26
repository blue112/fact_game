package display;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import haxe.Timer;

using feffects.Tween.TweenObject;

class BlinkingIcon extends Sprite
{
    var t:Timer;

    public function new(data:BitmapData)
    {
        super();

        var not_working_sign = new Bitmap(data);
        not_working_sign.x = (Map.TILE_WIDTH - not_working_sign.width) / 2;
        not_working_sign.y = (Map.TILE_HEIGHT - not_working_sign.height) / 2;
        addChild(not_working_sign);

        addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);

        startBlinking();
    }

    private function onRemoved(_)
    {
        t.stop();
        t = null;
        removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
    }

    private function startBlinking()
    {
        t = new Timer(1000);
        t.run = function()
        {
            visible = !visible;
        }
    }
}
