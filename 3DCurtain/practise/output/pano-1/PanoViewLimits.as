package 
{

    public class PanoViewLimits extends Object
    {
        public var min:Number;
        public var max:Number;
        public var def:Number;
        public var cur:Number;
        public var dest:Number;

        public function PanoViewLimits(param1:Number, param2:Number, param3:Number)
        {
            this.init(param1, param2, param3);
            return;
        }// end function

        public function init(param1:Number, param2:Number, param3:Number) : void
        {
            this.def = param1;
            this.min = param2;
            this.max = param3;
            this.cur = param1;
            return;
        }// end function

        public function toString() : String
        {
            return "" + this.cur + " (" + this.min + "," + this.max + ") def:" + this.def;
        }// end function

    }
}
