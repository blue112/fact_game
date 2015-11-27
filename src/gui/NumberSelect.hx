package gui;

import events.UpdateEvent;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormatAlign;

class NumberSelect extends Sprite
{
    var number:Int;
    var tf:TextField;

    public function new()
    {
        super();

        number = 1;

        tf = new flash.text.TextField();
        tf.width = 50;
        tf.height = 20;
        tf.background = true;
        tf.border = true;
        var f = new flash.text.TextFormat("Arial", 12);
        f.align = TextFormatAlign.CENTER;
        tf.defaultTextFormat = f;
        tf.text = "1";

        var minusButton = new gui.Button("-", function()
        {
            if (number > 0)
            {
                number--;
                update();
            }
        });

        var plusButton = new gui.Button("+", function()
        {
            number++;
            update();
        });

        tf.x = minusButton.width + 5;
        plusButton.x = tf.x + tf.width + 5;

        addChild(minusButton);
        addChild(tf);
        addChild(plusButton);
    }

    public function getNumber()
    {
        return number;
    }

    private function update()
    {
        tf.text = Std.string(number);
        dispatchEvent(new UpdateEvent(UpdateEvent.UPDATE));
    }
}
