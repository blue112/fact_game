package display.buildings;

import display.Building;
import events.GUIEvent;
import flash.events.ProgressEvent;
import model.Item;

class SRim extends Rim
{
    public function new()
    {
        state = WAITING_FOR_ITEM;

        super(SRIM);
    }

    override private function getBackCoordinates()
    {
        var itemCoordX = posX;
        var itemCoordY = posY;

        switch (rotationState)
        {
            case 0: itemCoordY -= 2;
            case 1: itemCoordX += 2;
            case 2: itemCoordY += 2;
            case 3: itemCoordX -= 2;
        }

        return {x:itemCoordX, y:itemCoordY};
    }
}
