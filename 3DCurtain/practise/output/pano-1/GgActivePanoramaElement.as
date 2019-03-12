package 
{
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.system.*;

    public class GgActivePanoramaElement extends Sprite
    {
        public var video:Video;
        public var netConnection:NetConnection;
        public var netStream:NetStream;
        public var pan:Number = 0;
        public var tilt:Number = 0;
        public var rotX:Number = 0;
        public var rotY:Number = 0;
        public var rotZ:Number = 0;
        public var fov:Number = 10;
        public var w:Number = 320;
        public var h:Number = 240;
        public var stretch:Number = 1;
        public var url:String = "";
        public var viewer:PanoViewer;
        public var targetPopupTrans:Number = 0;
        public var currentPopupTrans:Number = 0;
        public var snd:GgSound;
        public var clickMode:int = 0;
        public var image:DisplayObject;
        public var id:String;

        public function GgActivePanoramaElement()
        {
            this.pan = 180;
            this.tilt = 20;
            this.rotX = 0;
            this.rotY = 0;
            this.rotZ = 0;
            this.stretch = 1;
            addEventListener(MouseEvent.CLICK, this.doMouseClick, false, 0, true);
            return;
        }// end function

        public function openVideo() : void
        {
            this.video = new Video(this.w, this.h);
            this.netConnection = new NetConnection();
            this.netConnection.connect(null);
            this.netStream = new NetStream(this.netConnection);
            try
            {
                this.url = this.viewer.expandFilename(this.url);
                this.netStream.client = {onMetaData:function (param1:Object) : void
            {
                return;
            }// end function
            };
                this.video.attachNetStream(this.netStream);
                this.netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
                this.video.visible = false;
                addChild(this.video);
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        private function asyncErrorHandler(event:AsyncErrorEvent) : void
        {
            return;
        }// end function

        private function _nofile(event:IOErrorEvent) : void
        {
            return;
        }// end function

        public function openImage() : void
        {
            var context:LoaderContext;
            var ldr:Loader;
            var urlReq:URLRequest;
            try
            {
                if (this.url != "")
                {
                    context = new LoaderContext();
                    context.applicationDomain = new ApplicationDomain(null);
                    ldr = new Loader();
                    ldr.visible = false;
                    this.url = this.viewer.expandFilename(this.url);
                    urlReq = new URLRequest(this.url);
                    ldr.addEventListener(IOErrorEvent.IO_ERROR, this._nofile);
                    ldr.load(urlReq, context);
                    this.image = ldr;
                }
                else
                {
                    this.image = new Bitmap(this.viewer.imageReposGet("media_" + this.viewer.currentNodeId + this.id));
                }
            }
            catch (e:Error)
            {
                if (viewer.debugText)
                {
                    viewer.debugText.htmlText = viewer.debugText.htmlText + ("AddMedia: " + "media_" + viewer.currentNodeId + id + " / " + e.message);
                }
                image = new Bitmap(new BitmapData(16, 16, false));
            }
            this.image.visible = false;
            addChild(this.image);
            return;
        }// end function

        public function doMouseClick(event:MouseEvent) : void
        {
            if (this.clickMode == 1 || this.clickMode == 4)
            {
                if (this.targetPopupTrans > 0)
                {
                    this.targetPopupTrans = 0;
                }
                else
                {
                    this.targetPopupTrans = 1;
                    parent.setChildIndex(this, (parent.numChildren - 1));
                    if (this.snd && !this.snd.triggered)
                    {
                        this.snd.trigger();
                    }
                }
            }
            if (this.clickMode == 2)
            {
                if (this.snd)
                {
                    this.snd.playPause();
                }
            }
            this.viewer.update();
            return;
        }// end function

        public function readConfig(param1:XML) : void
        {
            if (param1.hasOwnProperty("@id"))
            {
                this.id = param1.@id;
            }
            if (param1.hasOwnProperty("@pan"))
            {
                this.pan = param1.@pan;
            }
            if (param1.hasOwnProperty("@tilt"))
            {
                this.tilt = param1.@tilt;
            }
            if (param1.hasOwnProperty("@rotx"))
            {
                this.rotX = param1.@rotx;
            }
            if (param1.hasOwnProperty("@roty"))
            {
                this.rotY = param1.@roty;
            }
            if (param1.hasOwnProperty("@rotz"))
            {
                this.rotZ = param1.@rotz;
            }
            if (param1.hasOwnProperty("@fov"))
            {
                this.fov = param1.@fov;
            }
            if (param1.hasOwnProperty("@width"))
            {
                this.w = param1.@width;
            }
            if (param1.hasOwnProperty("@height"))
            {
                this.h = param1.@height;
            }
            if (param1.hasOwnProperty("@stretch"))
            {
                this.stretch = param1.@stretch;
            }
            if (param1.hasOwnProperty("@clickmode"))
            {
                this.clickMode = param1.@clickmode;
            }
            if (param1.hasOwnProperty("source") && param1.source[0].hasOwnProperty("@url"))
            {
                this.url = param1.source[0].@url;
            }
            return;
        }// end function

        public function remove() : void
        {
            this.video = null;
            this.netStream = null;
            return;
        }// end function

    }
}
