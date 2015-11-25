package gui;

import display.AutoTF;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import model.Inventory;

class Window extends Sprite
{
    static private inline var TITLE_BAR_HEIGHT:Int = 20;

    var titleTF:AutoTF;
    var windowWidth:Int;
    var windowHeight:Int;

    public function new(title:String, w:Int, h:Int)
    {
        super();

        this.windowWidth = w;
        this.windowHeight = h;

        graphics.lineStyle(1, 0x000000);
        graphics.beginFill(0x999999);
        graphics.drawRect(0, -TITLE_BAR_HEIGHT, w, TITLE_BAR_HEIGHT);

        var dragSprite = new Sprite();
        dragSprite.graphics.beginFill(0xFF00000, 0);
        dragSprite.graphics.drawRect(0, -TITLE_BAR_HEIGHT, w, TITLE_BAR_HEIGHT);
        dragSprite.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);

        titleTF = new AutoTF(title, false, 12, 0xFFFFFF, true);
        titleTF.x = (w - titleTF.width) / 2;
        titleTF.y = -TITLE_BAR_HEIGHT + (TITLE_BAR_HEIGHT - titleTF.height) / 2;
        addChild(titleTF);

        graphics.beginFill(0xEEEEEE);
        graphics.drawRect(0, 0, w, h);

        addChild(dragSprite);
        update();
    }

    private function onMouseDown(e:MouseEvent)
    {
        this.startDrag(false, new Rectangle(0, TITLE_BAR_HEIGHT, stage.stageWidth - windowWidth, stage.stageHeight - windowHeight));
        stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
    }

    private function onMouseUp(e:MouseEvent)
    {
        this.stopDrag();
        stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
    }

    private function clear()
    {
        while (numChildren > 0)
            removeChildAt(0);

        addChild(titleTF);
    }

    public function show()
    {
        update();
        this.visible = true;
    }

    public function update()
    {
        throw "Must be overwritten.";
    }

    public function close()
    {
        this.visible = false;
    }
}
