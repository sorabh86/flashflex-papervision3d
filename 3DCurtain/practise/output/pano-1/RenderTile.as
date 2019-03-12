package 
{
    import RenderTile.*;
    import flash.display.*;
    import flash.geom.*;

    public class RenderTile extends MovieClip
    {
        public var rect:Rectangle;
        public var ed:Number;
        public var canv:Sprite;
        public var canvOv:Sprite;
        public var bmpSmooth:Boolean;
        public var isCylinder:Boolean;
        public var bmp:BitmapData = null;
        public var bmp_ov:BitmapData = null;
        public var tileOverlap:Number = 10;
        public var tileWidth:Number = 0;
        public var tileHeight:Number = 0;
        protected var np:GgVector3d;
        protected var fl:GgVector3d;
        protected var fr:GgVector3d;
        protected var ft:GgVector3d;
        protected var fb:GgVector3d;
        protected var fsl:GgVector3d;
        protected var fsr:GgVector3d;
        protected var fst:GgVector3d;
        protected var fsb:GgVector3d;

        public function RenderTile()
        {
            this.bmpSmooth = true;
            this.isCylinder = false;
            this.np = new GgVector3d();
            this.np.init(0, 0, -1);
            this.fl = new GgVector3d();
            this.fr = new GgVector3d();
            this.ft = new GgVector3d();
            this.fb = new GgVector3d();
            this.fsl = new GgVector3d();
            this.fsr = new GgVector3d();
            this.fst = new GgVector3d();
            this.fsb = new GgVector3d();
            return;
        }// end function

        public function clipPlane(param1:Array, param2:GgVector3d, param3:Number) : Array
        {
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            if (param1.length == 0)
            {
                return param1;
            }
            var _loc_11:* = new Array();
            _loc_4 = param2.prod(param1[0]) - param3;
            _loc_7 = 0;
            while (_loc_7 < param1.length)
            {
                
                _loc_9 = _loc_7;
                if (++_loc_7 == param1.length)
                {
                    ++_loc_7 = 0;
                }
                _loc_5 = param2.prod(param1[++_loc_7]) - param3;
                if (_loc_4 >= 0 && _loc_5 >= 0)
                {
                    _loc_11.push(param1[_loc_9]);
                }
                else if (_loc_4 >= 0 || _loc_5 >= 0)
                {
                    _loc_6 = _loc_5 / (_loc_5 - _loc_4);
                    if (_loc_6 < 0)
                    {
                        _loc_6 = 0;
                    }
                    if (_loc_6 > 1)
                    {
                        _loc_6 = 1;
                    }
                    _loc_8 = new GgVector3d();
                    _loc_8.interpol2uv(param1[_loc_9], param1[_loc_10], _loc_6);
                    if (_loc_4 < 0)
                    {
                        _loc_11.push(_loc_8);
                    }
                    else
                    {
                        _loc_11.push(param1[_loc_9]);
                        _loc_11.push(_loc_8);
                    }
                }
                _loc_4 = _loc_5;
                _loc_7++;
            }
            return _loc_11;
        }// end function

        public function initFrustum(param1:Number, param2:Number, param3:Number) : void
        {
            var _loc_4:* = Math.atan2((param1 + 1), param3);
            var _loc_5:* = Math.atan2((param2 + 1), param3);
            var _loc_6:* = Math.sin(_loc_4);
            var _loc_7:* = Math.sin(_loc_5);
            var _loc_8:* = Math.cos(_loc_4);
            var _loc_9:* = Math.cos(_loc_5);
            this.fl.init(_loc_8, 0, -_loc_6);
            this.fr.init(-_loc_8, 0, -_loc_6);
            this.ft.init(0, _loc_9, -_loc_7);
            this.fb.init(0, -_loc_9, -_loc_7);
            return;
        }// end function

        public function initFrustumSave(param1:Number, param2:Number, param3:Number) : void
        {
            var _loc_4:* = Math.atan2(param1, param3);
            var _loc_5:* = Math.atan2(param2, param3);
            var _loc_6:* = Math.sin(_loc_4);
            var _loc_7:* = Math.sin(_loc_5);
            var _loc_8:* = Math.cos(_loc_4);
            var _loc_9:* = Math.cos(_loc_5);
            this.fsl.init(_loc_8, 0, -_loc_6);
            this.fsr.init(-_loc_8, 0, -_loc_6);
            this.fst.init(0, _loc_9, -_loc_7);
            this.fsb.init(0, -_loc_9, -_loc_7);
            return;
        }// end function

        public function clipFrustum(param1:Array) : Array
        {
            param1 = this.clipPlane(param1, this.np, 0);
            param1 = this.clipPlane(param1, this.fl, 0);
            param1 = this.clipPlane(param1, this.fr, 0);
            param1 = this.clipPlane(param1, this.ft, 0);
            param1 = this.clipPlane(param1, this.fb, 0);
            return param1;
        }// end function

        public function clipFrustumSave(param1:Array) : Array
        {
            param1 = this.clipPlane(param1, this.np, 0);
            param1 = this.clipPlane(param1, this.fsl, 0);
            param1 = this.clipPlane(param1, this.fsr, 0);
            param1 = this.clipPlane(param1, this.fst, 0);
            param1 = this.clipPlane(param1, this.fsb, 0);
            return param1;
        }// end function

        public function displayTile(param1:GgVector3d, param2:GgVector3d, param3:GgVector3d, param4:GgVector3d, param5:Number) : void
        {
            var _loc_10:* = false;
            var _loc_11:* = 0;
            var _loc_12:* = 0;
            var _loc_13:* = null;
            var _loc_14:* = null;
            var _loc_15:* = null;
            var _loc_16:* = null;
            var _loc_17:* = NaN;
            var _loc_18:* = NaN;
            var _loc_6:* = new Array();
            var _loc_7:* = 1;
            var _loc_8:* = 1;
            var _loc_9:* = 1;
            _loc_7 = param5;
            if (_loc_7 < 1)
            {
                _loc_7 = 1;
            }
            _loc_6.push(param1);
            _loc_6.push(param2);
            _loc_6.push(param4);
            _loc_6.push(param3);
            _loc_6 = this.clipFrustumSave(_loc_6);
            if (_loc_6.length > 0)
            {
                _loc_10 = false;
                if (_loc_6.length == 4)
                {
                    if (_loc_6[0] == param1 && _loc_6[1] == param2 && _loc_6[2] == param4 && _loc_6[3] == param3)
                    {
                        _loc_6 = this.clipFrustum(_loc_6);
                        if (_loc_6.length == 4)
                        {
                            _loc_10 = _loc_6[0] == param1 && _loc_6[1] == param2 && _loc_6[2] == param4 && _loc_6[3] == param3;
                        }
                    }
                }
                _loc_13 = param1.clone();
                _loc_14 = param2.clone();
                _loc_15 = param3.clone();
                _loc_16 = param4.clone();
                _loc_8 = _loc_7;
                _loc_9 = _loc_7;
                _loc_17 = 1 / _loc_8;
                _loc_18 = 1 / _loc_9;
                _loc_12 = 0;
                while (_loc_12 < _loc_9)
                {
                    
                    _loc_11 = 0;
                    while (_loc_11 < _loc_8)
                    {
                        
                        _loc_13.interpol4uv(param1, param2, param3, param4, _loc_11 * _loc_17, _loc_12 * _loc_18);
                        _loc_14.interpol4uv(param1, param2, param3, param4, (_loc_11 + 1) * _loc_17, _loc_12 * _loc_18);
                        _loc_15.interpol4uv(param1, param2, param3, param4, _loc_11 * _loc_17, (_loc_12 + 1) * _loc_18);
                        _loc_16.interpol4uv(param1, param2, param3, param4, (_loc_11 + 1) * _loc_17, (_loc_12 + 1) * _loc_18);
                        this.rednerTileOverlap(_loc_13.cloneBase(), _loc_14.cloneBase(), _loc_15.cloneBase(), _loc_16.cloneBase(), _loc_10);
                        _loc_11++;
                    }
                    _loc_12++;
                }
            }
            return;
        }// end function

        public function rednerTileOverlap(param1:GgVector3d, param2:GgVector3d, param3:GgVector3d, param4:GgVector3d, param5:Boolean) : void
        {
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = NaN;
            var _loc_11:* = NaN;
            if (this.bmp == null)
            {
                return;
            }
            if (this.tileOverlap > 0)
            {
                _loc_6 = new GgVector3d();
                _loc_7 = new GgVector3d();
                _loc_8 = new GgVector3d();
                _loc_9 = new GgVector3d();
                _loc_10 = 0.5 * (Number(this.bmp.width) / Number(this.bmp.width - 2 * this.tileOverlap) - 1);
                _loc_11 = 0.5 * (Number(this.bmp.height) / Number(this.bmp.height - 2 * this.tileOverlap) - 1);
                param1.u = (param1.u * this.tileWidth + this.tileOverlap) / this.bmp.width;
                param4.u = (param4.u * this.tileWidth + this.tileOverlap) / this.bmp.width;
                param1.v = (param1.v * this.tileHeight + this.tileOverlap) / this.bmp.height;
                param4.v = (param4.v * this.tileHeight + this.tileOverlap) / this.bmp.height;
                param2.u = param4.u;
                param2.v = param1.v;
                param3.u = param1.u;
                param3.v = param4.v;
                _loc_6.interpol4uv(param1, param2, param3, param4, -_loc_10, -_loc_11);
                _loc_7.interpol4uv(param1, param2, param3, param4, 1 + _loc_10, -_loc_11);
                _loc_8.interpol4uv(param1, param2, param3, param4, -_loc_10, 1 + _loc_11);
                _loc_9.interpol4uv(param1, param2, param3, param4, 1 + _loc_10, 1 + _loc_11);
                this.rednerTile(_loc_6, _loc_7, _loc_8, _loc_9, param5);
            }
            else
            {
                this.rednerTile(param1, param2, param3, param4, param5);
            }
            return;
        }// end function

        public function rednerTile(param1:GgVector3d, param2:GgVector3d, param3:GgVector3d, param4:GgVector3d, param5:Boolean) : void
        {
            var _loc_10:* = null;
            var _loc_11:* = 0;
            var _loc_12:* = NaN;
            var _loc_13:* = NaN;
            var _loc_6:* = this.rect.width >> 1;
            var _loc_7:* = this.rect.height >> 1;
            if (this.bmp == null)
            {
                return;
            }
            var _loc_8:* = new Matrix();
            var _loc_9:* = new Matrix();
            _loc_10 = new Array();
            _loc_10.push(param1);
            _loc_10.push(param2);
            _loc_10.push(param4);
            _loc_10.push(param3);
            _loc_10 = this.clipFrustum(_loc_10);
            param1.project(this.ed, _loc_6, _loc_7);
            param2.project(this.ed, _loc_6, _loc_7);
            param3.project(this.ed, _loc_6, _loc_7);
            param4.project(this.ed, _loc_6, _loc_7);
            if (_loc_10.length > 0)
            {
                _loc_12 = this.bmp.width;
                _loc_13 = this.bmp.height;
                _loc_8.a = (param2.px - param1.px) / (_loc_12 * (param2.u - param1.u));
                _loc_8.b = (param2.py - param1.py) / (_loc_12 * (param2.u - param1.u));
                _loc_8.c = (param4.px - param2.px) / (_loc_13 * (param4.v - param2.v));
                _loc_8.d = (param4.py - param2.py) / (_loc_13 * (param4.v - param2.v));
                _loc_8.tx = param1.px - _loc_12 * param1.u * _loc_8.a - _loc_13 * param1.v * _loc_8.c;
                _loc_8.ty = param1.py - _loc_12 * param1.u * _loc_8.b - _loc_13 * param1.v * _loc_8.d;
                _loc_9.a = (param4.px - param3.px) / (_loc_12 * (param2.u - param1.u));
                _loc_9.b = (param4.py - param3.py) / (_loc_12 * (param2.u - param1.u));
                _loc_9.c = (param3.px - param1.px) / (_loc_13 * (param4.v - param2.v));
                _loc_9.d = (param3.py - param1.py) / (_loc_13 * (param4.v - param2.v));
                _loc_9.tx = param1.px - _loc_12 * param1.u * _loc_9.a - _loc_13 * param1.v * _loc_9.c;
                _loc_9.ty = param1.py - _loc_12 * param1.u * _loc_9.b - _loc_13 * param1.v * _loc_9.d;
                this.canv.graphics.beginBitmapFill(this.bmp, _loc_8, false, this.bmpSmooth);
                this.canv.graphics.moveTo(param1.px, param1.py);
                this.canv.graphics.lineTo(param2.px, param2.py);
                this.canv.graphics.lineTo(param4.px, param4.py);
                this.canv.graphics.endFill();
                this.canv.graphics.beginBitmapFill(this.bmp, _loc_9, false, this.bmpSmooth);
                this.canv.graphics.moveTo(param1.px, param1.py);
                this.canv.graphics.lineTo(param3.px, param3.py);
                this.canv.graphics.lineTo(param4.px, param4.py);
                this.canv.graphics.endFill();
                if (this.bmp_ov != null)
                {
                    this.canvOv.graphics.beginBitmapFill(this.bmp_ov, _loc_8, false, this.bmpSmooth);
                    this.canvOv.graphics.moveTo(param1.px, param1.py);
                    this.canvOv.graphics.lineTo(param2.px, param2.py);
                    this.canvOv.graphics.lineTo(param4.px, param4.py);
                    this.canvOv.graphics.endFill();
                    this.canvOv.graphics.beginBitmapFill(this.bmp_ov, _loc_9, false, this.bmpSmooth);
                    this.canvOv.graphics.moveTo(param1.px, param1.py);
                    this.canvOv.graphics.lineTo(param3.px, param3.py);
                    this.canvOv.graphics.lineTo(param4.px, param4.py);
                    this.canvOv.graphics.endFill();
                }
            }
            return;
        }// end function

    }
}
