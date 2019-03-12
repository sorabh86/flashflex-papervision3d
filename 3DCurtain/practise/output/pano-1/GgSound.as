package 
{
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;

    public class GgSound extends Object
    {
        public var id:String;
        public var url:String;
        public var hash:String;
        public var pan:Number;
        public var tilt:Number;
        public var v:GgVector3d;
        public var mode:int;
        public var loop:int;
        public var sound:Sound;
        public var video:Video;
        public var field:Number;
        public var pansize:Number;
        public var tiltsize:Number;
        public var ambientlevel:Number;
        public var level:Number;
        public var channel:SoundChannel;
        public var netStream:NetStream;
        public var transform:SoundTransform;
        public var triggered:Boolean = false;
        public var playPos:Number;
        public var keep:Boolean;
        public var isVideo:Boolean;
        public var isStopped:Boolean;
        public var isLoaded:Boolean;
        public var isInEffect:Boolean;
        private var loopCnt:int;
        public var viewer:GgViewer;

        public function GgSound()
        {
            this.pan = 0;
            this.tilt = 0;
            this.pansize = 0;
            this.tiltsize = 0;
            this.loop = 0;
            this.mode = 1;
            this.level = 0.2;
            this.ambientlevel = 0.1;
            this.field = 10;
            this.playPos = 0;
            this.keep = false;
            this.v = new GgVector3d();
            this.isStopped = false;
            this.isLoaded = false;
            this.isVideo = false;
            this.isInEffect = false;
            return;
        }// end function

        public function trigger() : void
        {
            this.transform = new SoundTransform(this.level);
            if (this.sound != null)
            {
                if (this.loop == 0)
                {
                    this.channel = this.sound.play(this.playPos, this.loop, this.transform);
                    this.channel.addEventListener(Event.SOUND_COMPLETE, this.soundCompleteRepeatHandler);
                }
                else
                {
                    this.channel = this.sound.play(this.playPos, this.loop > 0 ? (this.loop) : (0), this.transform);
                    this.channel.addEventListener(Event.SOUND_COMPLETE, this.soundCompleteClearHandler);
                }
            }
            if (this.netStream)
            {
                this.netStream.play(this.url);
                this.netStream.seek(this.playPos);
                this.netStream.addEventListener(NetStatusEvent.NET_STATUS, this.onStatus);
                this.loopCnt = 1;
            }
            this.setTransform(this.transform);
            this.triggered = true;
            if (this.playPos > 0)
            {
                this.playPos = 0;
            }
            this.isStopped = false;
            return;
        }// end function

        private function onStatus(event:NetStatusEvent) : void
        {
            if (event.info.code == "NetStream.Play.Stop")
            {
                if (this.loop == 0 || this.loopCnt < this.loop)
                {
                    this.netStream.seek(0);
                    var _loc_2:* = this;
                    var _loc_3:* = this.loopCnt + 1;
                    _loc_2.loopCnt = _loc_3;
                }
                else
                {
                    this.triggered = false;
                    this.playPos = 0;
                }
            }
            return;
        }// end function

        public function stop() : void
        {
            if (this.channel)
            {
                this.channel.stop();
            }
            if (this.netStream)
            {
                this.netStream.pause();
                this.netStream.seek(0);
            }
            this.channel = null;
            this.triggered = false;
            this.playPos = 0;
            this.isStopped = true;
            return;
        }// end function

        public function remove() : void
        {
            this.stop();
            if (this.netStream)
            {
                this.netStream.close();
            }
            this.netStream = null;
            this.video = null;
            return;
        }// end function

        public function pause() : void
        {
            if (this.channel)
            {
                this.playPos = this.channel.position;
                this.channel.stop();
                this.isStopped = true;
            }
            if (this.netStream)
            {
                this.playPos = this.netStream.time;
                this.netStream.pause();
                this.isStopped = true;
            }
            this.channel = null;
            this.triggered = false;
            return;
        }// end function

        public function playPause() : void
        {
            if (this.sound || this.netStream)
            {
                if (!this.triggered)
                {
                    this.trigger();
                }
                else
                {
                    this.pause();
                }
            }
            return;
        }// end function

        public function setTransform(param1:SoundTransform) : void
        {
            this.transform = param1;
            if (this.channel)
            {
                this.channel.soundTransform = param1;
            }
            if (this.netStream)
            {
                this.netStream.soundTransform = param1;
            }
            return;
        }// end function

        public function soundCompleteClearHandler(event:Event) : void
        {
            this.channel = null;
            this.transform = null;
            this.triggered = false;
            this.playPos = 0;
            return;
        }// end function

        public function soundCompleteRepeatHandler(event:Event) : void
        {
            this.channel = this.sound.play(0, 0, this.transform);
            this.channel.addEventListener(Event.SOUND_COMPLETE, this.soundCompleteRepeatHandler);
            return;
        }// end function

        public function readConfig(param1:XML) : void
        {
            if (param1.hasOwnProperty("@id"))
            {
                this.id = param1.@id;
            }
            if (param1.hasOwnProperty("@mode"))
            {
                this.mode = param1.@mode;
            }
            if (param1.hasOwnProperty("@hash"))
            {
                this.hash = param1.@hash;
            }
            if (param1.hasOwnProperty("@loop"))
            {
                this.loop = param1.@loop;
            }
            if (param1.hasOwnProperty("@pan"))
            {
                this.pan = param1.@pan;
            }
            if (param1.hasOwnProperty("@tilt"))
            {
                this.tilt = param1.@tilt;
            }
            if (param1.hasOwnProperty("@field"))
            {
                this.field = param1.@field;
            }
            if (param1.hasOwnProperty("@pansize"))
            {
                this.pansize = param1.@pansize;
            }
            if (param1.hasOwnProperty("@tiltsize"))
            {
                this.tiltsize = param1.@tiltsize;
            }
            if (param1.hasOwnProperty("@ambientlevel"))
            {
                this.ambientlevel = param1.@ambientlevel;
            }
            if (param1.hasOwnProperty("@level"))
            {
                this.level = param1.@level;
            }
            return;
        }// end function

    }
}
