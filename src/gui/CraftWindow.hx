package gui;

import display.AutoTF;
import events.InventoryEvent;
import gui.Button;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import model.Inventory;
import model.Item;

typedef Recipe =
{
    var item:ItemType;
    var components:Array<{type:ItemType, quantity:Int}>;
}

class CraftWindow extends Window
{
    static private inline var MARGIN:Int = 30;

    static private inline var WINDOW_WIDTH:Int = 400;
    static private inline var WINDOW_HEIGHT:Int = 300;

    static private inline var RECIPE_BLOCK_X:Int = 80;

    static public var recipes:Array<Recipe> = initRecipes();
    var recipeBlock:Sprite;

    var activeRecipe:Recipe;

    var inventory:Inventory;

    static function initRecipes()
    {
        return [
            {item: ItemType.BREAD, components: [
                {type: ItemType.WHEAT, quantity: 5}
            ]},
            {item: ItemType.MINING_ENGINE, components: [
                {type: ItemType.IRON_BAR, quantity: 2},
                {type: ItemType.COAL, quantity: 1}
            ]},
            {item: ItemType.CONVEYOR_BELT, components: [
                {type: ItemType.IRON_BAR, quantity: 2},
                {type: ItemType.GEAR, quantity: 1},
            ]},
            {item: ItemType.CHEST, components: [
                {type: ItemType.IRON_BAR, quantity: 1},
            ]},
            {item: ItemType.OVEN, components: [
                {type: ItemType.STONE, quantity: 4},
            ]},
            {item: ItemType.RIM, components: [
                {type: ItemType.IRON_BAR, quantity: 2},
                {type: ItemType.GEAR, quantity: 1},
            ]},
            {item: ItemType.SRIM, components: [
                {type: ItemType.RIM, quantity: 1},
                {type: ItemType.IRON_BAR, quantity: 2},
            ]},
            {item: ItemType.GEAR, components: [
                {type: ItemType.IRON_BAR, quantity: 1},
            ]},
            {item: ItemType.CRAFTING_MACHINE, components: [
                {type: ItemType.IRON_BAR, quantity: 3},
                {type: ItemType.GEAR, quantity: 5},
            ]}
        ];
    }

    public function new(inv:Inventory)
    {
        super("Craft", WINDOW_WIDTH, WINDOW_HEIGHT);

        this.inventory = inv;

        var recipeLabel = new AutoTF("Recipes:", true, 15, 0xFFFFFF, true);
        recipeLabel.x = MARGIN;
        recipeLabel.y = MARGIN;
        addChild(recipeLabel);

        var dividing_line = new Shape();
        dividing_line.graphics.lineStyle(1);
        dividing_line.graphics.moveTo(MARGIN + RECIPE_BLOCK_X, 0);
        dividing_line.graphics.lineTo(MARGIN + RECIPE_BLOCK_X, WINDOW_HEIGHT);
        addChild(dividing_line);

        recipeBlock = new Sprite();
        recipeBlock.x = MARGIN + RECIPE_BLOCK_X;
        addChild(recipeBlock);

        var n = 0;
        for (i in recipes)
        {
            var icon = new Item(i.item).render(false);
            icon.scaleX = icon.scaleY = 0.5;
            icon.x = MARGIN + (n % 2) * (icon.width + 5);
            icon.y = 5 + recipeLabel.height + recipeLabel.y + Math.floor(n / 2) * (icon.height + 5);
            icon.buttonMode = true;
            icon.addEventListener(MouseEvent.CLICK, onRecipeClick.bind(i));
            addChild(icon);

            n++;
        }
    }

    private function onRecipeClick(recipe:Recipe, _:Dynamic)
    {
        this.activeRecipe = recipe;

        while (recipeBlock.numChildren > 0)
            recipeBlock.removeChildAt(0);

        var w = WINDOW_WIDTH - MARGIN * 3 - RECIPE_BLOCK_X;

        var it = new Item(recipe.item);
        var nameTF = new AutoTF(it.getName(), true, 20, 0xFFFFFF, true);
        nameTF.x = MARGIN + (w - nameTF.width) / 2;
        nameTF.y = MARGIN;
        recipeBlock.addChild(nameTF);

        var numPerLine = Math.floor(w / Item.ITEM_WIDTH);
        var numLine = Math.floor(w / Item.ITEM_HEIGHT);

        var n = 0;
        for (i in recipe.components)
        {
            var it = new Item(i.type, i.quantity);
            it.addNumPossessed(inventory.countItem(i.type));
            var itemSprite = it.render();
            itemSprite.x = MARGIN + (n % numPerLine) * (itemSprite.width + 5);
            itemSprite.y = 20 + nameTF.y + nameTF.height + Math.floor(n / numPerLine) * (itemSprite.height + 5);
            recipeBlock.addChild(itemSprite);

            n++;
        }

        var craftButton = new Button("Craft", function()
        {
            //Check I have components
            for (i in recipe.components)
            {
                if (inventory.countItem(i.type) < i.quantity)
                    return;
            }

            //Remove them from inventory
            for (i in recipe.components)
            {
                inventory.removeItem(i.type, i.quantity);
            }

            //Add resulting item into inventory
            EventManager.dispatch(new InventoryEvent(InventoryEvent.ADD_ITEM, new Item(recipe.item)));

            //Update view
            onRecipeClick(activeRecipe, null);
        });
        craftButton.x = (w - craftButton.width) / 2;
        craftButton.y = WINDOW_HEIGHT - MARGIN;
        recipeBlock.addChild(craftButton);
    }

    override public function show()
    {
        if (activeRecipe != null)
        {
            onRecipeClick(activeRecipe, null);
        }

        super.show();
    }

    override public function update()
    {
    }

}
