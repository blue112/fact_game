import events.BuildEvent;
import events.GUIEvent;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import haxe.ds.IntMap;

class Controller
{
    var keys:IntMap<Bool>;
    var char:Character;

    public function new(char:Character)
    {
        keys = new IntMap();
        this.char = char;

        var s = flash.Lib.current.stage;

        s.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        s.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        s.addEventListener(Event.ENTER_FRAME, moveCharacter);
    }

    private function onKeyDown(e:KeyboardEvent)
    {
        keys.set(e.keyCode, true);
    }

    private function onKeyUp(e:KeyboardEvent)
    {
        if (e.keyCode == Keyboard.I) //Inventory open request
        {
            EventManager.dispatch(new GUIEvent(GUIEvent.OPEN_INVENTORY));
        }
        else if (e.keyCode == Keyboard.C) //Craft open request
        {
            EventManager.dispatch(new GUIEvent(GUIEvent.OPEN_CRAFT_WINDOW));
        }
        else if (e.keyCode == Keyboard.R) //Rotate hovered build
        {
            EventManager.dispatch(new BuildEvent(BuildEvent.ROTATE_BUILDING));
        }
        else if (e.keyCode == Keyboard.ESCAPE) //Close active window
        {
            EventManager.dispatch(new GUIEvent(GUIEvent.CLOSE_ACTIVE_WINDOW));
        }

        keys.set(e.keyCode, false);
    }

    private function isKeyDown(key:Int)
    {
        return (keys.exists(key) && keys.get(key));
    }

    private function moveCharacter(_)
    {
        if (isKeyDown(Keyboard.LEFT))
        {
            char.pos_x--;
        }
        else if (isKeyDown(Keyboard.RIGHT))
        {
            char.pos_x++;
        }
        if (isKeyDown(Keyboard.UP))
        {
            char.pos_y--;
        }
        else if (isKeyDown(Keyboard.DOWN))
        {
            char.pos_y++;
        }
    }
}
