package gui;

import display.AutoTF;
import display.buildings.CraftingMachine;
import display.buildings.CraftingMachine;
import events.BuildEvent;
import events.InventoryEvent;
import events.UpdateEvent;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.events.ProgressEvent;
import gui.CraftWindow;
import gui.CraftWindow.Recipe;
import gui.InventoryArea;
import gui.ItemSlot;
import gui.ProgressBar;
import model.Inventory;
import model.Item;

@:bitmap("assets/icon_cancel.png") class IconCancelPNG extends BitmapData {}

class CraftingMachineWindow extends Window
{
    static private inline var WINDOW_WIDTH:Int = 550;
    static private inline var WINDOW_HEIGHT:Int = 300;
    static private inline var MARGIN:Int = 30;

    static private inline var COMPONENTS_AREA_SIZE:Int = 150;

    var area:InventoryArea;
    var craftingMachine:CraftingMachine;
    var inv:Inventory;

    var craftingMachineArea:Sprite;

    var craftingMachineProgressBar:ProgressBar;

    public function new(inv:Inventory, craftingMachine:CraftingMachine)
    {
        area = new InventoryArea(WINDOW_WIDTH - COMPONENTS_AREA_SIZE, WINDOW_HEIGHT, inv, InventoryType.CUSTOM(onItemClick));
        addChild(area);

        this.craftingMachine = craftingMachine;
        this.inv = inv;

        craftingMachineArea = new Sprite();
        craftingMachineArea.x = WINDOW_WIDTH - COMPONENTS_AREA_SIZE;
        craftingMachineArea.graphics.lineStyle(1);
        craftingMachineArea.graphics.moveTo(0, 0);
        craftingMachineArea.graphics.lineTo(0, WINDOW_HEIGHT);
        addChild(craftingMachineArea);

        craftingMachineProgressBar = new ProgressBar(100, 10);
        craftingMachineProgressBar.x = (COMPONENTS_AREA_SIZE - craftingMachineProgressBar.width) / 2;
        craftingMachineProgressBar.y = MARGIN;
        craftingMachineArea.addChild(craftingMachineProgressBar);

        craftingMachine.addEventListener(ProgressEvent.PROGRESS, function(e:ProgressEvent)
        {
            craftingMachineProgressBar.update(Std.int(e.bytesLoaded), Std.int(e.bytesTotal));
        });
        craftingMachine.addEventListener(UpdateEvent.UPDATE, function(e:UpdateEvent)
        {
            update();
        });

        super(new Item(craftingMachine.toItemType()).getName(), WINDOW_WIDTH, WINDOW_HEIGHT);
    }

    private function onItemClick(item:Item)
    {
        if (craftingMachine.selectedRecipe == null)
            return;

        var n = 0;
        for (i in craftingMachine.selectedRecipe.components)
        {
            if (i.type == item.getType())
            {
                inv.removeItem(item.getType(), 1);
                craftingMachine.components[n].increase(1);
                update();
                return;
            }
            n++;
        }
    }

    override public function update()
    {
        if (craftingMachine.selectedRecipe == null)
        {
            createRecipeChooser();
        }
        else
        {
            createComponentsSlots();
        }

        area.update();
    }

    private function createRecipeChooser()
    {
        while (craftingMachineArea.numChildren > 0)
            craftingMachineArea.removeChildAt(0);

        var recipeLabel = new AutoTF("Choose a recipe:", true, 15, 0xFFFFFF, true);
        recipeLabel.x = (COMPONENTS_AREA_SIZE - recipeLabel.width) / 2;
        recipeLabel.y = MARGIN;
        craftingMachineArea.addChild(recipeLabel);

        var n = 0;
        var scaleIcon = 0.75;
        var baseX = (COMPONENTS_AREA_SIZE - ((Item.ITEM_WIDTH * scaleIcon + 5) * 2)) / 2;
        for (i in CraftWindow.recipes)
        {
            var icon = new Item(i.item).render(false);
            icon.scaleX = icon.scaleY = scaleIcon;
            icon.x = baseX + (n % 2) * (icon.width + 5);
            icon.y = 5 + recipeLabel.height + recipeLabel.y + Math.floor(n / 2) * (icon.height + 5);
            icon.buttonMode = true;
            icon.addEventListener(MouseEvent.CLICK, onRecipeClick.bind(i));
            craftingMachineArea.addChild(icon);

            n++;
        }
    }

    private function onRecipeClick(i:Recipe, _)
    {
        craftingMachine.selectedRecipe = i;
        update();
    }

    private function resetRecipe(_)
    {
        craftingMachine.selectedRecipe = null;
        update();
    }

    private function createComponentsSlots()
    {
        while (craftingMachineArea.numChildren > 0)
            craftingMachineArea.removeChildAt(0);

        var recipeLabel = new AutoTF("Choosen recipe:", true, 12, 0xFFFFFF, true);
        recipeLabel.x = 10;
        recipeLabel.y = MARGIN;
        craftingMachineArea.addChild(recipeLabel);

        var icon = new Item(craftingMachine.selectedRecipe.item).render(false);
        icon.scaleX = icon.scaleY = 0.6;
        icon.x = recipeLabel.width + recipeLabel.x + 5;
        icon.y = recipeLabel.y + (recipeLabel.height - icon.height) / 2;
        craftingMachineArea.addChild(icon);

        var resetIcon = new Sprite();
        resetIcon.addChild(new Bitmap(new IconCancelPNG(0,0)));
        resetIcon.x = (COMPONENTS_AREA_SIZE - resetIcon.width) / 2;
        resetIcon.y = recipeLabel.height + recipeLabel.y + 10;
        resetIcon.buttonMode = true;
        resetIcon.addEventListener(MouseEvent.CLICK, resetRecipe);
        craftingMachineArea.addChild(resetIcon);

        var compLabel = new AutoTF("Components:", true, 12, 0xFFFFFF, true);
        compLabel.x = 10;
        compLabel.y = resetIcon.y + resetIcon.height + 10;
        craftingMachineArea.addChild(compLabel);

        var lastItem:Sprite = null;
        var n = 0;
        var scaleIcon = 1;
        var baseX = (COMPONENTS_AREA_SIZE - ((Item.ITEM_WIDTH * scaleIcon + 5) * 2)) / 2;
        for (i in craftingMachine.selectedRecipe.components)
        {
            var item = new Item(i.type, i.quantity);
            item.addNumPossessed(craftingMachine.components[n].getQuantity());
            var icon = item.render(true);
            icon.scaleX = icon.scaleY = scaleIcon;
            icon.x = baseX + (n % 2) * (icon.width + 5);
            icon.y = 5 + compLabel.height + compLabel.y + Math.floor(n / 2) * (icon.height + 5);
            craftingMachineArea.addChild(icon);

            lastItem = icon;

            n++;
        }

        craftingMachineProgressBar.y = lastItem.height + lastItem.y + 10;
        craftingMachineArea.addChild(craftingMachineProgressBar);
    }
}
