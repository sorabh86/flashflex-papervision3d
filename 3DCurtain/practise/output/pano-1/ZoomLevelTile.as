package 
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;

    public class ZoomLevelTile extends Object
    {
        public var uldr:URLLoader;
        public var ldr:Loader;
        public var bmp:BitmapData;
        public var loadCompleted:Boolean;
        public var zlimages:ZoomLevelImages;
        public var zlevel:ZoomLevel;
        public var epoch:int;
        public var skip:int = 0;
        public var errorCnt:int = 0;

        public function ZoomLevelTile()
        {
            this.loadCompleted = false;
            this.epoch = 0;
            return;
        }// end function

        public function decodeComplete(event:Event) : void
        {
            var _loc_2:* = this.zlimages.decodeQueue.indexOf(this);
            if (_loc_2 >= 0)
            {
                this.zlimages.decodeQueue.splice(_loc_2, 1);
            }
            if (this.ldr.content)
            {
                this.bmp = new BitmapData(this.ldr.content.width, this.ldr.content.height, true, 0);
                this.bmp.draw(this.ldr.content);
                this.touch();
                this.zlimages.bmpLoadedMem = this.zlimages.bmpLoadedMem + this.memSize();
                if (!this.zlevel.keepBmp)
                {
                    this.zlimages.bmpLoaded.push(this);
                }
            }
            this.ldr = null;
            return;
        }// end function

        public function downloadComplete(event:Event) : void
        {
            var _loc_2:* = this.zlimages.downloadQueue.indexOf(this);
            if (_loc_2 >= 0)
            {
                this.zlimages.downloadQueue.splice(_loc_2, 1);
            }
            this.addBmp();
            this.loadCompleted = true;
            this.errorCnt = 0;
            if (this.zlevel.forceDecode)
            {
                this.startDecode();
            }
            return;
        }// end function

        public function startDecode() : void
        {
            this.ldr = new Loader();
            this.ldr.loadBytes(this.uldr.data);
            this.ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, this.decodeComplete);
            this.ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.decodeError);
            return;
        }// end function

        public function downloadError(event:Event) : void
        {
            var _loc_2:* = this.zlimages.downloadQueue.indexOf(this);
            if (_loc_2 >= 0)
            {
                this.zlimages.downloadQueue.splice(_loc_2, 1);
            }
            this.uldr = null;
            var _loc_3:* = this;
            var _loc_4:* = this.errorCnt + 1;
            _loc_3.errorCnt = _loc_4;
            this.skip = 1 << this.errorCnt;
            return;
        }// end function

        public function decodeError(event:Event) : void
        {
            var _loc_2:* = this.zlimages.decodeQueue.indexOf(this);
            if (_loc_2 >= 0)
            {
                this.zlimages.decodeQueue.splice(_loc_2, 1);
            }
            this.freeRaw();
            this.ldr = null;
            this.freeBmp();
            return;
        }// end function

        public function memSize() : int
        {
            if (this.bmp == null)
            {
                return 0;
            }
            return this.bmp.width * this.bmp.height * 4;
        }// end function

        public function addBmp() : void
        {
            this.zlimages.rawLoadedMem = this.zlimages.rawLoadedMem + this.uldr.bytesLoaded;
            if (!this.zlevel.keepRaw)
            {
                this.zlimages.rawLoaded.push(this);
            }
            return;
        }// end function

        public function freeBmp() : void
        {
            var _loc_1:* = 0;
            if (this.bmp != null)
            {
                _loc_1 = this.zlimages.bmpLoaded.indexOf(this);
                if (_loc_1 >= 0)
                {
                    this.zlimages.bmpLoaded.splice(_loc_1, 1);
                }
                this.zlimages.bmpLoadedMem = this.zlimages.bmpLoadedMem - this.memSize();
                this.ldr = null;
                this.bmp = null;
            }
            return;
        }// end function

        public function freeRaw() : void
        {
            var _loc_1:* = 0;
            if (this.uldr != null)
            {
                _loc_1 = this.zlimages.rawLoaded.indexOf(this);
                if (_loc_1 >= 0)
                {
                    this.zlimages.rawLoaded.splice(_loc_1, 1);
                }
                this.zlimages.rawLoadedMem = this.zlimages.rawLoadedMem - this.uldr.bytesLoaded;
                this.uldr = null;
                this.loadCompleted = false;
            }
            return;
        }// end function

        public function touch() : void
        {
            if (this.zlevel.keepRaw || this.zlevel.keepBmp)
            {
                this.epoch = 1 << 30;
            }
            else
            {
                this.epoch = this.zlimages.epochCnt;
            }
            return;
        }// end function

    }
}
