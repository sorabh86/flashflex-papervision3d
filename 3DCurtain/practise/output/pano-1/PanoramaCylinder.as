package 
{
    import Panorama.*;
    import PanoramaCylinder.*;
    import flash.display.*;
    import flash.geom.*;

    public class PanoramaCylinder extends Panorama
    {
        protected var va:Array;
        protected var vat:Array;
        protected var cylTilesX:Number;
        protected var cylTilesXBase:Number;
        protected var cylTilesXS:Number;
        protected var cylTilesY:Number;
        protected var cylinderImageWidth:Number = 0;
        protected var cylinderImageHeight:Number = 0;
        protected var meshAuto:Boolean = true;
        protected var meshBase:Number = 10;
        protected var meshCylBase:Number = 10;
        protected var imagePhiMin:Number = -75;
        protected var imagePhiMax:Number = 75;
        protected var imageThetaMin:Number = 0;
        protected var imageThetaMax:Number = 360;

        public function PanoramaCylinder()
        {
            this.va = new Array();
            this.vat = new Array();
            this.cylTilesXS = 6;
            return;
        }// end function

        override public function setMeshDensity(param1:Number) : void
        {
            if (this.meshAuto)
            {
                if (param1 < 0.25)
                {
                    this.cylTilesY = this.meshCylBase;
                }
                else if (param1 < 4)
                {
                    this.cylTilesY = this.meshCylBase - 1;
                }
                else
                {
                    this.cylTilesY = this.meshCylBase - 2;
                }
                if (this.cylTilesY < 2)
                {
                    this.cylTilesY = 2;
                }
            }
            else
            {
                this.cylTilesY = this.meshCylBase;
            }
            return;
        }// end function

        override public function initBitmaps() : void
        {
            var _loc_1:* = 0;
            _loc_1 = 0;
            while (_loc_1 < 6)
            {
                
                if (bmpTile[_loc_1] == null && this.cylinderImageWidth > 0)
                {
                    bmpTile[_loc_1] = new BitmapData(this.cylinderImageWidth / 6, this.cylinderImageHeight, transparentImage, preloadColor);
                    if (hasOverlay && bmpTileOverlay[_loc_1] == null)
                    {
                        bmpTileOverlay[_loc_1] = new BitmapData(this.cylinderImageWidth / 6, this.cylinderImageHeight, true);
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

        override public function init() : void
        {
            var _loc_1:* = NaN;
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            var _loc_7:* = pan.max - pan.min;
            this.imageThetaMin = 180 + pan.min;
            this.imageThetaMax = 180 + pan.max;
            if (this.meshBase > 5)
            {
                this.cylTilesXBase = 12 * Math.floor((this.meshBase - 3) / 2);
                this.meshCylBase = Math.floor((this.meshBase + 4) / 2);
            }
            else
            {
                this.cylTilesXBase = 12;
                this.meshCylBase = 4;
            }
            this.cylTilesXBase = Math.ceil(this.cylTilesXBase * _loc_7 / 360 / this.cylTilesXS);
            if (this.cylTilesXBase * this.cylTilesXS < 10)
            {
                this.cylTilesXBase = Math.ceil(10 / this.cylTilesXS);
            }
            this.cylTilesX = this.cylTilesXBase;
            if (this.cylTilesXS < 1)
            {
                this.cylTilesXS = 1;
            }
            bmp_loaded = new Array();
            bmp_loadedpf = new Array();
            _loc_1 = 0;
            while (_loc_1 < this.cylTilesXS)
            {
                
                bmp_loaded.push(false);
                bmp_loadedpf.push(false);
                _loc_1 = _loc_1 + 1;
            }
            if (bmp_loaded[0])
            {
                _loc_4 = this.cylTilesXS * bmpTile[0].width;
                _loc_5 = bmpTile[0].height;
            }
            else
            {
                _loc_4 = this.cylinderImageWidth;
                _loc_5 = this.cylinderImageHeight;
            }
            var _loc_8:* = 180 / Math.PI * Math.atan(_loc_5 * Math.PI / (_loc_4 * (360 / _loc_7)));
            if (tilt.min < -_loc_8)
            {
                tilt.min = -_loc_8;
            }
            if (tilt.max > _loc_8)
            {
                tilt.max = _loc_8;
            }
            this.imagePhiMin = -_loc_8;
            this.imagePhiMax = _loc_8;
            this.setup_cylinder(_loc_4, _loc_5);
            initActiveElements();
            this.checkLimits();
            return;
        }// end function

        override public function checkHotspots(param1:int, param2:int) : void
        {
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = NaN;
            var _loc_9:* = NaN;
            var _loc_10:* = null;
            var _loc_11:* = NaN;
            var _loc_12:* = NaN;
            var _loc_13:* = NaN;
            var _loc_14:* = NaN;
            var _loc_15:* = null;
            var _loc_16:* = NaN;
            var _loc_17:* = NaN;
            var _loc_18:* = 0;
            if (hasHotspots)
            {
                _loc_14 = getVFov();
                _loc_15 = viewer.getPositionAngles(param1, param2);
                _loc_8 = _loc_15.x;
                _loc_9 = _loc_15.y;
                _loc_10 = new GgVector3d(0, 0, -1);
                _loc_10.rotx(_loc_9 * Math.PI / 180);
                _loc_10.roty(_loc_8 * Math.PI / 180);
                _loc_10.rotx((-tilt.cur) * Math.PI / 180);
                _loc_10.roty((-pan.cur) * Math.PI / 180);
                _loc_16 = 0;
                _loc_17 = pan.max - pan.min;
                _loc_16 = Math.atan2(_loc_10.cx, -_loc_10.cz) - pan.min * Math.PI / 180;
                if (_loc_16 < 0)
                {
                    _loc_16 = _loc_16 + 2 * Math.PI;
                }
                _loc_16 = 6 * _loc_16 * 360 / (2 * Math.PI * _loc_17);
                _loc_13 = Math.floor(_loc_16);
                _loc_11 = _loc_16 - _loc_13;
                _loc_6 = Math.floor(hsTileWidth * _loc_11);
                _loc_12 = (-_loc_10.cy) / Math.sqrt(_loc_10.cx * _loc_10.cx + _loc_10.cz * _loc_10.cz);
                _loc_7 = Math.floor((hsTileWidth * 6 / Math.PI * (360 / _loc_17) * _loc_12 + hsTileHeight) / 2);
                if (_loc_6 < 0)
                {
                    _loc_6 = 0;
                }
                if (_loc_7 < 0)
                {
                    _loc_7 = 0;
                }
                if (_loc_6 >= hsTileWidth)
                {
                    _loc_6 = hsTileWidth - 1;
                }
                if (_loc_7 >= this.cylinderImageHeight)
                {
                    _loc_7 = this.cylinderImageHeight - 1;
                }
                _loc_18 = queryHotspotImage(_loc_6, _loc_7, _loc_13);
                hotspots.changeCurrentQtHotspot(_loc_18, param1, param2);
            }
            else
            {
                viewer.hotspots.currentHotspotId = 0;
            }
            return;
        }// end function

        override public function checkLimits() : void
        {
            checkLimitsSphere();
            return;
        }// end function

        public function setup_cylinder(param1:Number, param2:Number) : void
        {
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            var _loc_8:* = NaN;
            var _loc_9:* = NaN;
            var _loc_10:* = NaN;
            var _loc_11:* = NaN;
            var _loc_7:* = pan.max - pan.min;
            this.va = new Array();
            if (zoomImg)
            {
                this.va.push(new GgVector3dCyl(1, this.imageThetaMax * Math.PI / 180, Math.tan(this.imagePhiMin * Math.PI / 180), 0, 0));
                this.va.push(new GgVector3dCyl(1, this.imageThetaMin * Math.PI / 180, Math.tan(this.imagePhiMin * Math.PI / 180), 1, 0));
                this.va.push(new GgVector3dCyl(1, this.imageThetaMax * Math.PI / 180, Math.tan(this.imagePhiMax * Math.PI / 180), 0, 1));
                this.va.push(new GgVector3dCyl(1, this.imageThetaMin * Math.PI / 180, Math.tan(this.imagePhiMax * Math.PI / 180), 1, 1));
            }
            else
            {
                _loc_8 = param1 / (this.cylTilesX * this.cylTilesXS);
                _loc_3 = 0;
                while (_loc_3 < this.cylTilesX * this.cylTilesXS)
                {
                    
                    _loc_9 = Math.cos(Math.PI / (this.cylTilesX * this.cylTilesXS) * (_loc_7 / 360));
                    _loc_10 = Math.PI / (this.cylTilesX * this.cylTilesXS) * (_loc_7 / 360) * 1;
                    _loc_11 = (-_loc_10) / _loc_8 * param2;
                    this.va.push(new GgVector3d(_loc_10, _loc_11, _loc_9, _loc_3 * _loc_8, 0));
                    this.va.push(new GgVector3d(-_loc_10, _loc_11, _loc_9, (_loc_3 + 1) * _loc_8, 0));
                    this.va.push(new GgVector3d(_loc_10, -_loc_11, _loc_9, _loc_3 * _loc_8, param2));
                    this.va.push(new GgVector3d(-_loc_10, -_loc_11, _loc_9, (_loc_3 + 1) * _loc_8, param2));
                    _loc_5 = 0;
                    while (_loc_5 < 4)
                    {
                        
                        this.va[this.va.length - 4 + _loc_5].roty(2 * _loc_3 * _loc_10 + _loc_10 + (-pan.max + 180) * Math.PI / 180);
                        _loc_5 = _loc_5 + 1;
                    }
                    _loc_3 = _loc_3 + 1;
                }
            }
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
            var _loc_9:* = getVFov();
            _loc_7.setRotX((-tilt.cur) * 2 * Math.PI / 360);
            _loc_8.setRotY(pan.cur * 2 * Math.PI / 360);
            _loc_6 = Matrix4d.multiply(_loc_7, _loc_8);
            _loc_3 = getEyeDistance();
            this.vat = new Array();
            if (zoomImg)
            {
                _loc_1 = 0;
                while (_loc_1 < this.va.length)
                {
                    
                    _loc_4 = this.va[_loc_1];
                    _loc_5 = _loc_4.clone();
                    _loc_5.rotx((-tilt.cur) * Math.PI / 180);
                    _loc_5.roty((-pan.cur) * Math.PI / 180);
                    this.vat.push(_loc_5);
                    _loc_1 = _loc_1 + 1;
                }
            }
            else
            {
                _loc_1 = 0;
                while (_loc_1 < this.va.length)
                {
                    
                    _loc_4 = this.va[_loc_1];
                    _loc_5 = new GgVector3d();
                    _loc_6.mulVector(_loc_4, _loc_5);
                    this.vat.push(_loc_5);
                    _loc_4.pz = _loc_5.cz;
                    if (_loc_4.pz < 0)
                    {
                        _loc_2 = _loc_3 / _loc_5.cz;
                        if (_loc_5.cz > -1e-005)
                        {
                            _loc_2 = 10000;
                        }
                        _loc_4.px = _loc_5.cx * _loc_2;
                        _loc_4.py = (-_loc_5.cy) * _loc_2;
                        _loc_4.px = _loc_4.px + rect.width / 2;
                        _loc_4.py = _loc_4.py + rect.height / 2;
                    }
                    else
                    {
                        _loc_4.px = _loc_5.cx * 1000;
                        _loc_4.py = (-_loc_5.cy) * 1000;
                    }
                    _loc_1 = _loc_1 + 1;
                }
            }
            hotspots.updateHotspots(_loc_6, _loc_3);
            updatePolyHotspots();
            updateActiveElements();
            if (viewer.enable_callback)
            {
                if (viewer.onRotate != null)
                {
                    viewer.onRotate(pan.cur, tilt.cur, _loc_9);
                }
            }
            return;
        }// end function

        override public function paint(param1:Number) : void
        {
            super.paint(param1);
            if (zoomImg)
            {
                this.paint_new(param1);
            }
            else
            {
                this.paint_old(param1);
            }
            paintPolyHotspots();
            return;
        }// end function

        public function paint_new(param1:Number) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_16:* = null;
            var _loc_17:* = NaN;
            var _loc_18:* = NaN;
            var _loc_19:* = NaN;
            var _loc_20:* = NaN;
            var _loc_21:* = NaN;
            var _loc_22:* = NaN;
            var _loc_23:* = NaN;
            var _loc_24:* = 0;
            var _loc_25:* = NaN;
            var _loc_11:* = getVFov();
            var _loc_12:* = getVFov() / 2;
            this.transformCorners();
            _loc_3 = rect.width;
            _loc_5 = _loc_3 / 2;
            _loc_4 = rect.height;
            _loc_6 = _loc_4 / 2;
            viewer.canv.graphics.clear();
            if (hasOverlay)
            {
                viewer.canvOv.graphics.clear();
                viewer.canvOv.alpha = alphaOverlay;
            }
            var _loc_13:* = getEyeDistance();
            var _loc_14:* = Math.atan(rect.width / rect.height * Math.tan(_loc_12 * Math.PI / 180)) * 180 / Math.PI;
            var _loc_15:* = new GgRectangle(0, 0, 1, 1);
            if (tilt.cur + _loc_12 < 90 && tilt.cur - _loc_12 > -90)
            {
                _loc_17 = pan.cur;
                _loc_18 = tilt.cur;
                _loc_17 = -_loc_17 + 180 - this.imageThetaMin;
                while (_loc_17 < 0)
                {
                    
                    _loc_17 = _loc_17 + 360;
                }
                while (_loc_17 >= 360)
                {
                    
                    _loc_17 = _loc_17 - 360;
                }
                _loc_18 = -_loc_18 - this.imagePhiMin;
                _loc_19 = Math.tan(_loc_12 * Math.PI / 180);
                _loc_20 = Math.tan((Math.abs(tilt.cur) + _loc_12) * Math.PI / 180);
                _loc_21 = Math.sqrt(_loc_20 * _loc_20 + 1) / Math.sqrt(_loc_19 * _loc_19 + 1);
                _loc_22 = Math.atan(_loc_21 * Math.tan(_loc_14 * Math.PI / 180)) * 180 / Math.PI;
                _loc_15.x1 = (_loc_17 - _loc_22) / (this.imageThetaMax - this.imageThetaMin);
                _loc_15.x2 = (_loc_17 + _loc_22) / (this.imageThetaMax - this.imageThetaMin);
                if (_loc_15.x1 < 0)
                {
                    (_loc_15.x1 + 1);
                    (_loc_15.x2 + 1);
                }
                _loc_23 = tilt.cur + _loc_12;
                if (_loc_23 > 90)
                {
                    _loc_23 = 90;
                }
                if (_loc_23 < 0)
                {
                    _loc_23 = _loc_23 / 2;
                }
                _loc_15.y1 = 0.5 - 0.5 * Math.tan(_loc_23 * Math.PI / 180) / Math.tan((this.imagePhiMax - this.imagePhiMin) * Math.PI / 360);
                _loc_23 = tilt.cur - _loc_12;
                if (_loc_23 < -90)
                {
                    _loc_23 = -90;
                }
                if (_loc_23 > 0)
                {
                    _loc_23 = _loc_23 / 2;
                }
                _loc_15.y2 = 0.5 - 0.5 * Math.tan(_loc_23 * Math.PI / 180) / Math.tan((this.imagePhiMax - this.imagePhiMin) * Math.PI / 360);
            }
            _loc_7 = this.vat[0] as GgVector3dCyl;
            _loc_8 = this.vat[1] as GgVector3dCyl;
            _loc_9 = this.vat[2] as GgVector3dCyl;
            _loc_10 = this.vat[3] as GgVector3dCyl;
            if (zoomImg)
            {
                _loc_24 = 0;
                _loc_25 = rect.height / (2 * Math.tan(getVFov() / 2 * Math.PI / 180));
                _loc_25 = _loc_25 * (2 * Math.tan((this.imagePhiMax - this.imagePhiMin) / 2 * Math.PI / 180));
                _loc_24 = getLevel(_loc_25);
                zoomImg.subTileSplit = 16;
                zoomImg.renderZoomLevel(0, _loc_24, _loc_7, _loc_8, _loc_9, _loc_10, _loc_15);
            }
            return;
        }// end function

        public function paint_old(param1:Number) : void
        {
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            var _loc_7:* = NaN;
            var _loc_8:* = NaN;
            var _loc_9:* = NaN;
            var _loc_10:* = NaN;
            var _loc_11:* = NaN;
            var _loc_12:* = NaN;
            var _loc_13:* = NaN;
            var _loc_18:* = NaN;
            var _loc_19:* = NaN;
            var _loc_20:* = NaN;
            var _loc_21:* = NaN;
            var _loc_22:* = NaN;
            var _loc_23:* = NaN;
            var _loc_24:* = null;
            var _loc_26:* = null;
            var _loc_27:* = null;
            var _loc_28:* = null;
            var _loc_29:* = null;
            var _loc_30:* = null;
            var _loc_31:* = null;
            var _loc_32:* = null;
            var _loc_33:* = null;
            var _loc_39:* = NaN;
            var _loc_14:* = 50;
            var _loc_15:* = 1;
            var _loc_16:* = 0;
            var _loc_17:* = -0.15;
            var _loc_25:* = new GgVector3d();
            var _loc_34:* = getVFov();
            super.paint(param1);
            this.transformCorners();
            _loc_15 = 0;
            _loc_16 = -1;
            if (_loc_16 >= 0)
            {
            }
            _loc_18 = rect.width;
            _loc_20 = _loc_18 / 2;
            _loc_19 = rect.height;
            _loc_21 = _loc_19 / 2;
            viewer.canv.graphics.clear();
            if (hasOverlay)
            {
                viewer.canvOv.graphics.clear();
                viewer.canvOv.alpha = alphaOverlay;
            }
            var _loc_35:* = getEyeDistance();
            renderTile.bmpSmooth = viewer.bmpSmooth;
            renderTile.canv = viewer.canv;
            renderTile.canvOv = viewer.canvOv;
            renderTile.ed = _loc_35;
            renderTile.isCylinder = true;
            renderTile.rect = rect;
            var _loc_36:* = _loc_34;
            var _loc_37:* = Math.atan(rect.width / rect.height * Math.tan(_loc_36 * Math.PI / 180)) * 180 / Math.PI;
            this.cylTilesX = this.cylTilesXBase / 1;
            var _loc_38:* = this.cylTilesXBase / this.cylTilesX;
            _loc_11 = 0;
            while (_loc_11 < this.cylTilesXS)
            {
                
                _loc_22 = bmpTile[_loc_11].width;
                _loc_23 = bmpTile[_loc_11].height;
                _loc_4 = 0;
                while (_loc_4 < this.cylTilesX)
                {
                    
                    _loc_39 = (this.cylTilesX * _loc_11 * _loc_38 + _loc_4) * 4;
                    _loc_26 = this.vat[_loc_39];
                    _loc_28 = this.vat[_loc_39 + 2];
                    _loc_39 = (this.cylTilesX * _loc_11 * _loc_38 + _loc_4 + _loc_38 - 1) * 4;
                    _loc_27 = this.vat[(_loc_39 + 1)];
                    _loc_29 = this.vat[_loc_39 + 3];
                    _loc_26.u = (0 + _loc_4) / this.cylTilesX;
                    _loc_26.v = 0;
                    _loc_27.u = (1 + _loc_4) / this.cylTilesX;
                    _loc_27.v = 0;
                    _loc_28.u = (0 + _loc_4) / this.cylTilesX;
                    _loc_28.v = 1;
                    _loc_29.u = (1 + _loc_4) / this.cylTilesX;
                    _loc_29.v = 1;
                    if (_loc_26.cz < 0 || _loc_27.cz < 0 || _loc_28.cz < 0 || _loc_29.cz < 0)
                    {
                        _loc_26.project(_loc_35, _loc_20, _loc_21);
                        _loc_27.project(_loc_35, _loc_20, _loc_21);
                        _loc_28.project(_loc_35, _loc_20, _loc_21);
                        _loc_29.project(_loc_35, _loc_20, _loc_21);
                        renderTile.bmp = bmpTile[_loc_11];
                        if (hasOverlay)
                        {
                            renderTile.bmp_ov = bmpTileOverlay[_loc_11];
                        }
                        else
                        {
                            renderTile.bmp_ov = null;
                        }
                        renderTile.displayTile(_loc_26, _loc_27, _loc_28, _loc_29, this.meshCylBase);
                    }
                    _loc_4 = _loc_4 + 1;
                }
                _loc_11 = _loc_11 + 1;
            }
            return;
        }// end function

        override public function readConfig(param1:XML, param2:Boolean = false) : void
        {
            super.readConfig(param1);
            if (param1.hasOwnProperty("input"))
            {
                if (param1.input.hasOwnProperty("@width"))
                {
                    this.cylinderImageWidth = param1.input.@width;
                }
                if (param1.input.hasOwnProperty("@height"))
                {
                    this.cylinderImageHeight = param1.input.@height;
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
