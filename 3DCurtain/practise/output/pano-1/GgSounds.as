package 
{
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;

    public class GgSounds extends Object
    {
        public var repos:ImageRepository;
        public var items:Array;
        public var loadingComplete:Boolean = false;
        public var currentPan:Number = 0;
        public var currentTilt:Number = 0;
        public var currentFov:Number = 90;
        public var mainVolume:Number = 1;
        public var currentV:GgVector3d;
        public var getSoundRepos:Function;
        public var viewer:GgViewer;

        public function GgSounds()
        {
            this.repos = new ImageRepository();
            this.getSoundRepos = this.repos.getSound;
            this.items = new Array();
            this.currentV = new GgVector3d();
            return;
        }// end function

        public function xmlConfig(param1:XML) : void
        {
            var sound:XML;
            var id:String;
            var title:String;
            var url:String;
            var target:String;
            var ggsnd:GgSound;
            var config:* = param1;
            try
            {
                var _loc_3:* = 0;
                var _loc_4:* = config.sound;
                while (_loc_4 in _loc_3)
                {
                    
                    sound = _loc_4[_loc_3];
                    url;
                    target;
                    title;
                    if (sound.hasOwnProperty("@id"))
                    {
                        ggsnd = new GgSound();
                        ggsnd.viewer = this.viewer;
                        ggsnd.id = sound.@id;
                        ggsnd.hash = "";
                        ggsnd.readConfig(sound);
                        if (sound.hasOwnProperty("@keep"))
                        {
                            ggsnd.keep = sound.@keep == 1;
                        }
                        if (sound.hasOwnProperty("source") && sound.source[0].hasOwnProperty("@url"))
                        {
                            if (sound.source[0].@url.length() > 0)
                            {
                                ggsnd.url = sound.source[0].@url;
                                ggsnd.sound = new Sound(new URLRequest(this.viewer.expandFilename(ggsnd.url)));
                            }
                        }
                        ggsnd.v.fromPanTilt(ggsnd.pan, ggsnd.tilt);
                        this.addSound(ggsnd);
                    }
                }
                this.loadingComplete = false;
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        public function doEnterFrame(event:Event) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            var _loc_7:* = NaN;
            var _loc_8:* = NaN;
            var _loc_9:* = NaN;
            var _loc_10:* = NaN;
            var _loc_11:* = NaN;
            var _loc_12:* = NaN;
            var _loc_13:* = NaN;
            if (!this.loadingComplete)
            {
                this.checkLoad();
            }
            this.currentV.fromPanTilt(this.currentPan, this.currentTilt);
            _loc_3 = 0;
            while (_loc_3 < this.items.length)
            {
                
                _loc_2 = this.items[_loc_3];
                if (_loc_2.sound != null || _loc_2.video != null)
                {
                    _loc_8 = _loc_2.pan - this.currentPan;
                    _loc_9 = _loc_2.tilt - this.currentTilt;
                    _loc_10 = _loc_2.field;
                    if (_loc_10 < 0)
                    {
                        _loc_10 = this.currentFov;
                    }
                    while (_loc_8 < -180)
                    {
                        
                        _loc_8 = _loc_8 + 360;
                    }
                    while (_loc_8 > 180)
                    {
                        
                        _loc_8 = _loc_8 - 360;
                    }
                    if (_loc_2.mode == 2)
                    {
                        if (_loc_2.transform != null)
                        {
                            _loc_4 = Math.cos(this.currentPan * Math.PI / 180) * 0.5 + 0.5;
                            _loc_2.transform.leftToLeft = Math.sqrt(_loc_4);
                            _loc_2.transform.rightToRight = Math.sqrt(_loc_4);
                            _loc_2.transform.leftToRight = Math.sqrt(1 - _loc_4);
                            _loc_2.transform.rightToLeft = Math.sqrt(1 - _loc_4);
                            _loc_2.setTransform(_loc_2.transform);
                        }
                    }
                    if (_loc_2.mode == 3)
                    {
                        if (_loc_2.transform != null)
                        {
                            if (_loc_8 < 0)
                            {
                                if (_loc_8 < -_loc_2.pansize)
                                {
                                    _loc_8 = _loc_8 + _loc_2.pansize;
                                }
                                else
                                {
                                    _loc_8 = 0;
                                }
                            }
                            else if (_loc_8 > _loc_2.pansize)
                            {
                                _loc_8 = _loc_8 - _loc_2.pansize;
                            }
                            else
                            {
                                _loc_8 = 0;
                            }
                            _loc_11 = _loc_2.ambientlevel;
                            _loc_12 = _loc_2.level;
                            _loc_9 = Math.abs(_loc_9);
                            if (_loc_9 < _loc_2.tiltsize)
                            {
                                _loc_9 = 0;
                            }
                            else
                            {
                                _loc_9 = _loc_9 - _loc_2.tiltsize;
                            }
                            _loc_13 = 1 - _loc_9 / _loc_10;
                            if (Math.abs(_loc_8) > _loc_10 || _loc_13 < 0)
                            {
                                _loc_6 = _loc_12 * _loc_11;
                                _loc_2.transform.leftToLeft = _loc_6;
                                _loc_2.transform.rightToRight = _loc_6;
                                _loc_2.transform.leftToRight = 0;
                                _loc_2.transform.rightToLeft = 0;
                            }
                            else
                            {
                                _loc_4 = 1 - Math.abs(_loc_8 / _loc_10);
                                _loc_5 = _loc_12 * (_loc_11 + (1 - _loc_11) * _loc_13 * _loc_4);
                                _loc_6 = _loc_12 * _loc_11;
                                if (_loc_8 >= 0)
                                {
                                    _loc_2.transform.leftToLeft = _loc_5;
                                    _loc_2.transform.rightToRight = _loc_6;
                                }
                                else
                                {
                                    _loc_2.transform.rightToRight = _loc_5;
                                    _loc_2.transform.leftToLeft = _loc_6;
                                }
                                if (Math.abs(_loc_8) * 2 < _loc_10)
                                {
                                    _loc_4 = 1 - Math.abs(2 * _loc_8) / _loc_10;
                                    _loc_5 = _loc_12 * (_loc_11 + (1 - _loc_11) * _loc_13 * _loc_4);
                                    _loc_6 = _loc_12 * ((1 - _loc_11) * 0.5 * _loc_13 * (1 - _loc_4));
                                    if (_loc_8 >= 0)
                                    {
                                        _loc_2.transform.rightToRight = _loc_5;
                                        _loc_2.transform.rightToLeft = _loc_6;
                                        _loc_2.transform.leftToRight = 0;
                                    }
                                    else
                                    {
                                        _loc_2.transform.leftToLeft = _loc_5;
                                        _loc_2.transform.leftToRight = _loc_6;
                                        _loc_2.transform.rightToLeft = 0;
                                    }
                                }
                                else
                                {
                                    _loc_4 = 1 - (Math.abs(2 * _loc_8) - _loc_10) / _loc_10;
                                    _loc_5 = _loc_12 * (0.5 * (1 - _loc_11) * _loc_13 * _loc_4);
                                    if (_loc_8 >= 0)
                                    {
                                        _loc_2.transform.rightToLeft = _loc_5;
                                        _loc_2.transform.leftToRight = 0;
                                    }
                                    else
                                    {
                                        _loc_2.transform.leftToRight = _loc_5;
                                        _loc_2.transform.rightToLeft = 0;
                                    }
                                }
                            }
                            _loc_2.setTransform(_loc_2.transform);
                        }
                    }
                    if (_loc_2.mode == 5)
                    {
                        if (_loc_2.transform != null)
                        {
                            _loc_7 = Math.acos(this.currentV.prod(_loc_2.v)) * 180 / Math.PI;
                            if (_loc_7 < _loc_2.pansize)
                            {
                                _loc_2.transform.leftToLeft = _loc_2.level;
                                _loc_2.transform.rightToRight = _loc_2.level;
                                _loc_2.transform.leftToRight = 0;
                                _loc_2.transform.rightToLeft = 0;
                            }
                            else if (_loc_7 < _loc_2.pansize + _loc_10)
                            {
                                if (_loc_8 < 0)
                                {
                                    _loc_8 = _loc_8 > -_loc_2.pansize ? (0) : (_loc_8 + _loc_2.pansize);
                                }
                                else
                                {
                                    _loc_8 = _loc_8 < _loc_2.pansize ? (0) : (_loc_8 - _loc_2.pansize);
                                }
                                _loc_5 = 1 - Math.max(_loc_7 - _loc_2.pansize, 0) / _loc_10;
                                _loc_6 = Math.max(1 - Math.abs(_loc_8) * Math.cos(_loc_2.tilt * Math.PI / 180) / _loc_10, 0);
                                if (this.viewer.debugText)
                                {
                                    this.viewer.debugText.htmlText = _loc_5 + "," + _loc_6 + " : " + _loc_8;
                                }
                                if (_loc_8 > 0)
                                {
                                    _loc_2.transform.leftToLeft = _loc_2.level * (_loc_5 * (1 - _loc_2.ambientlevel) + _loc_2.ambientlevel);
                                    _loc_2.transform.rightToRight = _loc_2.level * (_loc_5 * _loc_6 * (1 - _loc_2.ambientlevel) + _loc_2.ambientlevel);
                                    _loc_2.transform.leftToRight = 0;
                                    _loc_2.transform.rightToLeft = _loc_2.level * _loc_5 * (1 - _loc_6);
                                }
                                else
                                {
                                    _loc_2.transform.leftToLeft = _loc_2.level * (_loc_5 * _loc_6 * (1 - _loc_2.ambientlevel) + _loc_2.ambientlevel);
                                    _loc_2.transform.rightToRight = _loc_2.level * (_loc_5 * (1 - _loc_2.ambientlevel) + _loc_2.ambientlevel);
                                    _loc_2.transform.leftToRight = _loc_2.level * _loc_5 * (1 - _loc_6);
                                    _loc_2.transform.rightToLeft = 0;
                                }
                            }
                            else
                            {
                                _loc_5 = _loc_2.level * _loc_2.ambientlevel;
                                _loc_2.transform.leftToLeft = _loc_5;
                                _loc_2.transform.rightToRight = _loc_5;
                                _loc_2.transform.leftToRight = 0;
                                _loc_2.transform.rightToLeft = 0;
                            }
                            _loc_2.setTransform(_loc_2.transform);
                        }
                    }
                    if (_loc_2.mode == 4)
                    {
                        if (!_loc_2.triggered)
                        {
                            if (Math.abs(_loc_8) < _loc_2.pansize && Math.abs(_loc_9) < _loc_2.tiltsize)
                            {
                                if (!_loc_2.isInEffect)
                                {
                                    _loc_2.trigger();
                                }
                                _loc_2.isInEffect = true;
                            }
                            else
                            {
                                _loc_2.isInEffect = false;
                                _loc_2.triggered = false;
                            }
                        }
                    }
                    if (_loc_2.mode == 6)
                    {
                        if (!_loc_2.triggered)
                        {
                            _loc_7 = Math.acos(this.currentV.prod(_loc_2.v)) * 180 / Math.PI;
                            if (Math.abs(_loc_7) < _loc_2.pansize)
                            {
                                if (!_loc_2.isInEffect)
                                {
                                    _loc_2.trigger();
                                }
                                _loc_2.isInEffect = true;
                            }
                            else
                            {
                                _loc_2.isInEffect = false;
                                _loc_2.triggered = false;
                            }
                        }
                    }
                }
                _loc_3++;
            }
            return;
        }// end function

        public function checkLoad() : void
        {
            var i:int;
            var snd:GgSound;
            var repId:String;
            var complete:Boolean;
            i;
            while (i < this.items.length)
            {
                
                snd = this.items[i];
                try
                {
                    if (snd.sound == null)
                    {
                        repId = "media_" + this.viewer.currentNodeId + snd.id;
                        snd.sound = this.getSoundRepos(repId);
                        if (snd.sound.bytesLoaded < 1 && this.viewer.currentNodeId.length > 0)
                        {
                            repId = "media_" + snd.id;
                            snd.sound = this.getSoundRepos(repId);
                        }
                        if (snd.sound.bytesLoaded < 1)
                        {
                            snd.sound = null;
                        }
                    }
                    if (!snd.isLoaded)
                    {
                        if (snd.sound != null && snd.sound.bytesLoaded > 1)
                        {
                            if (snd.mode == 1 || snd.mode == 2 || snd.mode == 3 || snd.mode == 5)
                            {
                                snd.transform = new SoundTransform(snd.level);
                                if (!snd.isStopped)
                                {
                                    if (snd.loop == 0)
                                    {
                                        snd.channel = snd.sound.play(0, 0, snd.transform);
                                        snd.channel.addEventListener(Event.SOUND_COMPLETE, snd.soundCompleteRepeatHandler);
                                        snd.triggered = true;
                                    }
                                    else if (snd.loop > 0)
                                    {
                                        snd.channel = snd.sound.play(0, snd.loop, snd.transform);
                                        snd.channel.addEventListener(Event.SOUND_COMPLETE, snd.soundCompleteClearHandler);
                                        snd.triggered = true;
                                    }
                                }
                            }
                            snd.isLoaded = true;
                        }
                        else
                        {
                            complete;
                        }
                    }
                }
                catch (error:Error)
                {
                    complete;
                    snd.sound = null;
                }
                i = (i + 1);
            }
            this.loadingComplete = complete;
            return;
        }// end function

        public function findSound(param1:String) : GgSound
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            _loc_3 = 0;
            while (_loc_3 < this.items.length)
            {
                
                _loc_2 = this.items[_loc_3];
                if (_loc_2.id == param1)
                {
                    return _loc_2;
                }
                _loc_3++;
            }
            return null;
        }// end function

        public function findSounds(param1:String) : Array
        {
            var _loc_2:* = null;
            var _loc_4:* = null;
            var _loc_5:* = false;
            var _loc_6:* = null;
            var _loc_3:* = new Array();
            if (param1.charAt(0) == "#")
            {
                _loc_4 = param1.substr(1);
                _loc_6 = new RegExp(_loc_4);
                _loc_5 = false;
            }
            else if (param1.charAt(0) == "%")
            {
                _loc_6 = param1.substr(1);
                _loc_5 = false;
            }
            else
            {
                _loc_6 = param1;
                _loc_5 = true;
            }
            for each (_loc_2 in this.items)
            {
                
                if (_loc_2.id != "" && _loc_2.id.match(_loc_6) != null)
                {
                    _loc_3.push(_loc_2);
                    if (_loc_5)
                    {
                        return _loc_3;
                    }
                }
            }
            return _loc_3;
        }// end function

        public function trigger(param1:String) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            _loc_3 = this.findSounds(param1);
            for each (_loc_2 in _loc_3)
            {
                
                if (_loc_2 != null && !_loc_2.triggered)
                {
                    _loc_2.trigger();
                }
            }
            if (param1 == "_main" || param1 == "")
            {
                _loc_4 = 0;
                while (_loc_4 < this.items.length)
                {
                    
                    _loc_2 = this.items[_loc_4];
                    if (_loc_2.keep == false && (_loc_2.mode == 1 || _loc_2.mode == 2 || _loc_2.mode == 3 || _loc_2.mode == 5))
                    {
                        _loc_2.trigger();
                    }
                    _loc_4++;
                }
            }
            return;
        }// end function

        public function stop(param1:String) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            _loc_3 = this.findSounds(param1);
            for each (_loc_2 in _loc_3)
            {
                
                _loc_2.stop();
            }
            if (param1 == "_main" || param1 == "")
            {
                _loc_4 = 0;
                while (_loc_4 < this.items.length)
                {
                    
                    _loc_2 = this.items[_loc_4];
                    _loc_2.stop();
                    _loc_4++;
                }
                SoundMixer.stopAll();
            }
            return;
        }// end function

        public function pause(param1:String) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            _loc_3 = this.findSounds(param1);
            for each (_loc_2 in _loc_3)
            {
                
                _loc_2.pause();
            }
            return;
        }// end function

        public function changeVolume(param1:String, param2:Number) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = NaN;
            _loc_4 = this.findSounds(param1);
            for each (_loc_3 in _loc_4)
            {
                
                _loc_5 = _loc_3.level;
                _loc_5 = _loc_5 + param2;
                if (_loc_5 < 0)
                {
                    _loc_5 = 0;
                }
                if (_loc_5 > 1)
                {
                    _loc_5 = 1;
                }
                _loc_3.level = _loc_5;
                if (_loc_3.mode == 0 || _loc_3.mode == 1 || _loc_3.mode == 4 || _loc_3.mode == 6)
                {
                    _loc_3.setTransform(new SoundTransform(_loc_5));
                }
            }
            if (param1 == "_main" || param1 == "")
            {
                this.mainVolume = this.mainVolume + param2;
                if (this.mainVolume < 0)
                {
                    this.mainVolume = 0;
                }
                if (this.mainVolume > 1)
                {
                    this.mainVolume = 1;
                }
                SoundMixer.soundTransform = new SoundTransform(this.mainVolume);
            }
            return;
        }// end function

        public function setVolume(param1:String, param2:Number) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            _loc_4 = this.findSounds(param1);
            for each (_loc_3 in _loc_4)
            {
                
                _loc_3.level = param2;
                if (_loc_3.mode == 0 || _loc_3.mode == 1 || _loc_3.mode == 4 || _loc_3.mode == 6)
                {
                    _loc_3.setTransform(new SoundTransform(param2));
                }
            }
            if (param1 == "_main" || param1 == "")
            {
                this.mainVolume = param2;
                if (this.mainVolume < 0)
                {
                    this.mainVolume = 0;
                }
                if (this.mainVolume > 1)
                {
                    this.mainVolume = 1;
                }
                SoundMixer.soundTransform = new SoundTransform(this.mainVolume);
            }
            return;
        }// end function

        public function removeDirectional() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            var _loc_3:* = null;
            _loc_3 = new Array();
            if (this.viewer.debugText)
            {
                this.viewer.debugText.htmlText = this.viewer.debugText.htmlText + "remove dir";
            }
            _loc_2 = this.items.length - 1;
            while (_loc_2 >= 0)
            {
                
                _loc_1 = this.items[_loc_2];
                if (this.viewer.debugText)
                {
                    this.viewer.debugText.htmlText = this.viewer.debugText.htmlText + ("," + _loc_1.id);
                }
                if ((_loc_1.mode == 0 || _loc_1.mode == 1 || _loc_1.keep) && _loc_1.isVideo == false)
                {
                    _loc_3.push(_loc_1);
                    if (this.viewer.debugText)
                    {
                        this.viewer.debugText.htmlText = this.viewer.debugText.htmlText + " (keep)";
                    }
                }
                else
                {
                    _loc_1.stop();
                    _loc_1.remove();
                    if (this.viewer.debugText)
                    {
                        this.viewer.debugText.htmlText = this.viewer.debugText.htmlText + " (x)";
                    }
                }
                _loc_2 = _loc_2 - 1;
            }
            this.items = _loc_3;
            if (this.viewer.debugText)
            {
                this.viewer.debugText.htmlText = this.viewer.debugText.htmlText + "done";
            }
            return;
        }// end function

        public function removeAll() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            if (this.viewer.debugText)
            {
                this.viewer.debugText.htmlText = this.viewer.debugText.htmlText + "remove all";
            }
            _loc_2 = this.items.length - 1;
            while (_loc_2 >= 0)
            {
                
                _loc_1 = this.items[_loc_2];
                _loc_1.stop();
                _loc_1.remove();
                _loc_2 = _loc_2 - 1;
            }
            this.items = new Array();
            return;
        }// end function

        public function addSound(param1:GgSound) : void
        {
            var _loc_2:* = null;
            _loc_2 = this.findSound(param1.id);
            if (_loc_2)
            {
                if (!_loc_2.keep && (param1.url != _loc_2.url || param1.hash != _loc_2.hash))
                {
                    this.items[this.items.indexOf(_loc_2)] = param1;
                    param1.isStopped = _loc_2.isStopped;
                    param1.level = _loc_2.level;
                    _loc_2.stop();
                    if (this.viewer.debugText)
                    {
                        this.viewer.debugText.htmlText = this.viewer.debugText.htmlText + ("repl " + param1.id);
                    }
                }
            }
            else
            {
                this.items.push(param1);
                if (this.viewer.debugText)
                {
                    this.viewer.debugText.htmlText = this.viewer.debugText.htmlText + ("+ " + param1.id);
                }
            }
            this.loadingComplete = false;
            return;
        }// end function

    }
}
