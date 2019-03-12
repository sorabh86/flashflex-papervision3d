package 
{
    import __AS3__.vec.*;

    public class RenderTile10 extends RenderTile
    {

        public function RenderTile10()
        {
            return;
        }// end function

        override public function displayTile(param1:GgVector3d, param2:GgVector3d, param3:GgVector3d, param4:GgVector3d, param5:Number) : void
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
            var _loc_19:* = NaN;
            var _loc_6:* = new Array();
            var _loc_7:* = 1;
            var _loc_8:* = 1;
            var _loc_9:* = 1;
            _loc_7 = param5;
            if (_loc_7 < 1)
            {
                _loc_7 = 1;
            }
            if (param1.type() == 0)
            {
                rednerTileOverlap(param1, param2, param3, param4, false);
            }
            else
            {
                _loc_6.push(param1);
                _loc_6.push(param2);
                _loc_6.push(param4);
                _loc_6.push(param3);
                _loc_6 = clipFrustumSave(_loc_6);
                if (_loc_6.length > 0)
                {
                    _loc_10 = false;
                    if (_loc_6.length == 4)
                    {
                        if (_loc_6[0] == param1 && _loc_6[1] == param2 && _loc_6[2] == param4 && _loc_6[3] == param3)
                        {
                            _loc_6 = clipFrustum(_loc_6);
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
                    if (param1.type() == 2)
                    {
                        _loc_9 = 1;
                    }
                    _loc_17 = 1 / _loc_8;
                    _loc_18 = 1 / _loc_9;
                    _loc_12 = 0;
                    while (_loc_12 < _loc_9)
                    {
                        
                        _loc_11 = 0;
                        while (_loc_11 < _loc_8)
                        {
                            
                            _loc_19 = 1;
                            _loc_13.interpol4uv(param1, param2, param3, param4, _loc_11 * _loc_17, _loc_12 * _loc_18);
                            _loc_14.interpol4uv(param1, param2, param3, param4, (_loc_11 + _loc_19) * _loc_17, _loc_12 * _loc_18);
                            _loc_15.interpol4uv(param1, param2, param3, param4, _loc_11 * _loc_17, (_loc_12 + _loc_19) * _loc_18);
                            _loc_16.interpol4uv(param1, param2, param3, param4, (_loc_11 + _loc_19) * _loc_17, (_loc_12 + _loc_19) * _loc_18);
                            rednerTileOverlap(_loc_13.cloneBase(), _loc_14.cloneBase(), _loc_15.cloneBase(), _loc_16.cloneBase(), _loc_10);
                            _loc_11++;
                        }
                        _loc_12++;
                    }
                }
            }
            return;
        }// end function

        override public function rednerTile(param1:GgVector3d, param2:GgVector3d, param3:GgVector3d, param4:GgVector3d, param5:Boolean) : void
        {
            var _loc_8:* = 0;
            var _loc_6:* = rect.width >> 1;
            var _loc_7:* = rect.height >> 1;
            var _loc_9:* = new Array();
            _loc_9.push(param1);
            _loc_9.push(param2);
            _loc_9.push(param4);
            _loc_9.push(param3);
            if (!param5)
            {
                _loc_9 = clipFrustum(_loc_9);
            }
            var _loc_10:* = new Vector.<Number>;
            var _loc_11:* = new Vector.<Number>;
            var _loc_12:* = new Vector.<int>;
            _loc_8 = 0;
            while (_loc_8 < _loc_9.length)
            {
                
                _loc_9[_loc_8].project(ed, _loc_6, _loc_7);
                _loc_10.push(_loc_9[_loc_8].px, _loc_9[_loc_8].py);
                _loc_11.push(_loc_9[_loc_8].u, _loc_9[_loc_8].v, 1 / _loc_9[_loc_8].cz);
                if (_loc_8 >= 2)
                {
                    _loc_12.push(0, (_loc_8 - 1), _loc_8);
                }
                _loc_8++;
            }
            canv.graphics.beginBitmapFill(bmp, null, false, bmpSmooth);
            canv.graphics.drawTriangles(_loc_10, _loc_12, _loc_11);
            canv.graphics.endFill();
            return;
        }// end function

    }
}
