package display;

import display.AutoTF;
import display.Tile;
import events.MapEvent;
import flash.display.Sprite;

class InfoView extends Sprite
{
    var nameTF:AutoTF;

    public function new()
    {
        super();

        graphics.lineStyle(2);
        graphics.beginFill(0x999999);
        graphics.drawRect(0, 0, 150, 300);

        var nameLabelTF = new AutoTF("Name: ", true, 15);
        nameLabelTF.y = nameLabelTF.x = 10;
        nameTF = new AutoTF("Empty", false, 15);
        nameTF.x = nameLabelTF.x + nameLabelTF.width;
        nameTF.y = nameLabelTF.y;

        var quantityLabelTF = new AutoTF("Quantity: ", true, 15);
        quantityLabelTF.x = 10;
        quantityLabelTF.y = nameLabelTF.y + nameLabelTF.height + 10;
        var quantityTF = new AutoTF("N/A", false, 15);
        quantityTF.x = quantityLabelTF.x + quantityLabelTF.width;
        quantityTF.y = quantityLabelTF.y;

        addChild(nameLabelTF);
        addChild(nameTF);
        addChild(quantityLabelTF);
        addChild(quantityTF);

        var icon_slot = new Sprite();
        icon_slot.x = 10;
        icon_slot.y = quantityLabelTF.y + quantityLabelTF.height + 10;
        addChild(icon_slot);

        EventManager.listen(MapEvent.HOVER_TILE, function(e:MapEvent)
        {
            icon_slot.graphics.clear();
            var t:Tile = e.data;
            if (t == null)
            {
                nameTF.text = "Empty";
                quantityTF.text = "N/A";
            }
            else
            {
                nameTF.text = t.getName();
                t.draw(icon_slot, false);
                quantityTF.text = Std.string(t.getQuantity());
            }
        });
    }
}
