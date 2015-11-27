import events.BuildEvent;
import events.GameEvent;
import events.GUIEvent;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import haxe.ds.IntMap;

class Controller
{
    var keys:IntMap<Bool>;
    var char:Character;

    var moveProgress:Int;
    static private inline var FRAME_TO_MOVE = 5;

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
        else if (e.keyCode == Keyboard.S) //Save map
        {
            EventManager.dispatch(new GameEvent(GameEvent.SAVE));
        }
        else if (e.keyCode == Keyboard.F1) //Debug window
        {
            EventManager.dispatch(new GUIEvent(GUIEvent.OPEN_DEBUG_WINDOW));
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
            if (canMove())
            {
                char.set_direction(Character.DIRECTION_LEFT);
                char.set_walking(true);
                char.pos_x--;
            }
        }
        else if (isKeyDown(Keyboard.RIGHT))
        {
            if (canMove())
            {
                char.set_direction(Character.DIRECTION_RIGHT);
                char.set_walking(true);
                char.pos_x++;
            }
        }
        else if (isKeyDown(Keyboard.UP))
        {
            if (canMove())
            {
                char.set_direction(Character.DIRECTION_UP);
                char.set_walking(true);
                char.pos_y--;
            }
        }
        else if (isKeyDown(Keyboard.DOWN))
        {
            if (canMove())
            {
                char.set_direction(Character.DIRECTION_DOWN);
                char.set_walking(true);
                char.pos_y++;
            }
        }
        else
        {
            char.set_walking(false);
        }
    }

    private function canMove()
    {
        if (moveProgress < FRAME_TO_MOVE)
        {
            moveProgress++;
            return false;
        }

        moveProgress = 0;
        return true;
    }
}
