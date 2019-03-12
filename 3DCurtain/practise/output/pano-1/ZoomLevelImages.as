package 
{
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;

    public class ZoomLevelImages extends Object
    {
        public var zoomLevels:Array;
        public var rect:Rectangle;
        public var renderTile:RenderTile;
        public var isCubic:Boolean = false;
        public var aliases:Array = null;
        public var downloadQueue:Array;
        public var decodeQueue:Array;
        public var bmpLoaded:Array;
        public var rawLoaded:Array;
        public var viewer:GgViewer;
        public var epochCnt:int;
        public var bmpLimitMem:int = 300;
        public var rawLimitMem:int = 200000000;
        public var bmpLimitQueue:int = 20;
        public var rawLimitQueue:int = 5;
        public var bmpLoadedMem:int = 0;
        public var rawLoadedMem:int = 0;
        public var tileRequestURL:String;
        public var tileRequestURLCube:Array;
        public var subTileSplit:int = 8;
        public var levelBias:Number = 0;
        private var isLoadingStatus:int = 0;
        public var maxImgId:int = 1;

        public function ZoomLevelImages()
        {
            this.epochCnt = 0;
            this.zoomLevels = new Array();
            this.downloadQueue = new Array();
            this.decodeQueue = new Array();
            this.bmpLoaded = new Array();
            this.rawLoaded = new Array();
            this.tileRequestURLCube = new Array();
            return;
        }// end function

        public function doEnterFrame() : void
        {
            var zit:ZoomLevelTile;
            try
            {
                if (this.bmpLoadedMem > this.bmpLimitMem)
                {
                    this.bmpLoaded = this.bmpLoaded.sortOn("epoch", Array.NUMERIC);
                    while (this.bmpLoaded.length > 1 && this.bmpLoadedMem > this.bmpLimitMem / 10 * 9)
                    {
                        
                        zit = this.bmpLoaded.shift();
                        if (zit.epoch + 5 >= this.epochCnt)
                        {
                            this.bmpLoaded.unshift(zit);
                            break;
                        }
                        zit.freeBmp();
                    }
                }
                if (this.rawLoadedMem > this.rawLimitMem)
                {
                    this.rawLoaded = this.rawLoaded.sortOn("epoch", Array.NUMERIC);
                    while (this.rawLoaded.length > 1 && this.rawLoadedMem > this.rawLimitMem / 10 * 9)
                    {
                        
                        zit = this.rawLoaded.shift();
                        zit.freeRaw();
                        if (zit.epoch + 5 >= this.epochCnt)
                        {
                            this.bmpLoaded.unshift(zit);
                            break;
                        }
                    }
                }
            }
            catch (err:Error)
            {
            }
            if (this.isLoadingStatus > 0)
            {
                var _loc_2:* = this;
                var _loc_3:* = this.isLoadingStatus - 1;
                _loc_2.isLoadingStatus = _loc_3;
            }
            if (this.viewer)
            {
                this.viewer.isLoadingLevels = this.downloadQueue.length + this.decodeQueue.length + this.isLoadingStatus > 0;
            }
            return;
        }// end function

        public function increaseEpoch() : void
        {
            var _loc_1:* = this;
            var _loc_2:* = this.epochCnt + 1;
            _loc_1.epochCnt = _loc_2;
            return;
        }// end function

        public function downloadLevel(param1:int) : void
        {
            var _loc_2:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_3:* = this.zoomLevels[param1];
            _loc_2 = 0;
            while (_loc_2 < Math.max(this.maxImgId, this.isCubic ? (6) : (1)))
            {
                
                if (this.aliases == null || this.aliases[_loc_2] == null)
                {
                    _loc_4 = 0;
                    while (_loc_4 < _loc_3.tilesY)
                    {
                        
                        _loc_5 = 0;
                        while (_loc_5 < _loc_3.tilesX)
                        {
                            
                            this.requestTile(_loc_2, param1, _loc_5, _loc_4, true);
                            _loc_5++;
                        }
                        _loc_4++;
                    }
                }
                _loc_2++;
            }
            return;
        }// end function

        public function requestTile(param1:int, param2:int, param3:int, param4:int, param5:Boolean = false) : void
        {
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = 0;
            var _loc_11:* = null;
            var _loc_12:* = 0;
            var _loc_13:* = 0;
            var _loc_14:* = null;
            var _loc_15:* = null;
            var _loc_16:* = null;
            var _loc_17:* = null;
            var _loc_6:* = this.zoomLevels[param2];
            var _loc_7:* = _loc_6.tiles[param3 + _loc_6.tilesX * (param4 + param1 * _loc_6.tilesY)];
            if (_loc_7.bmp != null)
            {
                return;
            }
            this.isLoadingStatus = 2;
            if (this.viewer)
            {
                this.viewer.update2();
                this.viewer.isLoadingLevels = true;
            }
            if (_loc_6.embedded)
            {
                try
                {
                    _loc_9 = "";
                    if (this.viewer && this.viewer.currentNodeId != "")
                    {
                        _loc_9 = this.viewer.currentNodeId + "_";
                    }
                    _loc_7.bmp = this.viewer.imageReposGet(_loc_9 + "mres_" + param1 + "_" + param2 + "_" + param3 + "_" + param4);
                    _loc_7.addBmp();
                }
                catch (e:Error)
                {
                }
            }
            else if (_loc_7.uldr == null)
            {
                if (this.downloadQueue.length < this.rawLimitQueue || param5)
                {
                    if (_loc_7.skip > 0)
                    {
                        var _loc_18:* = _loc_7;
                        var _loc_19:* = _loc_7.skip - 1;
                        _loc_18.skip = _loc_19;
                    }
                    else
                    {
                        if (this.tileRequestURL.length > 0)
                        {
                            _loc_8 = this.tileRequestURL;
                        }
                        if (this.tileRequestURLCube[param1] != null && this.tileRequestURLCube[param1] != "")
                        {
                            _loc_8 = this.tileRequestURLCube[param1];
                        }
                        do
                        {
                            
                            _loc_12 = 1;
                            while (_loc_8.charAt(_loc_10 + _loc_12) == "0")
                            {
                                
                                _loc_12++;
                            }
                            _loc_16 = _loc_8.charAt(_loc_10 + _loc_12);
                            _loc_17 = _loc_16.toLowerCase();
                            _loc_13 = 0;
                            if (_loc_17 == "x")
                            {
                                _loc_13 = param3;
                            }
                            if (_loc_17 == "y")
                            {
                                _loc_13 = param4;
                            }
                            if (_loc_17 == "c")
                            {
                                _loc_13 = param1;
                            }
                            if (_loc_17 == "l")
                            {
                                _loc_13 = param2;
                            }
                            if (_loc_17 == "r")
                            {
                                _loc_13 = this.zoomLevels.length - param2 - 1;
                            }
                            if (_loc_17 != _loc_16)
                            {
                                _loc_13++;
                            }
                            _loc_14 = _loc_13.toString();
                            while (_loc_14.length < _loc_12)
                            {
                                
                                _loc_14 = "0" + _loc_14;
                            }
                            _loc_15 = _loc_8.substr(_loc_10, (_loc_12 + 1));
                            _loc_8 = _loc_8.replace(_loc_15, _loc_14);
                            var _loc_18:* = _loc_8.indexOf("%");
                            _loc_10 = _loc_8.indexOf("%");
                        }while (_loc_18 >= 0)
                        _loc_11 = new URLRequest(this.viewer.expandFilename(_loc_8));
                        _loc_7.uldr = new URLLoader();
                        _loc_7.zlimages = this;
                        _loc_7.uldr.dataFormat = URLLoaderDataFormat.BINARY;
                        _loc_7.uldr.load(_loc_11);
                        _loc_7.uldr.addEventListener(Event.COMPLETE, _loc_7.downloadComplete);
                        _loc_7.uldr.addEventListener(IOErrorEvent.IO_ERROR, _loc_7.downloadError);
                        this.downloadQueue.push(_loc_7);
                    }
                }
            }
            else if (_loc_7.loadCompleted)
            {
                if (_loc_7.ldr == null)
                {
                    if (this.decodeQueue.length < this.bmpLimitQueue)
                    {
                        _loc_7.startDecode();
                        this.decodeQueue.push(_loc_7);
                    }
                }
            }
            return;
        }// end function

        public function touchZoomLevel(param1:int, param2:int, param3:GgRectangle) : void
        {
            var _loc_10:* = 0;
            var _loc_11:* = NaN;
            var _loc_12:* = NaN;
            var _loc_13:* = null;
            var _loc_14:* = null;
            var _loc_4:* = this.zoomLevels[param2];
            var _loc_5:* = Math.max(Math.floor(param3.x1 * _loc_4.imageWidth / _loc_4.tileWidth), 0);
            var _loc_6:* = Math.min(Math.ceil(param3.x2 * _loc_4.imageWidth / _loc_4.tileWidth), _loc_4.tilesX);
            var _loc_7:* = Math.max(Math.floor(param3.y1 * _loc_4.imageHeight / _loc_4.tileHeight), 0);
            var _loc_8:* = Math.min(Math.ceil(param3.y2 * _loc_4.imageHeight / _loc_4.tileHeight), _loc_4.tilesY);
            var _loc_9:* = _loc_7;
            while (_loc_9 < _loc_8)
            {
                
                _loc_10 = _loc_5;
                while (_loc_10 < _loc_6)
                {
                    
                    _loc_11 = Number(_loc_4.imageWidth) / Number(_loc_4.tileWidth);
                    _loc_12 = Number(_loc_4.imageHeight) / Number(_loc_4.tileHeight);
                    _loc_13 = new GgRectangle(0, 0, 0, 0);
                    _loc_13.x1 = Math.max(Math.max(Number(_loc_10) / _loc_11, param3.x1), 0);
                    _loc_13.y1 = Math.max(Math.max(Number(_loc_9) / _loc_12, param3.y1), 0);
                    _loc_13.x2 = Math.min(Math.min(Number((_loc_10 + 1)) / _loc_11, param3.x2), 1);
                    _loc_13.y2 = Math.min(Math.min(Number((_loc_9 + 1)) / _loc_12, param3.y2), 1);
                    _loc_14 = _loc_4.tiles[_loc_10 + _loc_4.tilesX * (_loc_9 + param1 * _loc_4.tilesY)];
                    if (_loc_14.bmp)
                    {
                        _loc_14.touch();
                    }
                    if (param2 > 0)
                    {
                        this.touchZoomLevel(param1, (param2 - 1), _loc_13);
                    }
                    _loc_10++;
                }
                _loc_9++;
            }
            return;
        }// end function

        public function renderZoomLevel(param1:int, param2:int, param3:GgVector3d, param4:GgVector3d, param5:GgVector3d, param6:GgVector3d, param7:GgRectangle, param8:int = -1) : void
        {
            var _loc_10:* = null;
            var _loc_24:* = 0;
            var _loc_25:* = 0;
            var _loc_26:* = NaN;
            var _loc_27:* = NaN;
            var _loc_28:* = null;
            var _loc_29:* = null;
            var _loc_30:* = NaN;
            var _loc_31:* = NaN;
            var _loc_9:* = this.zoomLevels[param2];
            var _loc_11:* = param3.clone();
            var _loc_12:* = param4.clone();
            var _loc_13:* = param5.clone();
            var _loc_14:* = param6.clone();
            var _loc_15:* = this.rect.width;
            var _loc_16:* = this.rect.width / 2;
            var _loc_17:* = this.rect.height;
            var _loc_18:* = this.rect.height / 2;
            if (param8 < 0)
            {
                param8 = param2;
            }
            var _loc_19:* = Math.max(Math.floor(param7.x1 * _loc_9.imageWidth / _loc_9.tileWidth), 0);
            var _loc_20:* = Math.min(Math.ceil(param7.x2 * _loc_9.imageWidth / _loc_9.tileWidth), _loc_9.tilesX);
            if (param7.x2 >= 1)
            {
                _loc_20 = _loc_9.tilesX + Math.min(Math.ceil((param7.x2 - 1) * _loc_9.imageWidth / _loc_9.tileWidth), _loc_9.tilesX);
            }
            var _loc_21:* = Math.max(Math.floor(param7.y1 * _loc_9.imageHeight / _loc_9.tileHeight), 0);
            var _loc_22:* = Math.min(Math.ceil(param7.y2 * _loc_9.imageHeight / _loc_9.tileHeight), _loc_9.tilesY);
            if (_loc_20 > _loc_9.tilesX)
            {
                _loc_9.tilesX = _loc_9.tilesX;
            }
            var _loc_23:* = _loc_21;
            while (_loc_23 < _loc_22)
            {
                
                _loc_24 = _loc_19;
                while (_loc_24 < _loc_20)
                {
                    
                    _loc_25 = _loc_24 % _loc_9.tilesX;
                    _loc_26 = Number(_loc_9.imageWidth) / Number(_loc_9.tileWidth);
                    _loc_27 = Number(_loc_9.imageHeight) / Number(_loc_9.tileHeight);
                    _loc_28 = new GgRectangle(0, 0, 0, 0);
                    if (_loc_24 > _loc_25)
                    {
                        _loc_28.x1 = Math.max(Math.max(Number(_loc_25) / _loc_26, (param7.x1 - 1)), 0);
                        _loc_28.y1 = Math.max(Math.max(Number(_loc_23) / _loc_27, param7.y1), 0);
                        _loc_28.x2 = Math.min(Math.min(Number((_loc_25 + 1)) / _loc_26, (param7.x2 - 1)), 1);
                        _loc_28.y2 = Math.min(Math.min(Number((_loc_23 + 1)) / _loc_27, param7.y2), 1);
                    }
                    else
                    {
                        _loc_28.x1 = Math.max(Math.max(Number(_loc_25) / _loc_26, param7.x1), 0);
                        _loc_28.y1 = Math.max(Math.max(Number(_loc_23) / _loc_27, param7.y1), 0);
                        _loc_28.x2 = Math.min(Math.min(Number((_loc_25 + 1)) / _loc_26, param7.x2), 1);
                        _loc_28.y2 = Math.min(Math.min(Number((_loc_23 + 1)) / _loc_27, param7.y2), 1);
                    }
                    _loc_29 = _loc_9.tiles[_loc_25 + _loc_9.tilesX * (_loc_23 + param1 * _loc_9.tilesY)];
                    _loc_11.interpol4uv(param3, param4, param5, param6, _loc_28.x1, _loc_28.y1);
                    _loc_12.interpol4uv(param3, param4, param5, param6, _loc_28.x2, _loc_28.y1);
                    _loc_13.interpol4uv(param3, param4, param5, param6, _loc_28.x1, _loc_28.y2);
                    _loc_14.interpol4uv(param3, param4, param5, param6, _loc_28.x2, _loc_28.y2);
                    _loc_29.touch();
                    if (_loc_29.bmp)
                    {
                        _loc_30 = Number(_loc_25) / _loc_26 + 0.5 / _loc_9.imageWidth;
                        _loc_31 = Number(_loc_23) / _loc_27 + 0.5 / _loc_9.imageHeight;
                        _loc_11.u = (_loc_11.u - _loc_30) * _loc_26;
                        _loc_11.v = (_loc_11.v - _loc_31) * _loc_27;
                        _loc_14.u = (_loc_14.u - _loc_30) * _loc_26 * (_loc_9.tileWidth + this.renderTile.tileOverlap * 2) / (_loc_9.tileWidth + this.renderTile.tileOverlap * 2 - 1);
                        _loc_14.v = (_loc_14.v - _loc_31) * _loc_27 * (_loc_9.tileHeight + this.renderTile.tileOverlap * 2) / (_loc_9.tileHeight + this.renderTile.tileOverlap * 2 - 1);
                        if (this.renderTile.tileOverlap == 0)
                        {
                            if (_loc_25 == (_loc_9.tilesX - 1))
                            {
                                _loc_11.u = _loc_11.u * (Number(_loc_9.tileWidth) / Number(_loc_29.bmp.width - this.renderTile.tileOverlap * 2));
                                _loc_14.u = _loc_14.u * (Number(_loc_9.tileWidth) / Number(_loc_29.bmp.width - this.renderTile.tileOverlap * 2));
                            }
                            if (_loc_23 == (_loc_9.tilesY - 1))
                            {
                                _loc_11.v = _loc_11.v * (Number(_loc_9.tileHeight) / Number(_loc_29.bmp.height - this.renderTile.tileOverlap * 2));
                                _loc_14.v = _loc_14.v * (Number(_loc_9.tileHeight) / Number(_loc_29.bmp.height - this.renderTile.tileOverlap * 2));
                            }
                        }
                        _loc_12.u = _loc_14.u;
                        _loc_12.v = _loc_11.v;
                        _loc_13.u = _loc_11.u;
                        _loc_13.v = _loc_14.v;
                        _loc_11.project(this.renderTile.ed, _loc_16, _loc_18);
                        _loc_12.project(this.renderTile.ed, _loc_16, _loc_18);
                        _loc_13.project(this.renderTile.ed, _loc_16, _loc_18);
                        _loc_14.project(this.renderTile.ed, _loc_16, _loc_18);
                        this.renderTile.bmp = _loc_29.bmp;
                        this.renderTile.tileWidth = _loc_9.tileWidth;
                        this.renderTile.tileHeight = _loc_9.tileHeight;
                        if (_loc_11.cz < 0 || _loc_12.cz < 0 || _loc_13.cz < 0 || _loc_14.cz < 0)
                        {
                            this.renderTile.displayTile(_loc_11, _loc_12, _loc_13, _loc_14, this.subTileSplit / Math.min(_loc_9.tilesX, _loc_9.tilesY));
                        }
                        if (param2 > 0)
                        {
                            this.touchZoomLevel(param1, (param2 - 1), _loc_28);
                        }
                    }
                    else
                    {
                        _loc_10 = new Array();
                        _loc_10.push(_loc_11.cloneBase());
                        _loc_10.push(_loc_12.cloneBase());
                        _loc_10.push(_loc_14.cloneBase());
                        _loc_10.push(_loc_13.cloneBase());
                        _loc_10 = this.renderTile.clipFrustum(_loc_10);
                        if (_loc_10.length > 0 || _loc_9.tilesX < 3)
                        {
                            if (param2 > 0)
                            {
                                this.renderZoomLevel(param1, (param2 - 1), param3, param4, param5, param6, _loc_28, param8);
                            }
                            this.requestTile(param1, param2, _loc_25, _loc_23);
                        }
                    }
                    _loc_24++;
                }
                _loc_23++;
            }
            return;
        }// end function

        public function renderFlatZoomLevel(param1:int, param2:int, param3:Rectangle, param4:GgRectangle, param5:int = -1, param6:Boolean = true) : void
        {
            var _loc_8:* = null;
            var _loc_18:* = 0;
            var _loc_19:* = 0;
            var _loc_20:* = NaN;
            var _loc_21:* = NaN;
            var _loc_22:* = null;
            var _loc_23:* = null;
            var _loc_24:* = NaN;
            var _loc_25:* = NaN;
            var _loc_26:* = null;
            var _loc_27:* = NaN;
            var _loc_28:* = NaN;
            var _loc_29:* = NaN;
            var _loc_30:* = NaN;
            var _loc_7:* = this.zoomLevels[param2];
            var _loc_9:* = param3.width;
            var _loc_10:* = param3.width / 2;
            var _loc_11:* = param3.height;
            var _loc_12:* = param3.height / 2;
            if (param5 < 0)
            {
                param5 = param2;
            }
            var _loc_13:* = Math.max(Math.floor(param4.x1 * _loc_7.imageWidth / _loc_7.tileWidth), 0);
            var _loc_14:* = Math.min(Math.ceil(param4.x2 * _loc_7.imageWidth / _loc_7.tileWidth), _loc_7.tilesX);
            var _loc_15:* = Math.max(Math.floor(param4.y1 * _loc_7.imageHeight / _loc_7.tileHeight), 0);
            var _loc_16:* = Math.min(Math.ceil(param4.y2 * _loc_7.imageHeight / _loc_7.tileHeight), _loc_7.tilesY);
            if (_loc_14 > _loc_7.tilesX)
            {
                _loc_7.tilesX = _loc_7.tilesX;
            }
            var _loc_17:* = _loc_15;
            while (_loc_17 < _loc_16)
            {
                
                _loc_18 = _loc_13;
                while (_loc_18 < _loc_14)
                {
                    
                    _loc_19 = _loc_18 % _loc_7.tilesX;
                    _loc_20 = Number(_loc_7.imageWidth) / Number(_loc_7.tileWidth);
                    _loc_21 = Number(_loc_7.imageHeight) / Number(_loc_7.tileHeight);
                    _loc_22 = new GgRectangle(0, 0, 0, 0);
                    if (_loc_18 > _loc_19)
                    {
                        _loc_22.x1 = Math.max(Math.max(Number(_loc_19) / _loc_20, (param4.x1 - 1)), 0);
                        _loc_22.y1 = Math.max(Math.max(Number(_loc_17) / _loc_21, param4.y1), 0);
                        _loc_22.x2 = Math.min(Math.min(Number((_loc_19 + 1)) / _loc_20, (param4.x2 - 1)), 1);
                        _loc_22.y2 = Math.min(Math.min(Number((_loc_17 + 1)) / _loc_21, param4.y2), 1);
                    }
                    else
                    {
                        _loc_22.x1 = Math.max(Math.max(Number(_loc_19) / _loc_20, param4.x1), 0);
                        _loc_22.y1 = Math.max(Math.max(Number(_loc_17) / _loc_21, param4.y1), 0);
                        _loc_22.x2 = Math.min(Math.min(Number((_loc_19 + 1)) / _loc_20, param4.x2), 1);
                        _loc_22.y2 = Math.min(Math.min(Number((_loc_17 + 1)) / _loc_21, param4.y2), 1);
                    }
                    _loc_23 = _loc_7.tiles[_loc_19 + _loc_7.tilesX * (_loc_17 + param1 * _loc_7.tilesY)];
                    if (!_loc_23)
                    {
                        return;
                    }
                    _loc_23.touch();
                    if (_loc_23.bmp)
                    {
                        _loc_24 = Number(_loc_19) / _loc_20 + 0.5 / _loc_7.imageWidth;
                        _loc_25 = Number(_loc_17) / _loc_21 + 0.5 / _loc_7.imageHeight;
                        _loc_26 = new Matrix();
                        _loc_27 = param3.width / _loc_7.imageWidth;
                        _loc_28 = param3.height / _loc_7.imageHeight;
                        _loc_29 = 1;
                        _loc_30 = _loc_7.imageHeight / _loc_7.imageWidth * 1 * (1 * param3.width / param3.height);
                        _loc_26.translate(-_loc_29, -_loc_29);
                        _loc_26.scale(_loc_27, _loc_28);
                        _loc_26.translate(Number(_loc_19) / _loc_20 * param3.width, Number(_loc_17) / _loc_21 * param3.height);
                        _loc_26.translate(param3.left, param3.top);
                        this.renderTile.canv.graphics.beginBitmapFill(_loc_23.bmp, _loc_26, false, param6);
                        this.renderTile.canv.graphics.drawRect(_loc_22.x1 * param3.width + param3.left - _loc_29, _loc_22.y1 * param3.height + param3.top - _loc_29, (_loc_22.x2 - _loc_22.x1) * param3.width + 2 * _loc_29, (_loc_22.y2 - _loc_22.y1) * param3.height + 2 * _loc_29);
                        this.renderTile.canv.graphics.endFill();
                        if (param2 > 0)
                        {
                            this.touchZoomLevel(param1, (param2 - 1), _loc_22);
                        }
                    }
                    else
                    {
                        if (param2 > 0)
                        {
                            this.renderFlatZoomLevel(param1, (param2 - 1), param3, _loc_22, param5);
                        }
                        this.requestTile(param1, param2, _loc_19, _loc_17);
                    }
                    _loc_18++;
                }
                _loc_17++;
            }
            return;
        }// end function

        public function readConfig(param1:XML) : void
        {
            var _loc_2:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_3:* = 0;
            if (param1.hasOwnProperty("input"))
            {
                if (param1.input.hasOwnProperty("@leveltileurl"))
                {
                    this.tileRequestURL = param1.input.@leveltileurl;
                }
                if (param1.input.hasOwnProperty("@leveltilesize"))
                {
                    _loc_3 = param1.input.@leveltilesize;
                }
                if (param1.input.hasOwnProperty("@levelbias"))
                {
                    this.levelBias = param1.input.@levelbias;
                }
                if (param1.input.hasOwnProperty("@levelmemraw"))
                {
                    this.rawLimitMem = param1.input.@levelmemraw * 1024 * 1024;
                }
                if (param1.input.hasOwnProperty("@levelmembmp"))
                {
                    this.bmpLimitMem = param1.input.@levelmembmp * 1024 * 1024;
                }
                if (param1.input.hasOwnProperty("@levelqueueraw"))
                {
                    this.rawLimitQueue = param1.input.@levelqueueraw;
                }
                if (param1.input.hasOwnProperty("@levelqueuebmp"))
                {
                    this.bmpLimitQueue = param1.input.@levelqueuebmp;
                }
                _loc_2 = 0;
                while (_loc_2 < 6)
                {
                    
                    if (param1.input.hasOwnProperty("@leveltile" + _loc_2 + "url"))
                    {
                        this.tileRequestURLCube[_loc_2] = param1.input.attribute("leveltile" + _loc_2 + "url").toString();
                    }
                    _loc_2++;
                }
                for each (_loc_6 in param1.input.level)
                {
                    
                    _loc_7 = 0;
                    _loc_8 = 0;
                    _loc_9 = _loc_3;
                    if (_loc_6.hasOwnProperty("@width"))
                    {
                        _loc_7 = _loc_6.@width;
                    }
                    if (_loc_6.hasOwnProperty("@height"))
                    {
                        _loc_8 = _loc_6.@height;
                    }
                    if (_loc_6.hasOwnProperty("@tilesize"))
                    {
                        _loc_9 = _loc_6.@tilesize;
                    }
                    _loc_5 = new ZoomLevel(this, _loc_7, _loc_8, _loc_9, _loc_9, 0, 0);
                    if (_loc_6.hasOwnProperty("@embed"))
                    {
                        _loc_5.embedded = _loc_6.@embed == 1;
                    }
                    if (_loc_6.hasOwnProperty("@preload"))
                    {
                        _loc_5.forceDownload = _loc_6.@preload == 1;
                    }
                    if (_loc_6.hasOwnProperty("@predecode"))
                    {
                        _loc_5.forceDecode = _loc_6.@preload == 1;
                        _loc_5.keepRaw = _loc_5.forceDecode;
                    }
                    if (_loc_6.hasOwnProperty("@preview"))
                    {
                        _loc_5.preview = _loc_6.@preview == 1;
                    }
                    this.zoomLevels.push(_loc_5);
                }
                this.zoomLevels = this.zoomLevels.sortOn("imageWidth", Array.NUMERIC);
                _loc_4 = 0;
                while (_loc_4 < this.zoomLevels.length)
                {
                    
                    _loc_5 = this.zoomLevels[_loc_4];
                    if (_loc_5.forceDownload)
                    {
                        _loc_5.keepRaw = true;
                        this.downloadLevel(_loc_4);
                    }
                    _loc_4++;
                }
            }
            return;
        }// end function

    }
}
