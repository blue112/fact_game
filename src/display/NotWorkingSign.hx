package display;

import display.BlinkingIcon;
import flash.display.BitmapData;

@:bitmap("assets/icon_not_working.png") class IconNotWorkingPNG extends BitmapData {}

class NotWorkingSign extends BlinkingIcon
{
    public function new()
    {
        super(new IconNotWorkingPNG(0, 0));
    }
}
