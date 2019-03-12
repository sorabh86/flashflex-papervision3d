package 
{

    public class ZoomLevel extends Object
    {
        public var imageWidth:int;
        public var imageHeight:int;
        public var tileWidth:int;
        public var tileHeight:int;
        public var tilesX:int;
        public var tilesY:int;
        public var tiles:Array;
        public var zlimages:ZoomLevelImages;
        public var tileRequestURL:String;
        public var keepBmp:Boolean = false;
        public var keepRaw:Boolean = false;
        public var embedded:Boolean = false;
        public var forceDownload:Boolean = false;
        public var forceDecode:Boolean = false;
        public var preview:Boolean = false;

        public function ZoomLevel(param1:ZoomLevelImages, param2:int, param3:int, param4:int, param5:int, param6:int = 0, param7:int = 0)
        {
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            var _loc_11:* = null;
            this.imageWidth = param2;
            this.imageHeight = param3;
            this.tileWidth = param4;
            this.tileHeight = param5;
            this.zlimages = param1;
            if (param6 == 0)
            {
                param6 = (this.imageWidth + (this.tileWidth - 1)) / this.tileWidth;
            }
            if (param7 == 0)
            {
                param7 = (this.imageHeight + (this.tileHeight - 1)) / this.tileHeight;
            }
            this.tilesX = param6;
            this.tilesY = param7;
            this.tiles = new Array();
            var _loc_8:* = 0;
            while (_loc_8 < param1.maxImgId)
            {
                
                _loc_9 = 0;
                while (_loc_9 < this.tilesY)
                {
                    
                    _loc_10 = 0;
                    while (_loc_10 < this.tilesX)
                    {
                        
                        _loc_11 = new ZoomLevelTile();
                        _loc_11.zlimages = this.zlimages;
                        _loc_11.zlevel = this;
                        this.tiles.push(_loc_11);
                        _loc_10++;
                    }
                    _loc_9++;
                }
                _loc_8++;
            }
            return;
        }// end function

    }
}
