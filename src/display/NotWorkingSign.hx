package display;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;

using feffects.Tween.TweenObject;

@:bitmap("assets/icon_not_working.png") class IconNotWorkingPNG extends BitmapData {}

class NotWorkingSign extends Sprite
{
    public function new()
    {
        super();

        var not_working_sign = new Bitmap(new IconNotWorkingPNG(0, 0));
        not_working_sign.x = (Map.TILE_WIDTH - not_working_sign.width) / 2;
        not_working_sign.y = (Map.TILE_HEIGHT - not_working_sign.height) / 2;
        addChild(not_working_sign);

        startTweening();
    }

    private function startTweening()
    {
        this.tween({alpha: 0.5}, 1000).onFinish(function()
        {
            this.tween({alpha: 1}, 1000).onFinish(startTweening).start();
        }).start();
    }
}
