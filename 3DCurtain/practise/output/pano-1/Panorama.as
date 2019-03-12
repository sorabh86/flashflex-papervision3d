package 
{
    import Panorama.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.media.*;
    import flash.net.*;

    public class Panorama extends Object
    {
        public var fov:PanoViewLimits;
        public var pan:PanoViewLimits;
        public var tilt:PanoViewLimits;
        public var rect:Rectangle;
        public var hotspots:Hotspots;
        public var renderTile:RenderTile;
        public var viewer:PanoViewer;
        public var bmpTile:Array;
        public var bmp_hs:Array;
        protected var bmp_loaded:Array;
        protected var bmp_loadedpf:Array;
        public var externalTiles:Array;
        public var tileSize:int = 0;
        public var subtiles:int = 1;
        public var hasPrevImages:Boolean = true;
        public var hasOverlay:Boolean = false;
        public var alphaOverlay:Number = 1;
        public var bmpTileOverlay:Array;
        public var hasHotspots:Boolean = false;
        public var preloadColor:Number;
        public var zoomImg:ZoomLevelImages;
        public var minPixelZoom:Number = 0;
        public var enableDecodeLimit:Boolean = false;
        protected var hsTileWidth:int = 0;
        protected var hsTileHeight:int = 0;
        protected var maxFov2:Number = 89;
        public var transparentImage:Boolean = false;
        public var activeElements:Array;
        public var config:XML;

        public function Panorama()
        {
            var _loc_1:* = 0;
            this.zoomImg = null;
            this.fov = new PanoViewLimits(80, 1, 120);
            this.pan = new PanoViewLimits(0, 0, 360);
            this.tilt = new PanoViewLimits(0, -90, 90);
            this.bmpTile = new Array();
            this.bmpTileOverlay = new Array();
            this.bmp_hs = new Array();
            this.bmp_loaded = new Array();
            this.bmp_loadedpf = new Array();
            this.subtiles = 1;
            this.externalTiles = new Array();
            _loc_1 = 0;
            while (_loc_1 < 8)
            {
                
                this.externalTiles[_loc_1] = null;
                _loc_1++;
            }
            this.preloadColor = 16777216;
            this.tileSize = 1201;
            this.activeElements = new Array();
            return;
        }// end function

        public function doEnterFrame() : void
        {
            if (isNaN(this.pan.cur) || isNaN(this.tilt.cur) || isNaN(this.fov.cur))
            {
                this.pan.cur = 0;
                this.tilt.cur = 0;
                this.fov.cur = 70;
            }
            if (this.zoomImg)
            {
                this.zoomImg.doEnterFrame();
            }
            return;
        }// end function

        public function setMeshDensity(param1:Number) : void
        {
            return;
        }// end function

        public function getLevel(param1:Number) : int
        {
            var _loc_2:* = NaN;
            var _loc_3:* = 0;
            _loc_2 = param1;
            _loc_3 = 0;
            _loc_2 = _loc_2 * (1 + Math.tan(this.getVFov() / 2 * Math.PI / 180) * (this.rect.width / this.rect.height) / 2);
            _loc_2 = _loc_2 * Math.pow(2, this.zoomImg.levelBias);
            while ((_loc_3 + 1) < this.zoomImg.zoomLevels.length && this.zoomImg.zoomLevels[(_loc_3 + 1)].imageHeight <= _loc_2)
            {
                
                _loc_3++;
            }
            if (_loc_3 >= this.zoomImg.zoomLevels.length)
            {
                _loc_3 = this.zoomImg.zoomLevels.length - 1;
            }
            if (_loc_3 == 0 && this.zoomImg.zoomLevels[_loc_3].preview && this.zoomImg.zoomLevels.length > 1)
            {
                _loc_3 = 1;
            }
            return _loc_3;
        }// end function

        public function paint(param1:Number) : void
        {
            var _loc_5:* = null;
            var _loc_2:* = this.getEyeDistance();
            var _loc_3:* = 0;
            this.renderTile.initFrustum(this.rect.width / 2 - _loc_3, this.rect.height / 2 - _loc_3, _loc_2);
            var _loc_4:* = _loc_2 * this.rect.height / Math.sqrt(this.rect.height * this.rect.height + this.rect.width * this.rect.width);
            this.renderTile.initFrustumSave(this.rect.width / 2 - _loc_3, this.rect.height / 2 - _loc_3, _loc_4);
            if (this.zoomImg)
            {
                this.zoomImg.increaseEpoch();
                this.zoomImg.rect = this.rect;
                this.zoomImg.viewer = this.viewer;
                this.zoomImg.renderTile = this.renderTile;
            }
            this.renderTile.bmpSmooth = this.viewer.bmpSmooth;
            this.renderTile.canv = this.viewer.canv;
            this.renderTile.canvOv = this.viewer.canvOv;
            this.renderTile.ed = _loc_2;
            this.renderTile.isCylinder = true;
            this.renderTile.rect = this.rect;
            if (this.viewer)
            {
                if (this.viewer.transform.perspectiveProjection)
                {
                    _loc_5 = this.viewer.transform.perspectiveProjection;
                }
                else
                {
                    _loc_5 = new PerspectiveProjection();
                    this.viewer.transform.perspectiveProjection = _loc_5;
                }
                _loc_5.projectionCenter = new Point(this.viewer.rect.width / 2 + this.viewer.marginLeft, this.viewer.rect.height / 2 + this.viewer.marginTop);
                this.viewer.hsClip.transform.perspectiveProjection = _loc_5;
                _loc_5.focalLength = _loc_2;
            }
            return;
        }// end function

        protected function updatePolyHotspots() : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = this.getEyeDistance();
            for each (_loc_2 in this.hotspots.hotspots)
            {
                
                if (_loc_2.outline)
                {
                    _loc_2.outline = this.renderTile.clipFrustum(_loc_2.outline);
                    for each (_loc_3 in _loc_2.outline)
                    {
                        
                        _loc_3.project(_loc_1, this.viewer.rect.width / 2, this.viewer.rect.height / 2);
                    }
                }
            }
            return;
        }// end function

        protected function updateActiveElements() : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = NaN;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = NaN;
            var _loc_9:* = NaN;
            var _loc_10:* = NaN;
            var _loc_11:* = NaN;
            var _loc_12:* = NaN;
            var _loc_13:* = null;
            var _loc_14:* = null;
            var _loc_1:* = this.getEyeDistance();
            for each (_loc_2 in this.activeElements)
            {
                
                _loc_6 = 640;
                _loc_7 = 480;
                if (_loc_2.video)
                {
                    _loc_6 = _loc_2.video.videoWidth;
                    _loc_7 = _loc_2.video.videoHeight;
                }
                if (_loc_2.w > 0 && _loc_2.h > 0)
                {
                    _loc_6 = _loc_2.w;
                    _loc_7 = _loc_2.h;
                    if (_loc_2.video)
                    {
                        _loc_2.video.width = _loc_6;
                        _loc_2.video.height = _loc_7;
                    }
                    if (_loc_2.image)
                    {
                    }
                }
                _loc_3 = new Matrix3D();
                _loc_4 = new Matrix3D();
                _loc_3.appendTranslation((-_loc_6) / 2, (-_loc_7) / 2 * _loc_2.stretch, 0);
                _loc_3.appendRotation(-_loc_2.rotX, new Vector3D(1, 0, 0));
                _loc_3.appendRotation(_loc_2.rotY, new Vector3D(0, 1, 0));
                _loc_3.appendRotation(_loc_2.rotZ, new Vector3D(0, 0, 1));
                _loc_5 = 500;
                if (_loc_2.fov > 0)
                {
                    _loc_12 = 2 * Math.tan(_loc_2.fov / 2 * Math.PI / 180);
                    _loc_5 = _loc_6 / _loc_12;
                }
                _loc_3.appendTranslation(0, 0, _loc_5);
                _loc_3.appendRotation(_loc_2.tilt, new Vector3D(1, 0, 0));
                _loc_3.appendRotation(-_loc_2.pan, new Vector3D(0, 1, 0));
                _loc_3.appendRotation(this.viewer.getPan(), new Vector3D(0, 1, 0));
                _loc_3.appendRotation(-this.viewer.getTilt(), new Vector3D(1, 0, 0));
                _loc_3.appendTranslation(0, 0, -_loc_1);
                _loc_3.appendTranslation(this.viewer.rect.width / 2, this.viewer.rect.height / 2, 0);
                _loc_8 = Math.min(this.viewer.rect.width / _loc_6, this.viewer.rect.height / _loc_7);
                if (_loc_2.clickMode == 4)
                {
                    _loc_8 = 1;
                }
                _loc_4.appendTranslation((-_loc_6) * _loc_8 / 2, (-_loc_7) * _loc_8 / 2, 0);
                _loc_4.appendTranslation(this.viewer.rect.width / 2, this.viewer.rect.height / 2, 0);
                if (_loc_2.targetPopupTrans != _loc_2.currentPopupTrans)
                {
                    if (_loc_2.targetPopupTrans > _loc_2.currentPopupTrans)
                    {
                        _loc_2.currentPopupTrans = _loc_2.currentPopupTrans + 0.02;
                    }
                    else
                    {
                        _loc_2.currentPopupTrans = _loc_2.currentPopupTrans - 0.02;
                    }
                    if (Math.abs(_loc_2.targetPopupTrans - _loc_2.currentPopupTrans) < 0.001)
                    {
                        _loc_2.currentPopupTrans = _loc_2.targetPopupTrans;
                    }
                    this.viewer.update();
                }
                _loc_9 = _loc_2.currentPopupTrans;
                if (_loc_9 > 0.5)
                {
                    _loc_9 = 2 * (1 - _loc_9);
                    _loc_9 = 2 * (1 - _loc_9) * _loc_9;
                    _loc_9 = 1 - 0.5 * _loc_9;
                }
                else
                {
                    _loc_9 = 2 * _loc_9;
                    _loc_9 = 2 * _loc_9 * _loc_9;
                    _loc_9 = 0.5 * _loc_9;
                }
                _loc_3.interpolateTo(_loc_4, _loc_9);
                _loc_10 = _loc_8 * _loc_9 + (1 - _loc_9);
                _loc_11 = _loc_8 * _loc_9 + (1 - _loc_9) * _loc_2.stretch;
                if (_loc_2.video)
                {
                    _loc_2.video.scaleX = _loc_10;
                    _loc_2.video.scaleY = _loc_11;
                }
                if (_loc_2.image)
                {
                    _loc_8 = _loc_8 * _loc_9 + (1 - _loc_9);
                    _loc_13 = _loc_2.image as Loader;
                    if (_loc_13 && _loc_13.content && _loc_13.content.width)
                    {
                        _loc_2.image.scaleX = _loc_6 / _loc_13.content.width * _loc_10;
                        _loc_2.image.scaleY = _loc_7 / _loc_13.content.height * _loc_11;
                    }
                    else
                    {
                        _loc_14 = _loc_2.image as Bitmap;
                        if (_loc_14)
                        {
                            _loc_2.image.scaleX = _loc_6 / _loc_14.bitmapData.width * _loc_10;
                            _loc_2.image.scaleY = _loc_7 / _loc_14.bitmapData.height * _loc_11;
                        }
                    }
                }
                _loc_2.transform.matrix3D = _loc_3;
                if (_loc_2.video)
                {
                    if (_loc_2.video.visible == false)
                    {
                        _loc_2.video.visible = true;
                        this.viewer.update();
                    }
                }
                if (_loc_2.image)
                {
                    if (_loc_2.image.visible == false)
                    {
                        _loc_2.image.visible = true;
                    }
                }
            }
            return;
        }// end function

        public function paintPolyHotspots() : void
        {
            var _loc_2:* = null;
            var _loc_3:* = false;
            var _loc_4:* = NaN;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_1:* = this.getEyeDistance();
            if (this.hotspots)
            {
                for each (_loc_2 in this.hotspots.hotspots)
                {
                    
                    _loc_3 = false;
                    _loc_4 = 1;
                    if (this.hotspots.polyMode == 1)
                    {
                        _loc_3 = true;
                    }
                    if (this.hotspots.polyMode == 2)
                    {
                        if (_loc_2 == this.hotspots.currentHotspot)
                        {
                            _loc_2.targetAlpha = 1;
                        }
                        else
                        {
                            _loc_2.targetAlpha = 0;
                        }
                    }
                    if (this.hotspots.polyMode == 3)
                    {
                        if (this.hotspots.currentHotspot && this.hotspots.currentHotspot.outline)
                        {
                            _loc_2.targetAlpha = 1;
                        }
                        else
                        {
                            _loc_2.targetAlpha = 0;
                        }
                    }
                    if (this.hotspots.polyMode >= 2)
                    {
                        if (_loc_2.currentAlpha != _loc_2.targetAlpha)
                        {
                            if (_loc_2.targetAlpha > _loc_2.currentAlpha)
                            {
                                _loc_2.currentAlpha = _loc_2.currentAlpha + this.hotspots.blendSpeed;
                                if (_loc_2.currentAlpha > _loc_2.targetAlpha)
                                {
                                    _loc_2.currentAlpha = _loc_2.targetAlpha;
                                }
                            }
                            else
                            {
                                _loc_2.currentAlpha = _loc_2.currentAlpha - this.hotspots.blendSpeed;
                                if (_loc_2.currentAlpha < _loc_2.targetAlpha)
                                {
                                    _loc_2.currentAlpha = _loc_2.targetAlpha;
                                }
                            }
                            this.viewer.update();
                        }
                        _loc_4 = _loc_2.currentAlpha;
                        if (_loc_4 > 0)
                        {
                            _loc_3 = true;
                        }
                    }
                    if (_loc_2.outline && _loc_3)
                    {
                        if (_loc_2.outline.length > 0)
                        {
                            this.viewer.canv.graphics.lineStyle(this.hotspots.polyBorderWidth, _loc_2.borderColor, _loc_2.borderAlpha * _loc_4);
                            this.viewer.canv.graphics.beginFill(_loc_2.backgroundColor, _loc_2.backgroundAlpha * _loc_4);
                            this.viewer.canv.graphics.moveTo(_loc_2.outline[0].px, _loc_2.outline[0].py);
                            _loc_6 = 1;
                            while (_loc_6 < _loc_2.outline.length)
                            {
                                
                                this.viewer.canv.graphics.lineTo(_loc_2.outline[_loc_6].px, _loc_2.outline[_loc_6].py);
                                _loc_6++;
                            }
                            this.viewer.canv.graphics.endFill();
                        }
                    }
                }
            }
            return;
        }// end function

        public function checkLimitsSphere() : void
        {
            var _loc_1:* = NaN;
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            if (this.fov.cur < this.fov.min)
            {
                this.fov.cur = this.fov.min;
            }
            if (this.fov.cur > this.fov.max)
            {
                this.fov.cur = this.fov.max;
            }
            _loc_2 = this.getVFov() / 2;
            var _loc_4:* = false;
            if (_loc_2 > this.maxFov2)
            {
                _loc_2 = this.maxFov2;
                _loc_4 = true;
            }
            _loc_1 = Math.atan(this.rect.width / this.rect.height * Math.tan(_loc_2 * Math.PI / 180)) * 180 / Math.PI;
            if (_loc_1 > this.maxFov2)
            {
                _loc_1 = this.maxFov2;
                _loc_2 = Math.atan(this.rect.height / this.rect.width * Math.tan(_loc_1 * Math.PI / 180)) * 180 / Math.PI;
                _loc_4 = true;
            }
            if (_loc_2 * 2 > this.tilt.max - this.tilt.min)
            {
                _loc_2 = (this.tilt.max - this.tilt.min) / 2;
                _loc_4 = true;
            }
            if (_loc_4)
            {
                this.setVFov(_loc_2 * 2);
            }
            if (this.tilt.max < 90)
            {
                if (this.tilt.cur + _loc_2 > this.tilt.max)
                {
                    this.tilt.cur = this.tilt.max - _loc_2;
                }
            }
            else if (this.tilt.cur > this.tilt.max)
            {
                this.tilt.cur = this.tilt.max;
            }
            if (this.tilt.min > -90)
            {
                if (this.tilt.cur - _loc_2 < this.tilt.min)
                {
                    this.tilt.cur = this.tilt.min + _loc_2;
                }
            }
            else if (this.tilt.cur < this.tilt.min)
            {
                this.tilt.cur = this.tilt.min;
            }
            if (this.pan.max - this.pan.min < 359.99)
            {
                this.checkLimitsPartSphere();
            }
            return;
        }// end function

        public function checkLimitsPartSphere() : void
        {
            var _loc_1:* = NaN;
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            var _loc_6:* = NaN;
            if (this.pan.max - this.pan.min >= 360)
            {
                return;
            }
            _loc_2 = this.getVFov() / 2;
            _loc_1 = Math.atan(this.rect.width / this.rect.height * Math.tan(_loc_2 * Math.PI / 180)) * 180 / Math.PI;
            var _loc_5:* = 1;
            _loc_3 = 180;
            _loc_4 = 90;
            _loc_6 = Math.abs(this.tilt.cur) + _loc_2;
            if (_loc_6 >= 89.9)
            {
                _loc_6 = 89.9;
            }
            var _loc_7:* = Math.tan(_loc_2 * Math.PI / 180);
            var _loc_8:* = Math.tan(_loc_6 * Math.PI / 180);
            _loc_5 = Math.sqrt(_loc_8 * _loc_8 + 1) / Math.sqrt(_loc_7 * _loc_7 + 1);
            _loc_3 = Math.atan(_loc_5 * Math.tan(_loc_1 * Math.PI / 180)) * 180 / Math.PI;
            if (_loc_3 * 2 > this.pan.max - this.pan.min)
            {
                _loc_5 = Math.tan((this.pan.max - this.pan.min) * Math.PI / 360) / Math.tan(_loc_1 * Math.PI / 180);
                _loc_6 = _loc_5 * Math.sqrt(_loc_7 * _loc_7 + 1);
                _loc_8 = Math.sqrt(_loc_6 * _loc_6 - 1);
                _loc_4 = 180 / Math.PI * Math.atan(_loc_8);
            }
            if (this.pan.cur + _loc_3 > this.pan.max)
            {
                this.pan.cur = this.pan.max - _loc_3;
                if (this.viewer.auto.rotate_active)
                {
                    this.viewer.auto.rotate_pan = -this.viewer.auto.rotate_pan;
                    this.viewer.dPan = 0;
                }
            }
            if (this.pan.cur - _loc_3 < this.pan.min)
            {
                this.pan.cur = this.pan.min + _loc_3;
                if (this.viewer.auto.rotate_active)
                {
                    this.viewer.auto.rotate_pan = -this.viewer.auto.rotate_pan;
                    this.viewer.dPan = 0;
                }
            }
            if (this.tilt.cur + _loc_2 > _loc_4)
            {
                this.tilt.cur = _loc_4 - _loc_2;
            }
            if (this.tilt.cur - _loc_2 < -_loc_4)
            {
                this.tilt.cur = -_loc_4 + _loc_2;
            }
            return;
        }// end function

        public function checkLimits() : void
        {
            return;
        }// end function

        public function init() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            this.bmp_loaded = new Array();
            this.bmp_loadedpf = new Array();
            _loc_2 = 6 * this.subtiles * this.subtiles;
            _loc_1 = 0;
            while (_loc_1 < _loc_2)
            {
                
                this.bmp_loaded.push(false);
                _loc_1++;
            }
            _loc_1 = 0;
            while (_loc_1 < 6)
            {
                
                this.bmp_loadedpf.push(false);
                _loc_1++;
            }
            this.initActiveElements();
            return;
        }// end function

        protected function queryHotspotImage(param1:int, param2:int, param3:int) : int
        {
            var _loc_6:* = NaN;
            var _loc_4:* = param3 / 3;
            var _loc_5:* = 0;
            if (this.bmp_hs[_loc_4] == null)
            {
                _loc_5 = 0;
            }
            else
            {
                _loc_6 = this.bmp_hs[_loc_4].getPixel(param1, param2);
                if (!isNaN(_loc_6))
                {
                    if (param3 == 2 || param3 == 5)
                    {
                        _loc_5 = _loc_6 % 256;
                    }
                    if (param3 == 1 || param3 == 4)
                    {
                        _loc_5 = Math.floor(_loc_6 / 256) % 256;
                    }
                    if (param3 == 0 || param3 == 3)
                    {
                        _loc_5 = Math.floor(_loc_6 / (256 * 256)) % 256;
                    }
                }
            }
            this.viewer.canv.useHandCursor = _loc_5 > 0;
            this.viewer.canv.buttonMode = _loc_5 > 0;
            if (this.hasOverlay)
            {
                this.viewer.canvOv.useHandCursor = this.viewer.canv.useHandCursor;
                this.viewer.canvOv.buttonMode = this.viewer.canv.buttonMode;
            }
            return _loc_5;
        }// end function

        public function checkHotspots(param1:int, param2:int) : void
        {
            return;
        }// end function

        public function checkPolygonHotspots(param1:int, param2:int) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_9:* = false;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_3:* = param1 - this.viewer.marginLeft;
            var _loc_4:* = param2 - this.viewer.marginTop;
            if (this.hotspots)
            {
                for each (_loc_5 in this.hotspots.hotspots)
                {
                    
                    if (_loc_5.outline && _loc_5.outline.length > 1)
                    {
                        _loc_9 = false;
                        _loc_7 = 0;
                        _loc_8 = _loc_5.outline.length - 1;
                        while (_loc_7 < _loc_5.outline.length)
                        {
                            
                            _loc_10 = _loc_5.outline[_loc_7];
                            _loc_11 = _loc_5.outline[_loc_8];
                            if (_loc_10.py > _loc_4 != _loc_11.py > _loc_4 && _loc_3 < (_loc_11.px - _loc_10.px) * (_loc_4 - _loc_10.py) / (_loc_11.py - _loc_10.py) + _loc_10.px)
                            {
                                _loc_9 = !_loc_9;
                            }
                            _loc_8 = _loc_7 + 1;
                        }
                        if (_loc_9)
                        {
                            _loc_6 = _loc_5;
                        }
                    }
                }
            }
            this.hotspots.changeCurrentHotspot(_loc_6, param1, param2);
            return;
        }// end function

        public function getVFov() : Number
        {
            return this.fov.cur;
        }// end function

        public function setVFov(param1:Number) : void
        {
            this.fov.cur = param1;
            return;
        }// end function

        protected function getEyeDistance() : Number
        {
            return this.rect.height / 2 / Math.tan(this.getVFov() * Math.PI / 360);
        }// end function

        public function initBitmaps() : void
        {
            return;
        }// end function

        public function loadExternalBitmaps() : Boolean
        {
            var cf:int;
            var imgNr:int;
            var ldr:Loader;
            var notLoaded:Boolean;
            cf;
            while (cf < 6)
            {
                
                ldr = this.externalTiles[cf];
                if (!this.bmp_loaded[cf])
                {
                    try
                    {
                        if (this.tileSize <= 0)
                        {
                            notLoaded;
                            this.tileSize = ldr.width;
                        }
                        else
                        {
                            if (ldr.content != null)
                            {
                                this.bmpTile[cf].draw(ldr.content);
                                this.bmp_loaded[cf] = ldr.contentLoaderInfo.bytesLoaded == ldr.contentLoaderInfo.bytesTotal;
                            }
                            else
                            {
                                notLoaded;
                            }
                            if (ldr.contentLoaderInfo.bytesLoaded < ldr.contentLoaderInfo.bytesTotal)
                            {
                                notLoaded;
                            }
                        }
                    }
                    catch (error:Error)
                    {
                        notLoaded;
                    }
                }
                cf = (cf + 1);
            }
            return notLoaded;
        }// end function

        public function loadExternalHotspots() : Boolean
        {
            var cf:int;
            var imgNr:int;
            var ldr:Loader;
            var notLoaded:Boolean;
            if (this.hasHotspots)
            {
                cf;
                while (cf < 2)
                {
                    
                    if (this.externalTiles[cf + 6] != null)
                    {
                        ldr = this.externalTiles[cf + 6];
                        try
                        {
                            if (ldr.content != null)
                            {
                                if (!this.bmp_loaded[cf + 6])
                                {
                                    if (ldr.contentLoaderInfo.bytesLoaded == ldr.contentLoaderInfo.bytesTotal)
                                    {
                                        this.bmp_hs[cf] = new BitmapData(ldr.content.width, ldr.content.height, false, this.preloadColor);
                                        this.bmp_hs[cf].draw(ldr.content);
                                        this.bmp_loaded[cf + 6] = true;
                                        this.hsTileWidth = ldr.content.width;
                                        this.hsTileHeight = ldr.content.height;
                                    }
                                }
                            }
                            else
                            {
                                notLoaded;
                            }
                            if (ldr.contentLoaderInfo.bytesLoaded < ldr.contentLoaderInfo.bytesTotal)
                            {
                                notLoaded;
                            }
                        }
                        catch (error:Error)
                        {
                            notLoaded;
                            if (viewer.debugText)
                            {
                                viewer.debugText.htmlText = viewer.debugText.htmlText + error.message;
                            }
                        }
                    }
                    cf = (cf + 1);
                }
            }
            return notLoaded;
        }// end function

        public function loadRepositioryBitmaps() : Boolean
        {
            var cf:int;
            var imgNr:int;
            var tmpBmp:BitmapData;
            var tileofs:int;
            var prefix:String;
            var loadLimit:int;
            var sx:int;
            var sy:int;
            var loadedTile:Boolean;
            var mat:Matrix;
            var notLoaded:Boolean;
            prefix;
            if (this.viewer.currentNodeId != "")
            {
                prefix = this.viewer.currentNodeId + "_";
            }
            if (this.enableDecodeLimit)
            {
                loadLimit = 1 + 6 * this.subtiles * this.subtiles / 10;
            }
            else
            {
                loadLimit = 10 * (this.subtiles * this.subtiles);
            }
            tileofs = (this.tileSize + (this.subtiles - 1)) / this.subtiles;
            cf;
            while (cf < 6)
            {
                
                if (this.hasPrevImages)
                {
                    loadedTile;
                    imgNr = cf * this.subtiles * this.subtiles;
                    sy;
                    while (sy < this.subtiles)
                    {
                        
                        sx;
                        while (sx < this.subtiles)
                        {
                            
                            if (this.bmp_loaded[imgNr])
                            {
                                loadedTile;
                            }
                            imgNr = (imgNr + 1);
                            sx = (sx + 1);
                        }
                        sy = (sy + 1);
                    }
                    if (!loadedTile)
                    {
                        try
                        {
                            if (!this.bmp_loadedpf[cf])
                            {
                                tmpBmp = this.viewer.imageReposGet(prefix + "pre" + cf);
                                this.bmp_loadedpf[cf] = true;
                                mat = new Matrix();
                                mat.scale(this.bmpTile[cf].width / tmpBmp.width, this.bmpTile[cf].height / tmpBmp.height);
                                this.bmpTile[cf].draw(tmpBmp, mat, null, null, null, true);
                            }
                        }
                        catch (error:Error)
                        {
                        }
                    }
                }
                imgNr = cf * this.subtiles * this.subtiles;
                sy;
                while (sy < this.subtiles)
                {
                    
                    sx;
                    while (sx < this.subtiles)
                    {
                        
                        try
                        {
                            if (!this.bmp_loaded[imgNr])
                            {
                                if (loadLimit > 0)
                                {
                                    tmpBmp = this.viewer.imageReposGet(prefix + "img" + imgNr);
                                    this.bmpTile[cf].copyPixels(tmpBmp, tmpBmp.rect, new Point(sx * tileofs, sy * tileofs));
                                    this.bmp_loaded[imgNr] = true;
                                    loadLimit = (loadLimit - 1);
                                    if (this.hasOverlay)
                                    {
                                        tmpBmp = this.viewer.imageReposGet(prefix + "imgo" + imgNr);
                                        if (tmpBmp)
                                        {
                                            this.bmpTileOverlay[cf].copyPixels(tmpBmp, tmpBmp.rect, new Point(sx * tileofs, sy * tileofs));
                                        }
                                    }
                                }
                                else
                                {
                                    notLoaded;
                                }
                            }
                        }
                        catch (error:Error)
                        {
                            notLoaded;
                        }
                        imgNr = (imgNr + 1);
                        sx = (sx + 1);
                    }
                    sy = (sy + 1);
                }
                cf = (cf + 1);
            }
            return notLoaded;
        }// end function

        public function loadRepositioryHotspots() : Boolean
        {
            var cf:int;
            var prefix:String;
            var notLoaded:Boolean;
            if (this.hasHotspots)
            {
                prefix;
                if (this.viewer.currentNodeId != "")
                {
                    prefix = this.viewer.currentNodeId + "_";
                }
                cf;
                while (cf < 2)
                {
                    
                    if (this.bmp_hs[cf] == null)
                    {
                        try
                        {
                            this.bmp_hs[cf] = this.viewer.imageReposGet(prefix + "hs" + cf);
                            this.hsTileWidth = this.bmp_hs[cf].width;
                            this.hsTileHeight = this.bmp_hs[cf].height;
                        }
                        catch (error:Error)
                        {
                            bmp_hs[cf] = null;
                            notLoaded;
                        }
                    }
                    cf = (cf + 1);
                }
            }
            return notLoaded;
        }// end function

        public function loadBitmaps() : void
        {
            var _loc_1:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_2:* = false;
            if (this.zoomImg == null)
            {
                this.initBitmaps();
                if (this.externalTiles[0] != null)
                {
                    _loc_2 = this.loadExternalBitmaps();
                }
                else
                {
                    _loc_2 = this.loadRepositioryBitmaps();
                }
            }
            if (this.externalTiles[6] != null)
            {
                _loc_2 = this.loadExternalHotspots() || _loc_2;
            }
            else
            {
                _loc_2 = this.loadRepositioryHotspots() || _loc_2;
            }
            if (!_loc_2)
            {
                this.viewer.completed = true;
            }
            return;
        }// end function

        public function loadTile(param1:int, param2:String) : void
        {
            var ldr:Loader;
            var tilenr:* = param1;
            var url:* = param2;
            try
            {
                ldr = new Loader();
                ldr.load(new URLRequest(this.viewer.expandFilename(url)));
                this.externalTiles[tilenr] = ldr;
                this.viewer.updateBytesTotal();
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        public function unload() : void
        {
            var _loc_1:* = null;
            for each (_loc_1 in this.activeElements)
            {
                
                this.viewer.canv.removeChild(_loc_1);
                _loc_1.remove();
            }
            this.activeElements = new Array();
            return;
        }// end function

        public function loadTilesConfig(param1:XML, param2:Boolean = false) : void
        {
            if (param1.hasOwnProperty("input"))
            {
                if (param1.input.hasOwnProperty("@tile0url"))
                {
                    this.loadTile(0, param1.input.@tile0url);
                }
                if (param1.input.hasOwnProperty("@tile1url"))
                {
                    this.loadTile(1, param1.input.@tile1url);
                }
                if (param1.input.hasOwnProperty("@tile2url"))
                {
                    this.loadTile(2, param1.input.@tile2url);
                }
                if (param1.input.hasOwnProperty("@tile3url"))
                {
                    this.loadTile(3, param1.input.@tile3url);
                }
                if (param1.input.hasOwnProperty("@tile4url"))
                {
                    this.loadTile(4, param1.input.@tile4url);
                }
                if (param1.input.hasOwnProperty("@tile5url"))
                {
                    this.loadTile(5, param1.input.@tile5url);
                }
                if (param1.input.hasOwnProperty("@hstile0url"))
                {
                    this.loadTile(6, param1.input.@hstile0url);
                }
                if (param1.input.hasOwnProperty("@hstile1url"))
                {
                    this.loadTile(7, param1.input.@hstile1url);
                }
            }
            return;
        }// end function

        public function readConfig(param1:XML, param2:Boolean = false) : void
        {
            if (param1.hasOwnProperty("input"))
            {
                if (param1.input.hasOwnProperty("@transparent"))
                {
                    this.transparentImage = param1.input.@transparent == 1;
                }
                else
                {
                    this.transparentImage = false;
                }
                if (param1.input.hasOwnProperty("level"))
                {
                    this.zoomImg = new ZoomLevelImages();
                    if (param2)
                    {
                        this.zoomImg.maxImgId = 6;
                    }
                    this.zoomImg.isCubic = param2;
                    this.zoomImg.viewer = this.viewer;
                    this.zoomImg.readConfig(param1);
                }
            }
            return;
        }// end function

        public function readAddonConfig(param1:XML) : void
        {
            var e:XML;
            var snd:GgSound;
            var v:GgActivePanoramaElement;
            var config:* = param1;
            if (config.hasOwnProperty("media"))
            {
                try
                {
                    var _loc_3:* = 0;
                    var _loc_4:* = config.media.video;
                    while (_loc_4 in _loc_3)
                    {
                        
                        e = _loc_4[_loc_3];
                        v = new GgActivePanoramaElement();
                        v.viewer = this.viewer;
                        v.readConfig(e);
                        v.openVideo();
                        this.activeElements.push(v);
                        snd = new GgSound();
                        snd.readConfig(e);
                        snd.keep = false;
                        snd.video = v.video;
                        snd.isVideo = true;
                        snd.netStream = v.netStream;
                        snd.transform = new SoundTransform(snd.level);
                        snd.setTransform(snd.transform);
                        snd.url = v.url;
                        this.viewer.sounds.addSound(snd);
                        if (snd.loop >= 0 && snd.mode != 4 && snd.mode != 6)
                        {
                            snd.trigger();
                        }
                        else
                        {
                            v.netStream.play(v.url, -2, 0);
                            v.netStream.pause();
                        }
                        v.snd = snd;
                    }
                    var _loc_3:* = 0;
                    var _loc_4:* = config.media.image;
                    while (_loc_4 in _loc_3)
                    {
                        
                        e = _loc_4[_loc_3];
                        v = new GgActivePanoramaElement();
                        v.viewer = this.viewer;
                        v.readConfig(e);
                        v.openImage();
                        this.activeElements.push(v);
                    }
                }
                catch (e:Error)
                {
                }
            }
            return;
        }// end function

        protected function initActiveElements() : void
        {
            var _loc_1:* = null;
            for each (_loc_1 in this.activeElements)
            {
                
                this.viewer.canv.addChild(_loc_1);
            }
            return;
        }// end function

    }
}
