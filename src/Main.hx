import display.FloatingMessage;
import display.InfoView;
import events.CharEvent;
import events.GameEvent;
import events.GUIEvent;
import events.InventoryEvent;
import events.MapEvent;
import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import gui.CraftWindow;
import gui.HungerBar;
import gui.InventoryWindow;
import gui.ProgressBar;
import model.TimeManager;
import gui.InventoryArea.InventoryType;

class Main extends Sprite
{
    var inventoryWindow:InventoryWindow;
    var craftWindow:CraftWindow;
    var activeWindow:gui.Window;
    var infoView:InfoView;
    var progressBar:ProgressBar;
    var hungerbar:HungerBar;

    var map:Map;
    var character:Character;

    static private inline var LOAD_SAVE:Bool = true;

    public function new()
    {
        super();

        flash.Lib.current.addChild(this);

        map = new Map(!LOAD_SAVE);

        var timeManager = new TimeManager(map);

        var c = new Character(map);

        this.character = c;

        var viewport = new Viewport(stage.stageWidth, stage.stageHeight, map, c);

        addChild(map);

        map.setCharacter(c);

        var controller = new Controller(c);

        infoView = new InfoView();
        infoView.x = stage.stageWidth - infoView.width;
        infoView.y = stage.stageHeight - infoView.height;
        addChild(infoView);

        hungerbar = new gui.HungerBar();
        hungerbar.x = stage.stageWidth - hungerbar.width - 10;
        hungerbar.y = 10;
        hungerbar.update(c.hunger, Character.MAX_HUNGER);
        addChild(hungerbar);

        stage.addEventListener(Event.RESIZE, onResize);

        EventManager.listen(GameEvent.SAVE, onSave);
        EventManager.listen(CharEvent.HUNGER_CHANGED, function(_)
        {
            hungerbar.update(c.hunger, Character.MAX_HUNGER);
        });
        EventManager.listen(GUIEvent.OPEN_OVEN_WINDOW, function(e:GUIEvent)
        {
            showWindow(new gui.OvenWindow(c.inventory, e.data));
        });
        EventManager.listen(GUIEvent.OPEN_MINING_ENGINE_WINDOW, function(e:GUIEvent)
        {
            showWindow(new gui.MiningEngineWindow(c.inventory, e.data));
        });
        EventManager.listen(GUIEvent.OPEN_CRAFTING_MACHINE_WINDOW, function(e:GUIEvent)
        {
            showWindow(new gui.CraftingMachineWindow(c.inventory, e.data));
        });
        EventManager.listen(GUIEvent.OPEN_DEBUG_WINDOW, function(e:GUIEvent)
        {
            showWindow(new gui.DebugWindow());
        });
        EventManager.listen(GUIEvent.OPEN_INVENTORY, function(e:GUIEvent)
        {
            var isPlayer = false;
            if (e.data == null)
            {
                isPlayer = true;
                e.data = c.inventory;
            }

            if (inventoryWindow != null)
            {
                closeActiveWindow();
                activeWindow = inventoryWindow;
                inventoryWindow.setInventory(e.data, isPlayer ? InventoryType.PLAYER : InventoryType.CHEST);
                inventoryWindow.show();
                return;
            }

            inventoryWindow = new InventoryWindow(e.data, isPlayer ? InventoryType.PLAYER : InventoryType.CHEST);
            showWindow(inventoryWindow);
        });
        EventManager.listen(GUIEvent.OPEN_CRAFT_WINDOW, function(_)
        {
            if (craftWindow != null)
            {
                closeActiveWindow();
                activeWindow = craftWindow;
                craftWindow.show();
                return;
            }

            craftWindow = new CraftWindow(c.inventory);
            showWindow(craftWindow);
        });
        EventManager.listen(MapEvent.GATHERING_PROGRESS, function(e:MapEvent)
        {
            if (progressBar == null)
            {
                progressBar = new gui.ProgressBar(300);
                progressBar.x = (stage.stageWidth - progressBar.width) / 2;
                progressBar.y = (stage.stageHeight - progressBar.height) - 50;
                addChild(progressBar);
            }

            progressBar.update(e.data.lifepoint, e.data.max);
        });
        EventManager.listen(MapEvent.DECONSTRUCTING_PROGRESS, function(e:MapEvent)
        {
            if (progressBar == null)
            {
                progressBar = new gui.ProgressBar(300);
                progressBar.x = (stage.stageWidth - progressBar.width) / 2;
                progressBar.y = (stage.stageHeight - progressBar.height) - 50;
                addChild(progressBar);
            }

            progressBar.update(e.data.lifepoint, e.data.max);
        });
        EventManager.listen(GUIEvent.CLOSE_ACTIVE_WINDOW, function(_)
        {
            if (!closeActiveWindow())
            {
                EventManager.dispatch(new GameEvent(GameEvent.ESCAPE));
            }
        });
        EventManager.listen(InventoryEvent.ADD_ITEM, function(e:InventoryEvent)
        {
            var data = character.inventory.addItem(e.data);
            new FloatingMessage("+"+data.added+" "+data.item.getName()+" ("+data.totalQuantity+")");
        });
        EventManager.listen(InventoryEvent.REMOVE_ITEM, function(e:InventoryEvent)
        {
            character.inventory.removeItem(e.data.type, e.data.quantity);
        });

        if (LOAD_SAVE)
        {
            load();
        }
    }

    private function showWindow(win:gui.Window)
    {
        closeActiveWindow();

        activeWindow = win;
        activeWindow.show();
        activeWindow.x = (stage.stageWidth - activeWindow.width) / 2;
        activeWindow.y = (stage.stageHeight - activeWindow.height) / 2;
        addChild(activeWindow);
    }

    private function closeActiveWindow()
    {
        if (activeWindow != null)
        {
            activeWindow.close();
            activeWindow = null;
            return true;
        }

        return false;
    }

    private function onSave(_)
    {
        var globalSave:Dynamic = {};
        globalSave.map = map.save();
        globalSave.inventory = character.inventory.serialize();

        //Serialize it into a string
        var s = haxe.Serializer.run(globalSave);

        //Save it on the server
        var req = new URLRequest("http://127.0.0.1/fact/saveload.php");
        req.data = "data="+StringTools.urlEncode(s);
        req.method = "POST";
        var load = new URLLoader();
        load.addEventListener(Event.COMPLETE, function(_)
        {
            new display.FloatingMessage("Saved !");
        });
        load.load(req);
    }

    private function load()
    {
        var req = new URLRequest("http://127.0.0.1/fact/saveload.php");
        var load = new URLLoader();
        load.addEventListener(Event.COMPLETE, function(_)
        {
            var d = haxe.Unserializer.run(load.data);
            map.load(d.map);
            character.inventory.load(d.inventory);
        });
        load.load(req);
    }

    private function onResize(_)
    {
        infoView.x = stage.stageWidth - infoView.width;
        infoView.y = stage.stageHeight - infoView.height;
        hungerbar.x = stage.stageWidth - hungerbar.width - 10;

        if (activeWindow != null)
        {
            activeWindow.x = (stage.stageWidth - activeWindow.width) / 2;
            activeWindow.y = (stage.stageHeight - activeWindow.height) / 2;
        }

    }

    static public function main()
    {
        flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
        flash.Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;

        var app = new Main();
    }
}
