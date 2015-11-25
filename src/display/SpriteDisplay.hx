package display;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

class SpriteDisplay extends Bitmap
{
    var source:BitmapData;
    var dest:BitmapData;
    var cellSize:Point;

    public function new(data:BitmapData, cols:Int, rows:Int)
    {
        cellSize = new Point(data.width / cols, data.height / rows);
        dest = new BitmapData(Std.int(cellSize.x), Std.int(cellSize.y), true, 0x00000000);
        this.source = data;

        super(dest);
    }

    public function set(col:Int, row:Int)
    {
        dest.copyPixels(source, new Rectangle(cellSize.x * col, cellSize.y * row, cellSize.x, cellSize.y), new Point(0 ,0));
    }
}
