package 
{
    import GgVector3d.*;

    public class GgVector3dEqui extends GgVector3d
    {
        public var r:Number;
        public var theta:Number;
        public var phi:Number;
        public var aphi:Number;

        public function GgVector3dEqui(param1:Number = 1, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0)
        {
            this.r = param1;
            this.phi = param3;
            this.theta = param2;
            this.u = param4;
            this.v = param5;
            this.aphi = 0;
            return;
        }// end function

        override public function clone() : GgVector3d
        {
            var _loc_1:* = null;
            _loc_1 = new GgVector3dEqui(this.r, this.theta, this.phi, u, v);
            _loc_1.x = x;
            _loc_1.y = y;
            _loc_1.z = z;
            _loc_1.px = px;
            _loc_1.py = py;
            _loc_1.pz = pz;
            return _loc_1;
        }// end function

        override public function cloneBase() : GgVector3d
        {
            var _loc_1:* = null;
            this.toXYZ();
            _loc_1 = new GgVector3d(x, y, z, u, v);
            _loc_1.px = px;
            _loc_1.py = py;
            _loc_1.pz = pz;
            return _loc_1;
        }// end function

        override public function type() : int
        {
            return 1;
        }// end function

        override public function rotx(param1:Number) : void
        {
            this.aphi = this.aphi + param1;
            return;
        }// end function

        override public function roty(param1:Number) : void
        {
            this.theta = this.theta + param1;
            return;
        }// end function

        override public function length() : Number
        {
            return this.r;
        }// end function

        public function toXYZ() : void
        {
            var _loc_1:* = NaN;
            _loc_1 = Math.cos(this.phi);
            x = this.r * _loc_1 * Math.sin(this.theta);
            y = this.r * Math.sin(this.phi);
            z = this.r * _loc_1 * Math.cos(this.theta);
            super.rotx(this.aphi);
            return;
        }// end function

        override public function project(param1:Number, param2:Number, param3:Number) : void
        {
            this.toXYZ();
            super.project(param1, param2, param3);
            return;
        }// end function

        override public function project3d(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
        {
            this.toXYZ();
            super.project3d(param3, param2, param3, param4, param5, param6);
            return;
        }// end function

        override public function interpol2(param1:GgVector3d, param2:GgVector3d, param3:Number) : void
        {
            var _loc_4:* = param1 as GgVector3dEqui;
            var _loc_5:* = param2 as GgVector3dEqui;
            if (_loc_4 && _loc_5)
            {
                this.r = _loc_4.r * param3 + _loc_5.r * (1 - param3);
                this.theta = _loc_4.theta * param3 + _loc_5.theta * (1 - param3);
                this.phi = _loc_4.phi * param3 + _loc_5.phi * (1 - param3);
                this.aphi = _loc_4.aphi * param3 + _loc_5.aphi * (1 - param3);
            }
            else
            {
                super.interpol2(param1, param2, param3);
            }
            return;
        }// end function

        override public function interpol2uv(param1:GgVector3d, param2:GgVector3d, param3:Number) : void
        {
            var _loc_4:* = param1 as GgVector3dEqui;
            var _loc_5:* = param2 as GgVector3dEqui;
            if (_loc_4 && _loc_5)
            {
                this.r = _loc_4.r * param3 + _loc_5.r * (1 - param3);
                this.theta = _loc_4.theta * param3 + _loc_5.theta * (1 - param3);
                this.phi = _loc_4.phi * param3 + _loc_5.phi * (1 - param3);
                this.aphi = _loc_4.aphi * param3 + _loc_5.aphi * (1 - param3);
                u = param1.u * param3 + param2.u * (1 - param3);
                v = param1.v * param3 + param2.v * (1 - param3);
            }
            else
            {
                super.interpol2(param1, param2, param3);
            }
            return;
        }// end function

        override public function interpol4(param1:GgVector3d, param2:GgVector3d, param3:GgVector3d, param4:GgVector3d, param5:Number, param6:Number) : void
        {
            var _loc_7:* = param1 as GgVector3dEqui;
            var _loc_8:* = param2 as GgVector3dEqui;
            var _loc_9:* = param3 as GgVector3dEqui;
            var _loc_10:* = param4 as GgVector3dEqui;
            if (_loc_7 && _loc_8 && _loc_9 && _loc_10)
            {
                this.r = (_loc_7.r * (1 - param5) + _loc_8.r * param5) * (1 - param6) + (_loc_9.r * (1 - param5) + _loc_10.r * param5) * param6;
                this.theta = (_loc_7.theta * (1 - param5) + _loc_8.theta * param5) * (1 - param6) + (_loc_9.theta * (1 - param5) + _loc_10.theta * param5) * param6;
                this.phi = (_loc_7.phi * (1 - param5) + _loc_8.phi * param5) * (1 - param6) + (_loc_9.phi * (1 - param5) + _loc_10.phi * param5) * param6;
                this.aphi = (_loc_7.aphi * (1 - param5) + _loc_8.aphi * param5) * (1 - param6) + (_loc_9.aphi * (1 - param5) + _loc_10.aphi * param5) * param6;
            }
            else
            {
                super.interpol4(param1, param2, param3, param4, param5, param6);
            }
            return;
        }// end function

        override public function interpol4uv(param1:GgVector3d, param2:GgVector3d, param3:GgVector3d, param4:GgVector3d, param5:Number, param6:Number) : void
        {
            var _loc_7:* = param1 as GgVector3dEqui;
            var _loc_8:* = param2 as GgVector3dEqui;
            var _loc_9:* = param3 as GgVector3dEqui;
            var _loc_10:* = param4 as GgVector3dEqui;
            if (_loc_7 && _loc_8 && _loc_9 && _loc_10)
            {
                this.r = (_loc_7.r * (1 - param5) + _loc_8.r * param5) * (1 - param6) + (_loc_9.r * (1 - param5) + _loc_10.r * param5) * param6;
                this.theta = (_loc_7.theta * (1 - param5) + _loc_8.theta * param5) * (1 - param6) + (_loc_9.theta * (1 - param5) + _loc_10.theta * param5) * param6;
                this.phi = (_loc_7.phi * (1 - param5) + _loc_8.phi * param5) * (1 - param6) + (_loc_9.phi * (1 - param5) + _loc_10.phi * param5) * param6;
                this.aphi = (_loc_7.aphi * (1 - param5) + _loc_8.aphi * param5) * (1 - param6) + (_loc_9.aphi * (1 - param5) + _loc_10.aphi * param5) * param6;
                u = (param1.u * (1 - param5) + param2.u * param5) * (1 - param6) + (param3.u * (1 - param5) + param4.u * param5) * param6;
                v = (param1.v * (1 - param5) + param2.v * param5) * (1 - param6) + (param3.v * (1 - param5) + param4.v * param5) * param6;
            }
            else
            {
                super.interpol4uv(param1, param2, param3, param4, param5, param6);
            }
            return;
        }// end function

        override public function toString() : String
        {
            return "EQ (" + this.r + "," + this.theta * 180 / Math.PI + "," + this.phi * 180 / Math.PI + ") - (" + px + "," + py + ") , (u:" + u + ",v:" + v + ")";
        }// end function

    }
}
