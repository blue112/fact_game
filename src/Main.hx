import display.InfoView;
import events.CharEvent;
import events.GUIEvent;
import events.MapEvent;
import flash.display.Sprite;
import flash.events.Event;
import gui.CraftWindow;
import gui.HungerBar;
import gui.InventoryWindow;
import gui.ProgressBar;
import model.TimeManager;

class Main extends Sprite
{
    var inventoryWindow:InventoryWindow;
    var craftWindow:CraftWindow;
    var activeWindow:gui.Window;
    var infoView:InfoView;
    var progressBar:ProgressBar;
    var hungerbar:HungerBar;

    public function new()
    {
        super();

        flash.Lib.current.addChild(this);

        var map = new Map();

        var timeManager = new TimeManager(map);

        var c = new Character();

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

        EventManager.listen(CharEvent.HUNGER_CHANGED, function(_)
        {
            hungerbar.update(c.hunger, Character.MAX_HUNGER);
        });
        EventManager.listen(GUIEvent.OPEN_INVENTORY, function(_)
        {
            if (inventoryWindow != null)
            {
                activeWindow = inventoryWindow;
                inventoryWindow.show();
                return;
            }

            inventoryWindow = new InventoryWindow(c.inventory);
            inventoryWindow.x = (stage.stageWidth - inventoryWindow.width) / 2;
            inventoryWindow.y = (stage.stageHeight - inventoryWindow.height) / 2;
            activeWindow = inventoryWindow;
            addChild(inventoryWindow);
        });
        EventManager.listen(GUIEvent.OPEN_CRAFT_WINDOW, function(_)
        {
            if (craftWindow != null)
            {
                activeWindow = craftWindow;
                craftWindow.show();
                return;
            }

            craftWindow = new CraftWindow(c.inventory);
            craftWindow.x = (stage.stageWidth - craftWindow.width) / 2;
            craftWindow.y = (stage.stageHeight - craftWindow.height) / 2;
            activeWindow = craftWindow;
            addChild(craftWindow);
        });
        EventManager.listen(MapEvent.GATHERING_PROGRESS, function(e:MapEvent)
        {
            if (progressBar == null)
            {
                progressBar = new gui.ProgressBar();
                progressBar.x = (stage.stageWidth - progressBar.width) / 2;
                progressBar.y = (stage.stageHeight - progressBar.height) - 50;
                addChild(progressBar);
            }

            progressBar.update(e.data.lifepoint, e.data.max);
        });
        EventManager.listen(GUIEvent.CLOSE_ACTIVE_WINDOW, function(_)
        {
            activeWindow.close();
        });
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
