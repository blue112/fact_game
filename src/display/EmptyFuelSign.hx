package display;

import display.BlinkingIcon;
import flash.display.BitmapData;

@:bitmap("assets/icon_no_fuel.png") class IconNoFuelPNG extends BitmapData {}

class EmptyFuelSign extends BlinkingIcon
{
    public function new()
    {
        super(new IconNoFuelPNG(0, 0));
    }
}
