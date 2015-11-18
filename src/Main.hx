import flash.display.Sprite;

class Main extends Sprite
{
    public function new()
    {
        super();

        flash.Lib.current.addChild(this);

        var map = new Map();

        var c = new Character();

        var viewport = new Viewport(stage.stageWidth, stage.stageHeight, map, c);

        addChild(map);

        map.setCharacter(c);

        var controller = new Controller(c);
    }

    static public function main()
    {
        var app = new Main();
    }
}
