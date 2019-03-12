package 
{
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;

    public class VideoPanoClass extends Sprite
    {
        private var videoURL:String;
        public var connection:NetConnection;
        public var stream:NetStream;
        public var bmp:BitmapData;
        public var video:Video;
        private var lastTime:Number;
        public var dirSound:Boolean;
        private var hasImage:Boolean;
        private var pano:PanoViewer;
        private var loop:Boolean = true;
        public var framerate:Number;

        public function VideoPanoClass(param1:PanoViewer)
        {
            this.connection = new NetConnection();
            this.connection.addEventListener(NetStatusEvent.NET_STATUS, this.netStatusHandler, false, 0, true);
            this.connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler, false, 0, true);
            this.connection.connect(null);
            this.hasImage = false;
            this.bmp = null;
            this.pano = param1;
            this.lastTime = -1;
            this.dirSound = true;
            addEventListener(Event.ENTER_FRAME, this.copyVideo);
            return;
        }// end function

        public function cleanup() : void
        {
            removeEventListener(Event.ENTER_FRAME, this.copyVideo);
            this.connection.removeEventListener(NetStatusEvent.NET_STATUS, this.netStatusHandler);
            this.connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this.connection.close();
            this.connection = null;
            this.video = null;
            this.stream.close();
            this.stream = null;
            this.bmp = null;
            return;
        }// end function

        private function netStatusHandler(event:NetStatusEvent) : void
        {
            switch(event.info.code)
            {
                case "NetConnection.Connect.Success":
                {
                    this.connectStream();
                    break;
                }
                case "NetStream.Play.StreamNotFound":
                {
                    break;
                }
                case "NetStream.Play.Complete":
                {
                    this.stream.resume();
                    break;
                }
                case "NetStream.Play.Stop":
                {
                    if (this.loop)
                    {
                        this.stream.seek(0);
                        this.stream.resume();
                    }
                    this.hasImage = false;
                    break;
                }
                case "NetStream.Buffer.Empty":
                {
                    this.hasImage = false;
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    this.hasImage = true;
                    break;
                }
                case "NetStream.Buffer.Flush":
                {
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function securityErrorHandler(event:SecurityErrorEvent) : void
        {
            return;
        }// end function

        public function onMetaData(param1:Object) : void
        {
            this.bmp = new BitmapData(param1.width, param1.height);
            this.video = new Video(param1.width, param1.height);
            this.video.attachNetStream(this.stream);
            this.framerate = param1.framerate;
            return;
        }// end function

        public function onXMPData(param1:Object) : void
        {
            return;
        }// end function

        public function onCuePoint(param1:Object) : void
        {
            return;
        }// end function

        private function copyVideo(event:Event) : void
        {
            var _loc_2:* = NaN;
            var _loc_3:* = null;
            var _loc_4:* = NaN;
            if (this.bmp != null)
            {
                _loc_2 = this.stream.time;
                if (this.lastTime != _loc_2)
                {
                    this.lastTime = _loc_2;
                    this.bmp.draw(this.video);
                    this.pano.bmpVideo = this.bmp;
                    this.pano.update();
                }
            }
            if (this.dirSound)
            {
                _loc_3 = this.stream.soundTransform;
                if (this.pano)
                {
                    _loc_4 = Math.cos(this.pano.getPan() * Math.PI / 180) * 0.5 + 0.5;
                    _loc_3.leftToLeft = _loc_4;
                    _loc_3.rightToRight = _loc_4;
                    _loc_3.leftToRight = 1 - _loc_4;
                    _loc_3.rightToLeft = 1 - _loc_4;
                    this.stream.soundTransform = _loc_3;
                }
            }
            return;
        }// end function

        private function connectStream() : void
        {
            this.stream = new NetStream(this.connection);
            this.stream.client = this;
            this.stream.addEventListener(NetStatusEvent.NET_STATUS, this.netStatusHandler);
            var _loc_1:* = 16;
            this.stream.play(this.videoURL);
            return;
        }// end function

        public function pause() : void
        {
            this.stream.togglePause();
            return;
        }// end function

        public function play() : void
        {
            this.stream.resume();
            return;
        }// end function

        public function stop() : void
        {
            this.stream.pause();
            this.stream.seek(0);
            return;
        }// end function

        public function forward() : void
        {
            this.stream.seek(this.stream.time + 5);
            return;
        }// end function

        public function backward() : void
        {
            var _loc_1:* = this.stream.time - 5;
            if (_loc_1 < 0)
            {
                _loc_1 = 0;
            }
            this.stream.seek(_loc_1);
            return;
        }// end function

        public function stepForward() : void
        {
            if (this.framerate > 0)
            {
                this.stream.seek(this.stream.time + 1 / this.framerate);
                this.stream.pause();
            }
            return;
        }// end function

        public function stepBackward() : void
        {
            var _loc_1:* = NaN;
            if (this.framerate > 0)
            {
                _loc_1 = this.stream.time - 1 / this.framerate;
                if (_loc_1 < 0)
                {
                    _loc_1 = 0;
                }
                this.stream.seek(_loc_1);
                this.stream.pause();
            }
            return;
        }// end function

        public function time() : Number
        {
            return this.stream.time;
        }// end function

        public function xmlConfig(param1:XML) : void
        {
            if (param1.hasOwnProperty("@url"))
            {
                this.videoURL = param1.@url;
            }
            if (param1.hasOwnProperty("@dirsound"))
            {
                this.dirSound = param1.@dirsound == 1;
            }
            if (this.videoURL != "")
            {
                this.connectStream();
            }
            return;
        }// end function

    }
}
