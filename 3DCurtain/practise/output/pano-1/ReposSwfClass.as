package 
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;

    public class ReposSwfClass extends Sprite
    {
        private var reposId:String;
        private var cnt:int = 0;
        private var ldr:Loader;
        private var ba:ByteArray;
        private var isStopped:Boolean = false;
        public var unloadOnHide:Boolean = true;
        public var parentSkinObj:SkinObjectClass;
        public var debugText:TextField;
        private var external:Boolean;
        private static var imageRepos:ImageRepository = new ImageRepository();

        public function ReposSwfClass(param1:String, param2:Boolean = false)
        {
            this.reposId = param1;
            this.external = param2;
            addEventListener(Event.ENTER_FRAME, this.checkLoaded, false, 0, true);
            addEventListener(Event.ENTER_FRAME, this.doEnterFrame, false, 0, true);
            this.ldr = new Loader();
            this.ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, this.afterLoaded);
            addChild(this.ldr);
            return;
        }// end function

        public function start() : void
        {
            this.isStopped = false;
            if (this.unloadOnHide)
            {
                this.load();
            }
            return;
        }// end function

        public function load() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            _loc_1 = new LoaderContext();
            _loc_1.applicationDomain = new ApplicationDomain(null);
            if (this.external)
            {
                _loc_2 = new URLRequest(this.reposId);
                this.ldr.load(_loc_2, _loc_1);
            }
            else if (this.ba.length > 0)
            {
                this.ldr.loadBytes(this.ba, _loc_1);
            }
            return;
        }// end function

        public function stop() : void
        {
            this.isStopped = true;
            if (this.ldr && this.unloadOnHide)
            {
                if ("unloadAndStop" in this.ldr)
                {
                    this.ldr.unloadAndStop();
                }
                else
                {
                    this.ldr.unload();
                }
            }
            return;
        }// end function

        public function changeUrl(param1:String) : void
        {
            var _loc_2:* = this.unloadOnHide;
            this.unloadOnHide = true;
            this.stop();
            this.external = true;
            this.reposId = param1;
            this.start();
            this.unloadOnHide = _loc_2;
            return;
        }// end function

        public function setText(param1:String) : void
        {
            var _loc_2:* = null;
            try
            {
                _loc_2 = this.ldr.content as MovieClip;
                if (_loc_2)
                {
                    if ("ggOnSetText" in _loc_2)
                    {
                        _loc_2.ggOnSetText(param1);
                        return;
                    }
                }
            }
            catch (error:Error)
            {
            }
            this.changeUrl(param1);
            return;
        }// end function

        private function checkLoaded(event:Event) : void
        {
            try
            {
                if (this.external)
                {
                    removeEventListener(Event.ENTER_FRAME, this.checkLoaded);
                    if (!this.unloadOnHide || !this.isStopped)
                    {
                        this.load();
                    }
                }
                else
                {
                    this.ba = imageRepos.getByteArray(this.reposId);
                    if (this.ba.length > 0)
                    {
                        removeEventListener(Event.ENTER_FRAME, this.checkLoaded);
                        if (!this.unloadOnHide || !this.isStopped)
                        {
                            this.load();
                        }
                    }
                }
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        private function doEnterFrame(event:Event) : void
        {
            try
            {
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        private function afterLoaded(event:Event) : void
        {
            var _loc_2:* = null;
            try
            {
                _loc_2 = this.ldr.content as MovieClip;
                if (this.debugText)
                {
                    this.debugText.htmlText = this.debugText.htmlText + _loc_2.toString();
                }
                if (_loc_2)
                {
                    if (this.parentSkinObj)
                    {
                        _loc_2.ggViewer = this.parentSkinObj.skin.pano;
                        _loc_2.ggHotspot = this.parentSkinObj.hotspot;
                    }
                }
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

    }
}
