package 
{
    import Panorama.*;
    import PanoramaCube.*;
    import flash.display.*;
    import flash.geom.*;

    public class PanoramaCube extends Panorama
    {
        public var cubeTiles:Number;
        protected var va:Array;
        protected var vat:Array;
        protected var cubeWidth:Number = 1;
        public var meshBase:Number = 10;
        public var meshAuto:Boolean = true;
        protected var tileScale:Number = 1;

        public function PanoramaCube()
        {
            this.va = new Array();
            this.vat = new Array();
            this.cubeTiles = 10;
            return;
        }// end function

        override public function initBitmaps() : void
        {
            var _loc_1:* = 0;
            _loc_1 = 0;
            while (_loc_1 < 6)
            {
                
                if (bmpTile[_loc_1] == null && tileSize > 0)
                {
                    bmpTile[_loc_1] = new BitmapData(tileSize, tileSize, transparentImage, preloadColor);
                    if (hasOverlay && bmpTileOverlay[_loc_1] == null)
                    {
                        bmpTileOverlay[_loc_1] = new BitmapData(tileSize, tileSize, true);
                    }
                    if (preloadColor >= 16777216)
                    {
                        bmpTile[_loc_1].noise(23, 0, 95, 7, true);
                    }
                }
                _loc_1++;
            }
            return;
        }// end function

        override public function getVFov() : Number
        {
            var _loc_1:* = NaN;
            var _loc_2:* = NaN;
            var _loc_3:* = viewer.fovMode;
            switch(_loc_3)
            {
                case 0:
                {
                    _loc_2 = fov.cur / 2;
                    break;
                }
                case 1:
                {
                    _loc_2 = Math.atan(rect.height / rect.width * Math.tan(fov.cur / 2 * Math.PI / 180)) * 180 / Math.PI;
                    break;
                }
                case 2:
                {
                    _loc_1 = Math.sqrt(rect.width * rect.width + rect.height * rect.height);
                    _loc_2 = Math.atan(rect.height / _loc_1 * Math.tan(fov.cur / 2 * Math.PI / 180)) * 180 / Math.PI;
                    break;
                }
                case 3:
                {
                    if (rect.height * 4 / 3 > rect.width)
                    {
                        _loc_2 = fov.cur / 2;
                    }
                    else
                    {
                        _loc_2 = Math.atan(rect.height * 4 / (rect.width * 3) * Math.tan(fov.cur / 2 * Math.PI / 180)) * 180 / Math.PI;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _loc_2 * 2;
        }// end function

        override public function setVFov(param1:Number) : void
        {
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            var _loc_2:* = viewer.fovMode;
            var _loc_3:* = param1 / 2;
            switch(_loc_2)
            {
                case 0:
                {
                    fov.cur = _loc_3 * 2;
                    break;
                }
                case 1:
                {
                    _loc_4 = Math.atan(rect.width / rect.height * Math.tan(_loc_3 * Math.PI / 180)) * 180 / Math.PI;
                    fov.cur = _loc_4 * 2;
                    break;
                }
                case 2:
                {
                    _loc_6 = Math.sqrt(rect.width * rect.width + rect.height * rect.height);
                    _loc_5 = Math.atan(_loc_6 / rect.height * Math.tan(_loc_3 * Math.PI / 180)) * 180 / Math.PI;
                    fov.cur = _loc_5 * 2;
                    break;
                }
                case 3:
                {
                    if (rect.height * 4 / 3 > rect.width)
                    {
                        fov.cur = _loc_3 * 2;
                    }
                    else
                    {
                        _loc_4 = Math.atan(rect.width * 3 / (rect.height * 4) * Math.tan(_loc_3 * Math.PI / 180)) * 180 / Math.PI;
                        fov.cur = _loc_4 * 2;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        override public function checkLimits() : void
        {
            checkLimitsSphere();
            return;
        }// end function

        protected function transformCorners() : void
        {
            var _loc_1:* = NaN;
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = new Matrix4d();
            var _loc_8:* = new Matrix4d();
            var _loc_9:* = this.getVFov();
            _loc_7.setRotX((-tilt.cur) * 2 * Math.PI / 360);
            _loc_8.setRotY(pan.cur * 2 * Math.PI / 360);
            _loc_6 = Matrix4d.multiply(_loc_7, _loc_8);
            _loc_3 = getEyeDistance();
            this.vat = new Array();
            _loc_1 = 0;
            while (_loc_1 < this.va.length)
            {
                
                _loc_4 = this.va[_loc_1];
                _loc_5 = _loc_4.clone();
                _loc_6.mulVector(_loc_4, _loc_5);
                _loc_5.project(_loc_3, rect.width / 2, rect.height / 2);
                this.vat.push(_loc_5);
                _loc_1 = _loc_1 + 1;
            }
            updateActiveElements();
            if (hotspots)
            {
                hotspots.updateHotspots(_loc_6, _loc_3);
                updatePolyHotspots();
            }
            if (viewer.enable_callback)
            {
                if (viewer.onRotate != null)
                {
                    viewer.onRotate(pan.cur, tilt.cur, _loc_9);
                }
            }
            return;
        }// end function

        public function setup_cube() : void
        {
            var _loc_1:* = NaN;
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            var _loc_7:* = NaN;
            var _loc_8:* = NaN;
            var _loc_4:* = 0;
            if (renderTile.tileOverlap > 0)
            {
                _loc_3 = 1;
                _loc_4 = 0;
            }
            else
            {
                _loc_3 = 1.0025;
                _loc_5 = fov.cur / 2 * (Math.PI / 180);
                _loc_6 = Math.floor(rect.height / 2 / Math.tan(_loc_5) * 2);
                if (tileSize > 0)
                {
                    _loc_3 = 1 + tileSize / _loc_6 * 2 / tileSize;
                }
                if (_loc_3 < this.tileScale)
                {
                    _loc_4 = 0;
                    _loc_3 = this.tileScale;
                }
                else
                {
                    _loc_4 = (_loc_3 - this.tileScale) * 0.5;
                }
            }
            this.va = new Array();
            _loc_1 = 0;
            while (_loc_1 < 6)
            {
                
                _loc_7 = -_loc_4;
                _loc_8 = 1 + _loc_4;
                this.va.push(new GgVector3d(-_loc_3, -_loc_3, -1, _loc_7, _loc_7));
                this.va.push(new GgVector3d(_loc_3, -_loc_3, -1, _loc_8, _loc_7));
                this.va.push(new GgVector3d(-_loc_3, _loc_3, -1, _loc_7, _loc_8));
                this.va.push(new GgVector3d(_loc_3, _loc_3, -1, _loc_8, _loc_8));
                if (_loc_1 < 4)
                {
                    _loc_2 = 0;
                    while (_loc_2 < 4)
                    {
                        
                        this.va[this.va.length - 4 + _loc_2].roty(Math.PI * 0.5 * _loc_1);
                        _loc_2 = _loc_2 + 1;
                    }
                }
                if (_loc_1 == 4)
                {
                    _loc_2 = 0;
                    while (_loc_2 < 4)
                    {
                        
                        this.va[this.va.length - 4 + _loc_2].rotx(Math.PI * 0.5);
                        _loc_2 = _loc_2 + 1;
                    }
                }
                if (_loc_1 == 5)
                {
                    _loc_2 = 0;
                    while (_loc_2 < 4)
                    {
                        
                        this.va[this.va.length - 4 + _loc_2].rotx((-Math.PI) * 0.5);
                        _loc_2 = _loc_2 + 1;
                    }
                }
                _loc_1 = _loc_1 + 1;
            }
            this.cubeWidth = _loc_3;
            return;
        }// end function

        override public function checkHotspots(param1:int, param2:int) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = NaN;
            var _loc_7:* = NaN;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            if (hasHotspots)
            {
                _loc_5 = viewer.getPositionVector(param1, param2);
                if (_loc_5.cz < 0 && _loc_5.cz <= -Math.abs(_loc_5.cx) && _loc_5.cz <= -Math.abs(_loc_5.cy))
                {
                    _loc_6 = 0.5 * (1 - _loc_5.cx / _loc_5.cz);
                    _loc_7 = 0.5 * (1 + _loc_5.cy / _loc_5.cz);
                    _loc_8 = 0;
                }
                if (_loc_5.cx >= 0 && _loc_5.cx >= Math.abs(_loc_5.cy) && _loc_5.cx >= Math.abs(_loc_5.cz))
                {
                    _loc_6 = 0.5 * (1 + _loc_5.cz / _loc_5.cx);
                    _loc_7 = 0.5 * (1 - _loc_5.cy / _loc_5.cx);
                    _loc_8 = 1;
                }
                if (_loc_5.cz >= 0 && _loc_5.cz >= Math.abs(_loc_5.cx) && _loc_5.cz >= Math.abs(_loc_5.cy))
                {
                    _loc_6 = 0.5 * (1 - _loc_5.cx / _loc_5.cz);
                    _loc_7 = 0.5 * (1 - _loc_5.cy / _loc_5.cz);
                    _loc_8 = 2;
                }
                if (_loc_5.cx <= 0 && _loc_5.cx <= -Math.abs(_loc_5.cy) && _loc_5.cx <= -Math.abs(_loc_5.cz))
                {
                    _loc_6 = 0.5 * (1 + _loc_5.cz / _loc_5.cx);
                    _loc_7 = 0.5 * (1 + _loc_5.cy / _loc_5.cx);
                    _loc_8 = 3;
                }
                if (_loc_5.cy >= 0 && _loc_5.cy >= Math.abs(_loc_5.cx) && _loc_5.cy >= Math.abs(_loc_5.cz))
                {
                    _loc_6 = 0.5 * (1 + _loc_5.cx / _loc_5.cy);
                    _loc_7 = 0.5 * (1 - _loc_5.cz / _loc_5.cy);
                    _loc_8 = 4;
                }
                if (_loc_5.cy <= 0 && _loc_5.cy <= -Math.abs(_loc_5.cx) && _loc_5.cy <= -Math.abs(_loc_5.cz))
                {
                    _loc_6 = 0.5 * (1 - _loc_5.cx / _loc_5.cy);
                    _loc_7 = 0.5 * (1 - _loc_5.cz / _loc_5.cy);
                    _loc_8 = 5;
                }
                _loc_3 = Math.floor(hsTileWidth * _loc_6);
                _loc_4 = Math.floor(hsTileHeight * _loc_7);
                _loc_9 = queryHotspotImage(_loc_3, _loc_4, _loc_8);
                hotspots.changeCurrentQtHotspot(_loc_9, param1, param2);
            }
            else
            {
                hotspots.changeCurrentQtHotspot(0, param1, param2);
            }
            return;
        }// end function

        override public function setMeshDensity(param1:Number) : void
        {
            if (this.meshAuto)
            {
                if (param1 < 0.25)
                {
                    this.cubeTiles = this.meshBase;
                }
                else if (param1 < 4)
                {
                    this.cubeTiles = this.meshBase - 1;
                }
                else
                {
                    this.cubeTiles = this.meshBase - 2;
                }
                if (this.cubeTiles < 2)
                {
                    this.cubeTiles = 2;
                }
            }
            else
            {
                this.cubeTiles = this.meshBase;
            }
            return;
        }// end function

        override public function paint(param1:Number) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            var _loc_5:* = 0;
            var _loc_7:* = NaN;
            var _loc_8:* = NaN;
            var _loc_9:* = null;
            var _loc_15:* = null;
            var _loc_16:* = null;
            var _loc_17:* = null;
            var _loc_18:* = null;
            var _loc_19:* = null;
            var _loc_20:* = null;
            var _loc_21:* = null;
            var _loc_22:* = null;
            var _loc_23:* = NaN;
            var _loc_25:* = 0;
            var _loc_26:* = NaN;
            var _loc_27:* = null;
            var _loc_28:* = null;
            var _loc_29:* = 0;
            var _loc_30:* = 0;
            var _loc_31:* = 0;
            var _loc_32:* = NaN;
            var _loc_6:* = 50;
            var _loc_10:* = new GgVector3d();
            var _loc_11:* = new GgVector3d();
            var _loc_12:* = new GgVector3d();
            var _loc_13:* = new GgVector3d();
            var _loc_14:* = new GgVector3d();
            super.paint(param1);
            this.setup_cube();
            if (this.cubeTiles < 2)
            {
                this.cubeTiles = 2;
            }
            this.transformCorners();
            _loc_7 = rect.width / 2;
            _loc_8 = rect.height / 2;
            var _loc_24:* = getEyeDistance();
            renderTile.bmpSmooth = viewer.bmpSmooth;
            renderTile.canv = viewer.canv;
            renderTile.canvOv = viewer.canvOv;
            renderTile.ed = _loc_24;
            renderTile.isCylinder = false;
            renderTile.rect = rect;
            viewer.canv.graphics.clear();
            if (hasOverlay)
            {
                viewer.canvOv.graphics.clear();
                viewer.canvOv.alpha = alphaOverlay;
            }
            _loc_5 = 0;
            while (_loc_5 < 6)
            {
                
                _loc_15 = this.vat[_loc_5 * 4 + 0];
                _loc_16 = this.vat[_loc_5 * 4 + 1];
                _loc_17 = this.vat[_loc_5 * 4 + 2];
                _loc_18 = this.vat[_loc_5 * 4 + 3];
                _loc_3 = 0;
                _loc_4 = 0;
                if (_loc_15.cz <= _loc_16.cz && _loc_15.cz <= _loc_17.cz && _loc_15.cz <= _loc_18.cz)
                {
                    _loc_3 = 0;
                    _loc_4 = 0;
                }
                if (_loc_16.cz <= _loc_15.cz && _loc_16.cz <= _loc_17.cz && _loc_16.cz <= _loc_18.cz)
                {
                    _loc_3 = 1;
                    _loc_4 = 0;
                }
                if (_loc_17.cz <= _loc_15.cz && _loc_17.cz <= _loc_16.cz && _loc_17.cz <= _loc_18.cz)
                {
                    _loc_3 = 0;
                    _loc_4 = 1;
                }
                if (_loc_18.cz <= _loc_15.cz && _loc_18.cz <= _loc_16.cz && _loc_18.cz <= _loc_17.cz)
                {
                    _loc_3 = 1;
                    _loc_4 = 1;
                }
                _loc_12.interpol4(_loc_15, _loc_16, _loc_17, _loc_18, _loc_3, _loc_4);
                _loc_13.interpol4(_loc_15, _loc_16, _loc_17, _loc_18, _loc_3 + 0.01, _loc_4);
                _loc_14.interpol4(_loc_15, _loc_16, _loc_17, _loc_18, _loc_3, _loc_4 + 0.01);
                _loc_12.project(_loc_24, _loc_7, _loc_8);
                _loc_13.project(_loc_24, _loc_7, _loc_8);
                _loc_14.project(_loc_24, _loc_7, _loc_8);
                _loc_10.init(_loc_12.px - _loc_13.px, _loc_12.py - _loc_13.py, 0);
                _loc_11.init(_loc_12.px - _loc_14.px, _loc_12.py - _loc_14.py, 0);
                if (_loc_10.cx * _loc_11.cy - _loc_10.cy * _loc_11.cx > 0)
                {
                    if (viewer.bmpVideo == null)
                    {
                        if (zoomImg)
                        {
                            _loc_25 = 0;
                            _loc_26 = rect.height / (2 * Math.tan(this.getVFov() / 2 * Math.PI / 180));
                            _loc_25 = getLevel(_loc_26 * 2);
                            tileSize = zoomImg.zoomLevels[_loc_25].imageWidth;
                            _loc_27 = new Array();
                            _loc_27.push(_loc_15);
                            _loc_27.push(_loc_16);
                            _loc_27.push(_loc_18);
                            _loc_27.push(_loc_17);
                            _loc_27 = renderTile.clipFrustumSave(_loc_27);
                            _loc_28 = new GgRectangle(1, 1, 0, 0);
                            _loc_2 = 0;
                            while (_loc_2 < _loc_27.length)
                            {
                                
                                _loc_28.x1 = Math.min(_loc_28.x1, _loc_27[_loc_2].u);
                                _loc_28.x2 = Math.max(_loc_28.x2, _loc_27[_loc_2].u);
                                _loc_28.y1 = Math.min(_loc_28.y1, _loc_27[_loc_2].v);
                                _loc_28.y2 = Math.max(_loc_28.y2, _loc_27[_loc_2].v);
                                _loc_2++;
                            }
                            zoomImg.subTileSplit = 1 << this.cubeTiles / 2;
                            zoomImg.renderZoomLevel(_loc_5, _loc_25, _loc_15, _loc_16, _loc_17, _loc_18, _loc_28);
                        }
                        else
                        {
                            renderTile.bmp = bmpTile[_loc_5];
                            _loc_29 = 1 << this.cubeTiles / 2;
                            renderTile.displayTile(_loc_15, _loc_16, _loc_17, _loc_18, _loc_29);
                        }
                    }
                    else
                    {
                        _loc_30 = 0;
                        _loc_31 = 0;
                        _loc_32 = viewer.bmpVideo.width / 3;
                        _loc_30 = _loc_32 * (_loc_5 % 3) + 4;
                        _loc_31 = 4;
                        if (_loc_5 >= 3)
                        {
                            _loc_31 = _loc_31 + _loc_32;
                        }
                        _loc_15.u = _loc_30 / (3 * _loc_32);
                        _loc_15.v = _loc_31 / (2 * _loc_32);
                        _loc_16.u = (_loc_30 + _loc_32 - 8) / (3 * _loc_32);
                        _loc_16.v = _loc_15.v;
                        _loc_17.u = _loc_15.u;
                        _loc_17.v = (_loc_31 + _loc_32 - 8) / (2 * _loc_32);
                        _loc_18.u = _loc_16.u;
                        _loc_18.v = _loc_17.v;
                        renderTile.bmp = viewer.bmpVideo;
                        renderTile.displayTile(_loc_15, _loc_16, _loc_17, _loc_18, 0);
                    }
                }
                _loc_5++;
            }
            paintPolyHotspots();
            return;
        }// end function

        override public function readConfig(param1:XML, param2:Boolean = false) : void
        {
            super.readConfig(param1, true);
            if (param1.hasOwnProperty("input"))
            {
                if (param1.input.hasOwnProperty("@tilesize"))
                {
                    tileSize = param1.input.@tilesize;
                }
                else
                {
                    tileSize = 0;
                }
                if (param1.input.hasOwnProperty("@tilescale"))
                {
                    this.tileScale = param1.input.@tilescale;
                }
                else
                {
                    this.tileScale = 1;
                }
                if (param1.input.hasOwnProperty("@subtiles"))
                {
                    subtiles = param1.input.@subtiles;
                }
                else
                {
                    subtiles = 1;
                }
                if (param1.input.hasOwnProperty("preview"))
                {
                    if (param1.input.preview.hasOwnProperty("@images"))
                    {
                        hasPrevImages = param1.input.preview.@images == 1;
                    }
                    else
                    {
                        hasPrevImages = false;
                    }
                    if (param1.input.preview.hasOwnProperty("@color"))
                    {
                        preloadColor = param1.input.preview.@color;
                    }
                }
                else
                {
                    hasPrevImages = false;
                }
            }
            if (param1.hasOwnProperty("display"))
            {
                if (param1.display.hasOwnProperty("@quality"))
                {
                    this.meshBase = param1.display.@quality;
                }
                if (param1.display.hasOwnProperty("@changemotionquality"))
                {
                    this.meshAuto = param1.display.@changemotionquality == 1;
                }
            }
            return;
        }// end function

    }
}
