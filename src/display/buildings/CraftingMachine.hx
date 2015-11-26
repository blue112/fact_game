package display.buildings;

import display.Building;
import events.GUIEvent;
import events.UpdateEvent;
import flash.events.ProgressEvent;
import gui.CraftWindow.Recipe;
import model.Item;

enum CraftingMachineState
{
    WAITING;
    CRAFTING;
}

class CraftingMachine extends Building
{
    public var components:Array<Item>;

    var state:CraftingMachineState;

    var counter:Int;
    var skipTick:Bool;

    public var selectedRecipe(default, set):Recipe;

    static private inline var TIME_TO_CRAFT = 10;

    public function new()
    {
        skipTick = false;
        state = WAITING;
        selectedRecipe = null;

        counter = 0;

        super(CRAFTING_MACHINE);
    }

    override private function work()
    {
        switch (state)
        {
            case WAITING:
                if (selectedRecipe == null)
                    return CANNOT_WORK;

                //Check I have components
                var n = 0;
                for (i in selectedRecipe.components)
                {
                    if (components[n].getQuantity() < i.quantity)
                        return WORKING;

                    n++;
                }

                //Remove them from slots
                n = 0;
                for (i in selectedRecipe.components)
                {
                    components[n].decrease(i.quantity);
                    n++;
                }

                updated();

                state = CRAFTING;
            case CRAFTING:
                if (counter == TIME_TO_CRAFT)
                {
                    if (pushItem(new Item(selectedRecipe.item)))
                    {
                        counter = 0;
                        updateProgress();
                        state = WAITING;
                    }
                }
                else
                {
                    updateProgress();
                    counter++;
                }
        }

        return WORKING;
    }

    private function updateProgress()
    {
        dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, counter, TIME_TO_CRAFT));
    }

    override public function interact()
    {
        //Opens the chest inventory window
        EventManager.dispatch(new GUIEvent(GUIEvent.OPEN_CRAFTING_MACHINE_WINDOW, this));
    }

    override public function addItem(item:Item):Bool
    {
        if (selectedRecipe != null)
        {
            var n = 0;
            for (i in selectedRecipe.components)
            {
                if (item.getType() == i.type)
                {
                    if (components[n].getQuantity() < i.quantity)
                    {
                        components[n].increase(item.getQuantity());
                        updated();
                        return true;
                    }
                }
                n++;
            }
        }

        return false;
    }

    override public function acceptItem()
    {
        return state == WAITING && selectedRecipe != null;
    }

    override public function isBuildable(tile:Tile)
    {
        return true;
    }

    public function set_selectedRecipe(r:Recipe):Recipe
    {
        if (r == selectedRecipe)
            return r;

        this.selectedRecipe = r;

        components = [];
        if (r != null)
        {
            for (i in selectedRecipe.components)
            {
                components.push(new Item(i.type, 0));
            }
        }

        return r;
    }
}