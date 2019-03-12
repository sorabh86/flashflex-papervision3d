package 
{
    import flash.display.*;
    import flash.geom.*;

    public class Hotspot extends Object
    {
        public var clip:Sprite;
        public var ofs:Point;
        public var posPan:Number;
        public var posTilt:Number;
        public var id:String;
        public var onCallback:Function;
        public var url:String;
        public var target:String;
        public var title:String;
        public var isArea:Boolean = false;
        public var position:Point;
        public var polygon:Array;
        public var objpolys:Array;
        public var objloc:Array;
        public var outline:Array;
        public var targetAlpha:Number;
        public var currentAlpha:Number;
        public var backgroundColor:uint = 16711680;
        public var backgroundAlpha:Number = 0.5;
        public var borderColor:uint = 16711680;
        public var borderAlpha:Number = 0.5;
        public var reuse:int = 0;

        public function Hotspot()
        {
            this.ofs = new Point();
            this.position = new Point();
            this.targetAlpha = 0;
            this.currentAlpha = 0;
            return;
        }// end function

        public function toString() : String
        {
            return "(" + this.posPan + "," + this.posTilt + ": " + this.title + ", " + this.url + ")";
        }// end function

    }
}
