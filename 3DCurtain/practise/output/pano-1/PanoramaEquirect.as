package 
{
    import Panorama.*;
    import PanoramaEquirect.*;
    import flash.display.*;
    import flash.geom.*;

    public class PanoramaEquirect extends Panorama
    {
        protected var va:Array;
        protected var vat:Array;
        protected var imageWidth:Number = 10;
        protected var imageHeight:Number = 10;
        protected var imagePhiMin:Number = -90;
        protected var imagePhiMax:Number = 90;
        protected var imageThetaMin:Number = 0;
        protected var imageThetaMax:Number = 360;

        public function PanoramaEquirect()
        {
            this.va = new Array();
            this.vat = new Array();
            return;
        }// end function

        override public function setMeshDensity(param1:Number) : void
        {
            return;
        }// end function

        override public function initBitmaps() : void
        {
            var _loc_1:* = 0;
            _loc_1 = 0;
            while (_loc_1 < 6)
            {
                
                if (bmpTile[_loc_1] == null && this.imageWidth > 0)
                {
                    bmpTile[_loc_1] = new BitmapData(this.imageWidth / 6, this.imageHeight, transparentImage, preloadColor);
                    if (hasOverlay && bmpTileOverlay[_loc_1] == null)
                    {
                        bmpTileOverlay[_loc_1] = new BitmapData(this.imageWidth / 6, this.imageHeight, true);
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
            var _loc_1:* = 0;
            this.va.push(new GgVector3dEqui(1, this.imageThetaMax * Math.PI / 180, this.imagePhiMin * Math.PI / 180, 0, 0));
            this.va.push(new GgVector3dEqui(1, this.imageThetaMin * Math.PI / 180, this.imagePhiMin * Math.PI / 180, 1, 0));
            this.va.push(new GgVector3dEqui(1, this.imageThetaMax * Math.PI / 180, this.imagePhiMax * Math.PI / 180, 0, 1));
            this.va.push(new GgVector3dEqui(1, this.imageThetaMin * Math.PI / 180, this.imagePhiMax * Math.PI / 180, 1, 1));
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
            var _loc_18:* = NaN;
            var _loc_19:* = 0;
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
                _loc_18 = this.imageWidth / 6;
                _loc_6 = Math.floor(_loc_18 * _loc_11);
                _loc_12 = (-_loc_10.cy) / Math.sqrt(_loc_10.cx * _loc_10.cx + _loc_10.cz * _loc_10.cz);
                _loc_7 = Math.floor((this.imageWidth / Math.PI * (360 / _loc_17) * _loc_12 + this.imageHeight) / 2);
                if (_loc_6 < 0)
                {
                    _loc_6 = 0;
                }
                if (_loc_7 < 0)
                {
                    _loc_7 = 0;
                }
                if (_loc_6 >= _loc_18)
                {
                    _loc_6 = _loc_18 - 1;
                }
                if (_loc_7 >= this.imageHeight)
                {
                    _loc_7 = this.imageHeight - 1;
                }
                _loc_19 = queryHotspotImage(_loc_6, _loc_7, _loc_13);
                hotspots.changeCurrentQtHotspot(_loc_19, param1, param2);
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
            super.paint(param1);
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
                _loc_17 = -_loc_17 + 180;
                while (_loc_17 < 0)
                {
                    
                    _loc_17 = _loc_17 + 360;
                }
                while (_loc_17 >= 360)
                {
                    
                    _loc_17 = _loc_17 - 360;
                }
                _loc_18 = -_loc_18 - this.imagePhiMin;
                while (_loc_18 < 0)
                {
                    
                    _loc_17 = _loc_17 + 180;
                }
                while (_loc_18 >= 180)
                {
                    
                    _loc_17 = _loc_17 - 180;
                }
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
                _loc_23 = Math.sqrt(rect.height * rect.height + rect.width * rect.width) / rect.height;
                _loc_15.y1 = (_loc_18 - _loc_12 * _loc_23) / (this.imagePhiMax - this.imagePhiMin);
                _loc_15.y2 = (_loc_18 + _loc_12 * _loc_23) / (this.imagePhiMax - this.imagePhiMin);
            }
            _loc_7 = this.vat[0] as GgVector3dEqui;
            _loc_8 = this.vat[1] as GgVector3dEqui;
            _loc_9 = this.vat[2] as GgVector3dEqui;
            _loc_10 = this.vat[3] as GgVector3dEqui;
            if (zoomImg)
            {
                _loc_24 = 0;
                _loc_25 = rect.height / (2 * Math.tan(getVFov() / 2 * Math.PI / 180));
                _loc_25 = _loc_25 * Math.PI / 2;
                _loc_24 = getLevel(_loc_25);
                zoomImg.subTileSplit = 32;
                zoomImg.renderZoomLevel(0, _loc_24, _loc_7, _loc_8, _loc_9, _loc_10, _loc_15);
            }
            paintPolyHotspots();
            return;
        }// end function

        override public function readConfig(param1:XML, param2:Boolean = false) : void
        {
            super.readConfig(param1);
            if (param1.hasOwnProperty("input"))
            {
                if (param1.input.hasOwnProperty("@width"))
                {
                    this.imageWidth = param1.input.@width;
                }
                if (param1.input.hasOwnProperty("@height"))
                {
                    this.imageHeight = param1.input.@height;
                }
                if (param1.input.hasOwnProperty("@thetamin"))
                {
                    this.imagePhiMin = param1.input.@thetamin;
                }
                if (param1.input.hasOwnProperty("@thetamax"))
                {
                    this.imagePhiMax = param1.input.@thetamax;
                }
                if (param1.input.hasOwnProperty("@phimin"))
                {
                    this.imageThetaMin = param1.input.@phimin;
                }
                if (param1.input.hasOwnProperty("@phimax"))
                {
                    this.imageThetaMax = param1.input.@phimax;
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
                }
                if (param1.display.hasOwnProperty("@changemotionquality"))
                {
                }
            }
            return;
        }// end function

    }
}
