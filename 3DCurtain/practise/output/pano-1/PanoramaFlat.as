package 
{
    import Panorama.*;
    import PanoramaFlat.*;
    import flash.display.*;
    import flash.geom.*;

    public class PanoramaFlat extends Panorama
    {
        public var flatImageWidth:Number = 0;
        public var flatImageHeight:Number = 0;
        protected var alwaysScaleToFit:Boolean = true;

        public function PanoramaFlat()
        {
            return;
        }// end function

        override public function initBitmaps() : void
        {
            var _loc_1:* = 0;
            _loc_1 = 0;
            while (_loc_1 < 6)
            {
                
                if (bmpTile[_loc_1] == null && this.flatImageWidth > 0 && zoomImg == null)
                {
                    bmpTile[_loc_1] = new BitmapData((this.flatImageWidth + 2) / 3, (this.flatImageHeight + 1) / 2, transparentImage, preloadColor);
                    if (hasOverlay && bmpTileOverlay[_loc_1] == null)
                    {
                        bmpTileOverlay[_loc_1] = new BitmapData(bmpTile[_loc_1].width, bmpTile[_loc_1].height, true);
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
            var _loc_19:* = NaN;
            var _loc_20:* = NaN;
            var _loc_21:* = 0;
            if (hasHotspots)
            {
                _loc_14 = this.getVFov();
                _loc_15 = viewer.getPositionAngles(param1, param2);
                _loc_8 = _loc_15.x;
                _loc_9 = _loc_15.y;
                _loc_10 = new GgVector3d(0, 0, -1);
                _loc_10.rotx(_loc_9 * Math.PI / 180);
                _loc_10.roty(_loc_8 * Math.PI / 180);
                _loc_10.rotx((-tilt.cur) * Math.PI / 180);
                _loc_10.roty((-pan.cur) * Math.PI / 180);
                _loc_16 = rect.height / this.flatImageHeight * (100 / _loc_14);
                _loc_17 = this.flatImageHeight * pan.cur / 100;
                _loc_18 = this.flatImageHeight * tilt.cur / 100;
                _loc_19 = (this.flatImageWidth + 2) / 3;
                _loc_20 = (this.flatImageHeight + 1) / 2;
                _loc_11 = (param1 - rect.width / 2) / _loc_16 - _loc_17 + this.flatImageWidth / 2;
                _loc_12 = (param2 - rect.height / 2) / _loc_16 - _loc_18 + this.flatImageHeight / 2;
                _loc_6 = _loc_11 * hsTileWidth / _loc_19 % hsTileWidth;
                _loc_7 = _loc_12 * hsTileHeight / _loc_20 % hsTileHeight;
                _loc_13 = Math.floor(_loc_11 / _loc_19) + 3 * Math.floor(_loc_12 / _loc_20);
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
                if (_loc_7 >= hsTileHeight)
                {
                    _loc_7 = hsTileWidth - 1;
                }
                _loc_21 = queryHotspotImage(_loc_6, _loc_7, _loc_13);
                hotspots.changeCurrentQtHotspot(_loc_21, param1, param2);
            }
            else
            {
                viewer.hotspots.currentHotspotId = 0;
            }
            return;
        }// end function

        override public function checkLimits() : void
        {
            var _loc_1:* = NaN;
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            if (fov.cur < fov.min)
            {
                fov.cur = fov.min;
            }
            if (fov.cur > fov.max)
            {
                fov.cur = fov.max;
            }
            _loc_2 = this.getVFov() / 2;
            _loc_1 = rect.width / rect.height * _loc_2;
            var _loc_4:* = this.flatImageWidth / this.flatImageHeight * 50;
            if (this.alwaysScaleToFit)
            {
                if (_loc_2 > 50)
                {
                    _loc_2 = 50;
                    _loc_1 = rect.width / rect.height * _loc_2;
                }
                if (_loc_1 > _loc_4)
                {
                    _loc_2 = rect.height / rect.width * _loc_4;
                    _loc_1 = _loc_4;
                }
            }
            if (_loc_1 > _loc_4)
            {
                pan.cur = 0;
            }
            else
            {
                if (pan.cur + _loc_1 > _loc_4)
                {
                    pan.cur = _loc_4 - _loc_1;
                    if (viewer.auto.rotate_active)
                    {
                        viewer.auto.rotate_pan = -viewer.auto.rotate_pan;
                        viewer.dPan = 0;
                    }
                }
                if (pan.cur - _loc_1 < -_loc_4)
                {
                    pan.cur = -(_loc_4 - _loc_1);
                    if (viewer.auto.rotate_active)
                    {
                        viewer.auto.rotate_pan = -viewer.auto.rotate_pan;
                        viewer.dPan = 0;
                    }
                }
            }
            if (_loc_2 > 50)
            {
                tilt.cur = 0;
            }
            else
            {
                if (tilt.cur + _loc_2 > 50)
                {
                    tilt.cur = 50 - _loc_2;
                }
                if (tilt.cur - _loc_2 < -50)
                {
                    tilt.cur = -(50 - _loc_2);
                }
            }
            this.setVFov(_loc_2 * 2);
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
                    _loc_2 = rect.height / rect.width * (fov.cur / 2);
                    break;
                }
                case 2:
                {
                    _loc_1 = Math.sqrt(rect.width * rect.width + rect.height * rect.height);
                    _loc_2 = rect.height / _loc_1 * (fov.cur / 2);
                    break;
                }
                case 3:
                {
                    if (rect.height * this.flatImageWidth < rect.width * this.flatImageHeight)
                    {
                        _loc_2 = fov.cur / 2;
                    }
                    else
                    {
                        _loc_2 = this.flatImageWidth * rect.height / (rect.width * this.flatImageHeight) * (fov.cur / 2);
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
                    _loc_4 = rect.width / rect.height * _loc_3;
                    fov.cur = _loc_4 * 2;
                    break;
                }
                case 2:
                {
                    _loc_6 = Math.sqrt(rect.width * rect.width + rect.height * rect.height);
                    _loc_5 = _loc_6 / rect.height * _loc_3;
                    fov.cur = _loc_5 * 2;
                    break;
                }
                case 3:
                {
                    if (rect.height * this.flatImageWidth < rect.width * this.flatImageHeight)
                    {
                        fov.cur = _loc_3 * 2;
                    }
                    else
                    {
                        _loc_4 = _loc_3 * (rect.width * this.flatImageHeight) / (this.flatImageWidth * rect.height);
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

        public function updateHotspots() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_3:* = this.getVFov();
            var _loc_4:* = rect.height / this.flatImageHeight / _loc_3;
            if (this.flatImageWidth == 0 || this.flatImageHeight == 0)
            {
                return;
            }
            _loc_1 = 0;
            while (_loc_1 < hotspots.hotspots.length)
            {
                
                _loc_2 = hotspots.hotspots[_loc_1];
                if (_loc_2.clip)
                {
                    _loc_2.clip.visible = true;
                    _loc_2.clip.x = rect.width / 2 + _loc_2.ofs.x + this.flatImageHeight * _loc_4 * (pan.cur - _loc_2.posPan);
                    _loc_2.clip.y = rect.height / 2 + _loc_2.ofs.y + this.flatImageHeight * _loc_4 * (tilt.cur - _loc_2.posTilt);
                }
                if (_loc_2.polygon)
                {
                    _loc_6 = new Array();
                    for each (_loc_5 in _loc_2.polygon)
                    {
                        
                        _loc_7 = new GgVector3d();
                        _loc_7.px = rect.width / 2 + _loc_2.ofs.x + this.flatImageHeight * _loc_4 * (pan.cur - _loc_5.pan);
                        _loc_7.py = rect.height / 2 + _loc_2.ofs.y + this.flatImageHeight * _loc_4 * (tilt.cur - _loc_5.tilt);
                        _loc_6.push(_loc_7);
                    }
                    _loc_2.outline = _loc_6;
                }
                _loc_1++;
            }
            return;
        }// end function

        override public function paint(param1:Number) : void
        {
            super.paint(param1);
            if (zoomImg)
            {
                this.paint_zoom(param1);
            }
            else
            {
                this.paint_embedded(param1);
            }
            paintPolyHotspots();
            return;
        }// end function

        public function paint_embedded(param1:Number) : void
        {
            var _loc_9:* = NaN;
            if (this.flatImageWidth == 0 || this.flatImageHeight == 0)
            {
                return;
            }
            viewer.canv.graphics.clear();
            var _loc_2:* = this.getVFov();
            var _loc_3:* = rect.height / this.flatImageHeight * (100 / _loc_2);
            var _loc_4:* = this.flatImageHeight * pan.cur / 100;
            var _loc_5:* = this.flatImageHeight * tilt.cur / 100;
            var _loc_6:* = new Matrix();
            var _loc_7:* = Math.floor((this.flatImageWidth + 2) / 3);
            var _loc_8:* = Math.floor((this.flatImageHeight + 1) / 2);
            _loc_6.translate(_loc_4, _loc_5);
            if (viewer.stage.quality == "LOW")
            {
            }
            _loc_6.scale(_loc_3, _loc_3);
            _loc_6.translate(rect.width / 2, rect.height / 2);
            _loc_6.translate((-1.5 * _loc_7) * _loc_3, (-_loc_8) * _loc_3);
            _loc_9 = 0;
            while (_loc_9 < 3)
            {
                
                if (_loc_6.tx > (-_loc_7) * _loc_3 && _loc_6.tx < rect.width && _loc_6.ty > (-_loc_8) * _loc_3 && _loc_6.ty < rect.height)
                {
                    viewer.canv.graphics.beginBitmapFill(bmpTile[_loc_9], _loc_6, false, viewer.bmpSmooth);
                    viewer.canv.graphics.drawRect(_loc_6.tx, _loc_6.ty, _loc_7 * _loc_3 + 2, _loc_8 * _loc_3 + 2);
                    viewer.canv.graphics.endFill();
                }
                _loc_6.translate(_loc_7 * _loc_3, 0);
                _loc_9 = _loc_9 + 1;
            }
            _loc_6.translate((-3 * _loc_7) * _loc_3, _loc_8 * _loc_3);
            _loc_9 = 0;
            while (_loc_9 < 3)
            {
                
                if (_loc_6.tx > (-_loc_7) * _loc_3 && _loc_6.tx < rect.width && _loc_6.ty > (-_loc_8) * _loc_3 && _loc_6.ty < rect.height)
                {
                    viewer.canv.graphics.beginBitmapFill(bmpTile[_loc_9 + 3], _loc_6, false, viewer.bmpSmooth);
                    viewer.canv.graphics.drawRect(_loc_6.tx, _loc_6.ty, _loc_7 * _loc_3 + 2, _loc_8 * _loc_3 + 2);
                    viewer.canv.graphics.endFill();
                }
                _loc_6.translate(_loc_7 * _loc_3, 0);
                _loc_9 = _loc_9 + 1;
            }
            this.updateHotspots();
            return;
        }// end function

        public function paint_zoom(param1:Number) : void
        {
            viewer.canv.graphics.clear();
            var _loc_2:* = this.getVFov();
            var _loc_3:* = 0.5 * rect.height * (100 / _loc_2);
            var _loc_4:* = pan.cur / 50;
            var _loc_5:* = tilt.cur / 50;
            var _loc_6:* = _loc_3 * this.flatImageWidth / this.flatImageHeight;
            var _loc_7:* = new GgVector3d(-_loc_6 + _loc_3 * _loc_4, _loc_3 * (-1 + _loc_5), -renderTile.ed, 0, 0);
            var _loc_8:* = new GgVector3d(_loc_6 + _loc_3 * _loc_4, _loc_3 * (-1 + _loc_5), -renderTile.ed, 1, 0);
            var _loc_9:* = new GgVector3d(-_loc_6 + _loc_3 * _loc_4, _loc_3 * (1 + _loc_5), -renderTile.ed, 0, 1);
            var _loc_10:* = new GgVector3d(_loc_6 + _loc_3 * _loc_4, _loc_3 * (1 + _loc_5), -renderTile.ed, 1, 1);
            var _loc_11:* = new GgRectangle(0, 0, 1, 1);
            var _loc_12:* = this.flatImageHeight / this.flatImageWidth;
            var _loc_13:* = rect.width / rect.height;
            _loc_11.x1 = 0.5 + 0.5 * ((-pan.cur) / 50 - _loc_13 * _loc_2 / 100) * _loc_12;
            _loc_11.x2 = 0.5 + 0.5 * ((-pan.cur) / 50 + _loc_13 * _loc_2 / 100) * _loc_12;
            _loc_11.y1 = 0.5 + 0.5 * ((-tilt.cur) / 50 - _loc_2 / 100);
            _loc_11.y2 = 0.5 + 0.5 * ((-tilt.cur) / 50 + _loc_2 / 100);
            var _loc_14:* = 0;
            var _loc_15:* = rect.height * (100 / _loc_2);
            _loc_14 = getLevel(_loc_15);
            zoomImg.subTileSplit = 8;
            zoomImg.renderZoomLevel(0, _loc_14, _loc_7, _loc_8, _loc_9, _loc_10, _loc_11);
            this.updateHotspots();
            return;
        }// end function

        override public function readConfig(param1:XML, param2:Boolean = false) : void
        {
            super.readConfig(param1);
            if (param1.hasOwnProperty("input"))
            {
                if (param1.input.hasOwnProperty("@width"))
                {
                    this.flatImageWidth = param1.input.@width;
                }
                if (param1.input.hasOwnProperty("@height"))
                {
                    this.flatImageHeight = param1.input.@height;
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
                if (param1.display.hasOwnProperty("@scaletofit"))
                {
                    this.alwaysScaleToFit = param1.display.@scaletofit == 1;
                }
            }
            return;
        }// end function

    }
}
