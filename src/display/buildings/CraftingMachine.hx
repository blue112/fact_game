package display.buildings;

import display.Building;
import events.GUIEvent;
import events.InventoryEvent;
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

    override private function onDeconstructed()
    {
        var invClone = Character.getInstance().inventory.clone();
        for (i in components)
        {
            if (i != null)
            {
                if (invClone.canAddItem(i))
                {
                    invClone.addItem(i);
                }
                else
                {
                    return false;
                }
            }
        }

        for (i in components)
        {
            if (i != null)
            {
                EventManager.dispatch(new InventoryEvent(InventoryEvent.ADD_ITEM, i));
            }
        }

        return true;
    }

    override public function interact()
    {
        //Opens the chest inventory window
        EventManager.dispatch(new GUIEvent(GUIEvent.OPEN_CRAFTING_MACHINE_WINDOW, this));
    }

    override public function addItem(item:Item):Bool
    {
        if (acceptItem(item.getType()))
        {
            var n = 0;
            for (i in selectedRecipe.components)
            {
                if (item.getType() == i.type)
                {
                    components[n].increase(item.getQuantity());
                    updated();
                    return true;
                }
                n++;
            }
        }

        return false;
    }

    override public function acceptItem(type:ItemType)
    {
        if (state == WAITING && selectedRecipe != null)
        {
            var n = 0;
            for (i in selectedRecipe.components)
            {
                if (type == i.type)
                {
                    if (components[n].getQuantity() < i.quantity)
                    {
                        return true;
                    }
                }
                n++;
            }
        }

        return false;
    }

    override public function isBuildable(tile:Tile)
    {
        return true;
    }

    override public function loadData(data:Dynamic)
    {
        if (data.selectedRecipe != null)
        {
            selectedRecipe = gui.CraftWindow.recipes[data.selectedRecipe];
        }
    }

    override public function serialize()
    {
        var data:Dynamic = super.serialize();

        if (selectedRecipe != null)
        {
            var n = 0;
            for (i in gui.CraftWindow.recipes)
            {
                if (selectedRecipe == i)
                     break;

                n++;
            }
            data.selectedRecipe = n;
        }
        else
        {
            data.selectedRecipe = null;
        }

        return data;
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
