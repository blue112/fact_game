package display;

import flash.display.DisplayObject;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

class AutoTF extends TextField
{
    public function new(text:String, bold:Bool, size:Int, color:Int = 0x424242, ?glow:Bool = false)
    {
        super();
        autoSize = TextFieldAutoSize.LEFT;
        selectable = false;
        mouseEnabled = false;

        var format = new TextFormat("Arial", size, color);
        defaultTextFormat = format;
        this.text = text;

        if (glow)
        {
            filters = [new GlowFilter(0x000000, 0.7, 3, 3, 10)];
        }
    }

    public function centerTo(to:DisplayObject)
    {
        x = (to.width - width) / 2;
        y = (to.height - height) / 2;
    }
}
