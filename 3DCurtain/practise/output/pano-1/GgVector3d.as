package 
{
    import GgVector3d.*;
    import flash.geom.*;

    public class GgVector3d extends Object
    {
        protected var x:Number;
        protected var y:Number;
        protected var z:Number;
        public var px:Number;
        public var py:Number;
        public var pz:Number;
        public var u:Number;
        public var v:Number;
        public var t:Number;

        public function GgVector3d(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0)
        {
            this.x = param1;
            this.y = param2;
            this.z = param3;
            this.u = param4;
            this.v = param5;
            return;
        }// end function

        public function clone() : GgVector3d
        {
            var _loc_1:* = null;
            _loc_1 = new GgVector3d(this.x, this.y, this.z, this.u, this.v);
            _loc_1.px = this.px;
            _loc_1.py = this.py;
            _loc_1.pz = this.pz;
            return _loc_1;
        }// end function

        public function cloneBase() : GgVector3d
        {
            var _loc_1:* = null;
            _loc_1 = new GgVector3d(this.x, this.y, this.z, this.u, this.v);
            _loc_1.px = this.px;
            _loc_1.py = this.py;
            _loc_1.pz = this.pz;
            return _loc_1;
        }// end function

        public function type() : int
        {
            return 0;
        }// end function

        public function get cx() : Number
        {
            return this.x;
        }// end function

        public function get cy() : Number
        {
            return this.y;
        }// end function

        public function get cz() : Number
        {
            return this.z;
        }// end function

        public function init(param1:Number, param2:Number, param3:Number) : void
        {
            this.x = param1;
            this.y = param2;
            this.z = param3;
            return;
        }// end function

        public function move(param1:Number, param2:Number, param3:Number) : void
        {
            this.x = this.x + param1;
            this.y = this.y + param2;
            this.z = this.z + param3;
            return;
        }// end function

        public function scale(param1:Number, param2:Number, param3:Number) : void
        {
            this.x = this.x * param1;
            this.y = this.y * param2;
            this.z = this.z * param3;
            return;
        }// end function

        public function rotx(param1:Number) : void
        {
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            _loc_5 = Math.sin(param1);
            _loc_4 = Math.cos(param1);
            _loc_2 = _loc_4 * this.y + _loc_5 * this.z;
            _loc_3 = (-_loc_5) * this.y + _loc_4 * this.z;
            this.y = _loc_2;
            this.z = _loc_3;
            return;
        }// end function

        public function rotx_xyz(param1:Number) : void
        {
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            _loc_5 = Math.sin(param1);
            _loc_4 = Math.cos(param1);
            _loc_2 = _loc_4 * this.y + _loc_5 * this.z;
            _loc_3 = (-_loc_5) * this.y + _loc_4 * this.z;
            this.y = _loc_2;
            this.z = _loc_3;
            return;
        }// end function

        public function roty(param1:Number) : void
        {
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            _loc_5 = Math.sin(param1);
            _loc_4 = Math.cos(param1);
            _loc_2 = _loc_4 * this.x - _loc_5 * this.z;
            _loc_3 = _loc_5 * this.x + _loc_4 * this.z;
            this.x = _loc_2;
            this.z = _loc_3;
            return;
        }// end function

        public function rotz(param1:Number) : void
        {
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            _loc_5 = Math.sin(param1);
            _loc_4 = Math.cos(param1);
            _loc_2 = _loc_4 * this.x - _loc_5 * this.y;
            _loc_3 = _loc_5 * this.x + _loc_4 * this.y;
            this.x = _loc_2;
            this.y = _loc_3;
            return;
        }// end function

        public function sub(param1:GgVector3d) : GgVector3d
        {
            var _loc_2:* = new GgVector3d();
            _loc_2.x = this.x - param1.x;
            _loc_2.y = this.y - param1.y;
            _loc_2.z = this.z - param1.z;
            return _loc_2;
        }// end function

        public function length() : Number
        {
            return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
        }// end function

        public function prod(param1:GgVector3d) : Number
        {
            return this.x * param1.x + this.y * param1.y + this.z * param1.z;
        }// end function

        public function fromPanTilt(param1:Number, param2:Number) : void
        {
            var _loc_3:* = NaN;
            _loc_3 = -Math.cos(param2 * Math.PI / 180);
            this.x = _loc_3 * Math.sin(param1 * Math.PI / 180);
            this.y = Math.sin(param2 * Math.PI / 180);
            this.z = _loc_3 * Math.cos(param1 * Math.PI / 180);
            return;
        }// end function

        public function asPan() : Number
        {
            return Math.atan2(-this.x, -this.z) * 180 / Math.PI;
        }// end function

        public function asTilt() : Number
        {
            return Math.asin(this.y / this.length()) * 180 / Math.PI;
        }// end function

        public function project(param1:Number, param2:Number, param3:Number) : void
        {
            var _loc_4:* = NaN;
            this.pz = this.z;
            if (this.z < 0)
            {
                _loc_4 = (-param1) / this.z;
                if (Math.abs(this.z) < 1e-005)
                {
                    _loc_4 = this.z > 0 ? (-10000) : (10000);
                }
                this.px = this.x * _loc_4;
                this.py = this.y * _loc_4;
                this.px = this.px + param2;
                this.py = this.py + param3;
            }
            else
            {
                this.px = this.x * 1000;
                this.py = this.y * 1000;
            }
            return;
        }// end function

        public function project3d(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
        {
            this.pz = this.z;
            if (this.z < 0)
            {
                if (Math.abs(this.z) < 1e-005)
                {
                }
                this.px = param4 * (this.z * param1 - this.x * param3) / (this.z - param3);
                this.py = param4 * (this.z * param2 - this.y * param3) / (this.z - param3);
                this.t = param3 / (this.z + param3);
                this.px = this.px + param5;
                this.py = this.py + param6;
            }
            else
            {
                this.px = this.x * 1000;
                this.py = this.y * 1000;
                this.t = 1;
            }
            return;
        }// end function

        public function asPoint() : Point
        {
            var _loc_1:* = new Point();
            _loc_1.x = this.px;
            _loc_1.y = this.py;
            return _loc_1;
        }// end function

        public function cp(param1:GgVector3d) : void
        {
            param1.x = this.x;
            param1.y = this.y;
            param1.z = this.z;
            param1.px = this.px;
            param1.py = this.py;
            param1.u = this.u;
            param1.v = this.v;
            param1.t = this.t;
            return;
        }// end function

        public function pdist2(param1:GgVector3d) : Number
        {
            return (param1.px - this.px) * (param1.px - this.px) + (param1.py - this.py) * (param1.py - this.py);
        }// end function

        public function interpol2(param1:GgVector3d, param2:GgVector3d, param3:Number) : void
        {
            this.x = param1.x * param3 + param2.x * (1 - param3);
            this.y = param1.y * param3 + param2.y * (1 - param3);
            this.z = param1.z * param3 + param2.z * (1 - param3);
            return;
        }// end function

        public function interpol2uv(param1:GgVector3d, param2:GgVector3d, param3:Number) : void
        {
            this.x = param1.x * param3 + param2.x * (1 - param3);
            this.y = param1.y * param3 + param2.y * (1 - param3);
            this.z = param1.z * param3 + param2.z * (1 - param3);
            this.u = param1.u * param3 + param2.u * (1 - param3);
            this.v = param1.v * param3 + param2.v * (1 - param3);
            return;
        }// end function

        public function interpol4(param1:GgVector3d, param2:GgVector3d, param3:GgVector3d, param4:GgVector3d, param5:Number, param6:Number) : void
        {
            this.x = (param1.x * (1 - param5) + param2.x * param5) * (1 - param6) + (param3.x * (1 - param5) + param4.x * param5) * param6;
            this.y = (param1.y * (1 - param5) + param2.y * param5) * (1 - param6) + (param3.y * (1 - param5) + param4.y * param5) * param6;
            this.z = (param1.z * (1 - param5) + param2.z * param5) * (1 - param6) + (param3.z * (1 - param5) + param4.z * param5) * param6;
            return;
        }// end function

        public function interpol4uv(param1:GgVector3d, param2:GgVector3d, param3:GgVector3d, param4:GgVector3d, param5:Number, param6:Number) : void
        {
            this.x = (param1.x * (1 - param5) + param2.x * param5) * (1 - param6) + (param3.x * (1 - param5) + param4.x * param5) * param6;
            this.y = (param1.y * (1 - param5) + param2.y * param5) * (1 - param6) + (param3.y * (1 - param5) + param4.y * param5) * param6;
            this.z = (param1.z * (1 - param5) + param2.z * param5) * (1 - param6) + (param3.z * (1 - param5) + param4.z * param5) * param6;
            this.u = (param1.u * (1 - param5) + param2.u * param5) * (1 - param6) + (param3.u * (1 - param5) + param4.u * param5) * param6;
            this.v = (param1.v * (1 - param5) + param2.v * param5) * (1 - param6) + (param3.v * (1 - param5) + param4.v * param5) * param6;
            return;
        }// end function

        public function toString() : String
        {
            return "(" + this.x + "," + this.y + "," + this.z + ") - (" + this.px + "," + this.py + ") , (u:" + this.u + ",v:" + this.v + ")";
        }// end function

    }
}
