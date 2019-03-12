package 
{

    public class GgRectangle extends Object
    {
        public var x1:Number;
        public var x2:Number;
        public var y1:Number;
        public var y2:Number;

        public function GgRectangle(param1:Number, param2:Number, param3:Number, param4:Number)
        {
            this.x1 = param1;
            this.y1 = param2;
            this.x2 = param3;
            this.y2 = param4;
            return;
        }// end function

        public function isIn(param1:Number, param2:Number, param3:Number, param4:Number) : Boolean
        {
            return param1 <= this.x2 && param3 >= this.x1 && param2 <= this.y2 && param4 >= this.y1;
        }// end function

        public function isInRect(param1:GgRectangle) : Boolean
        {
            return param1.x1 <= this.x2 && param1.x2 >= this.x1 && param1.y1 <= this.y2 && param1.y2 >= this.y1;
        }// end function

        public function toString() : String
        {
            return "(" + this.x1 + "," + this.y1 + ")x(" + this.x2 + "," + this.y2 + ")";
        }// end function

    }
}
