package 
{
    import Hotspots.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;

    public class Hotspots extends Object
    {
        public var qthotspots:Array;
        public var hotspots:Array;
        public var viewer:GgViewer;
        public var currentHotspot:Hotspot;
        public var currentHotspotId:int;
        public var onAddHotspot:Function;
        public var onUnloadHotspots:Function;
        public var onClickHotspot:Function;
        public var onRollOverHotspot:Function;
        public var onRollOutHotspot:Function;
        public var onClickQtHotspot:Function;
        public var onRollOverQtHotspot:Function;
        public var onRollOutQtHotspot:Function;
        public var onClickSkinHotspot:Function;
        public var onRollOverSkinHotspot:Function;
        public var onRollOutSkinHotspot:Function;
        public var hotspot_txt:GgTextField;
        public var hotspottxtEnabled:Boolean = true;
        public var hotspottxtWidth:Number = 100;
        public var hotspottxtHeight:Number = 0;
        public var hotspottxtTextColor:uint = 0;
        public var hotspottxtBorderColor:uint = 0;
        public var hotspottxtBackgroundColor:uint = 16777215;
        public var hotspottxtTextAlpha:Number = 1;
        public var hotspottxtBorderAlpha:Number = 1;
        public var hotspottxtBackgroundAlpha:Number = 1;
        public var hotspottxtBorder:Boolean = true;
        public var hotspottxtBorderWidth:int = 1;
        public var hotspottxtBorderRadius:int = 0;
        public var hotspottxtBackground:Boolean = true;
        public var hotspottxtContinous:Boolean = true;
        public var hotspotWordWrap:Boolean = true;
        public var polyMode:int = 0;
        public var polyBackgroundColor:uint = 16711680;
        public var polyBackgroundAlpha:Number = 0.5;
        public var polyBorderColor:uint = 16711680;
        public var polyBorderAlpha:Number = 0.5;
        public var polyBorderWidth:int = 1;
        public var blendSpeed:Number = 0.05;

        public function Hotspots()
        {
            this.hotspots = new Array();
            this.qthotspots = new Array();
            this.hotspottxtWidth = 200;
            this.hotspottxtHeight = 20;
            return;
        }// end function

        protected function doClickHotspot(event:Event) : void
        {
            var i:int;
            var chs:Hotspot;
            var e:* = event;
            var hs:* = Sprite(e.currentTarget);
            i;
            while (i < this.hotspots.length)
            {
                
                chs = this.hotspots[i];
                if (chs.clip == hs)
                {
                    this.currentHotspot = chs;
                    if (this.onClickSkinHotspot != null)
                    {
                        try
                        {
                            this.onClickSkinHotspot(chs.id);
                        }
                        catch (error:Error)
                        {
                        }
                    }
                    if (this.onClickHotspot != null)
                    {
                        try
                        {
                            this.onClickHotspot(chs.id, chs.clip, chs.url, chs.target);
                        }
                        catch (error:Error)
                        {
                        }
                    }
                }
                i = (i + 1);
            }
            return;
        }// end function

        protected function doClickHotspotFollowUrl(event:Event) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_2:* = Sprite(event.currentTarget);
            _loc_3 = 0;
            while (_loc_3 < this.hotspots.length)
            {
                
                _loc_4 = this.hotspots[_loc_3];
                if (_loc_4.clip == _loc_2)
                {
                    this.currentHotspot = _loc_4;
                    if (this.onClickHotspot == null)
                    {
                        this.viewer.openUrl(_loc_4.url, _loc_4.target);
                    }
                }
                _loc_3++;
            }
            return;
        }// end function

        protected function doRollOverHotspot(event:Event) : void
        {
            var i:int;
            var hsm:MovieClip;
            var e:* = event;
            var hs:* = Sprite(e.currentTarget);
            i;
            while (i < this.hotspots.length)
            {
                
                if (this.hotspots[i].clip == hs)
                {
                    this.currentHotspot = this.hotspots[i];
                    if (this.onRollOverSkinHotspot != null)
                    {
                        try
                        {
                            this.onRollOverSkinHotspot(this.hotspots[i].id);
                        }
                        catch (error:Error)
                        {
                        }
                    }
                    if (this.onRollOverHotspot != null)
                    {
                        try
                        {
                            this.onRollOverHotspot(this.hotspots[i].id, this.hotspots[i].clip);
                        }
                        catch (error:Error)
                        {
                        }
                    }
                    else
                    {
                        hsm = hs as MovieClip;
                        if (hsm != null && hsm.hasOwnProperty("hstext"))
                        {
                            hsm.hstext.visible = this.hotspottxtEnabled && hsm.hstext.htmlText.length > 0;
                        }
                    }
                }
                i = (i + 1);
            }
            return;
        }// end function

        protected function doRollOutHotspot(event:Event) : void
        {
            var i:int;
            var hsm:MovieClip;
            var e:* = event;
            var hs:* = Sprite(e.currentTarget);
            i;
            while (i < this.hotspots.length)
            {
                
                if (this.hotspots[i].clip == hs)
                {
                    if (this.onRollOutSkinHotspot != null)
                    {
                        try
                        {
                            this.onRollOutSkinHotspot(this.hotspots[i].id);
                        }
                        catch (error:Error)
                        {
                        }
                    }
                    if (this.onRollOutHotspot != null)
                    {
                        try
                        {
                            this.onRollOutHotspot(this.hotspots[i].id, this.hotspots[i].clip);
                        }
                        catch (error:Error)
                        {
                        }
                    }
                    else
                    {
                        hsm = hs as MovieClip;
                        if (hsm != null && hsm.hasOwnProperty("hstext"))
                        {
                            hsm.hstext.visible = false;
                        }
                    }
                }
                i = (i + 1);
            }
            this.currentHotspot = null;
            return;
        }// end function

        public function addQtHotspot(param1:Number, param2:String, param3:String, param4:String) : void
        {
            var _loc_5:* = new Hotspot();
            _loc_5.id = "" + param1;
            _loc_5.url = param3;
            _loc_5.title = param2;
            _loc_5.target = param4;
            _loc_5.posPan = 0;
            _loc_5.posTilt = 0;
            _loc_5.ofs.x = 0;
            _loc_5.ofs.y = 0;
            _loc_5.isArea = true;
            this.qthotspots[param1] = _loc_5;
            return;
        }// end function

        public function addHotspot(param1:String, param2:Number, param3:Number, param4:Sprite, param5:String = "", param6:String = "") : Hotspot
        {
            var _loc_7:* = new Hotspot();
            _loc_7.id = param1;
            _loc_7.posPan = param2;
            _loc_7.posTilt = param3;
            _loc_7.clip = param4;
            _loc_7.url = param5;
            _loc_7.target = param6;
            _loc_7.ofs.x = 0;
            _loc_7.ofs.y = 0;
            _loc_7.isArea = false;
            param4.visible = false;
            if (this.viewer.enable_callback)
            {
                param4.addEventListener(MouseEvent.CLICK, this.doClickHotspot);
                param4.addEventListener(MouseEvent.MOUSE_OVER, this.doRollOverHotspot);
                param4.addEventListener(MouseEvent.MOUSE_OUT, this.doRollOutHotspot);
            }
            this.viewer.hsClip.addChild(param4);
            this.hotspots.push(_loc_7);
            return _loc_7;
        }// end function

        public function addUrlHotspot(param1:String, param2:Number, param3:Number, param4:String, param5:String, param6:String, param7:Number = 0, param8:Number = 0) : Hotspot
        {
            var _loc_9:* = new UrlHotspotClass();
            _loc_9.hstext.htmlText = param4;
            if (param8 > 0 && param7 > 0)
            {
                _loc_9.hstext.tf.autoSize = TextFieldAutoSize.NONE;
                _loc_9.hstext.x = _loc_9.hstext.x + (_loc_9.hstext.width - param7) / 2;
                _loc_9.hstext.textWidth = param7;
                _loc_9.hstext.textHeight = param8;
            }
            else
            {
                _loc_9.hstext.tf.autoSize = TextFieldAutoSize.CENTER;
                if (param7 > 0)
                {
                    _loc_9.hstext.textWidth = param7;
                    _loc_9.hstext.x = (-param7) / 2;
                }
            }
            _loc_9.buttonMode = true;
            _loc_9.hstext.visible = false;
            _loc_9.hstext.tf.wordWrap = this.hotspotWordWrap;
            _loc_9.hstext.backgroundColor = this.hotspottxtBackgroundColor;
            _loc_9.hstext.backgroundAlpha = this.hotspottxtBackgroundAlpha;
            _loc_9.hstext.background = this.hotspottxtBackgroundAlpha > 0;
            _loc_9.hstext.borderColor = this.hotspottxtBorderColor;
            _loc_9.hstext.borderAlpha = this.hotspottxtBorderAlpha;
            _loc_9.hstext.radius = this.hotspottxtBorderRadius;
            _loc_9.hstext.borderWidth = this.hotspottxtBorderWidth;
            _loc_9.hstext.tf.textColor = this.hotspottxtTextColor;
            _loc_9.hstext.tf.alpha = this.hotspottxtTextAlpha;
            _loc_9.hstext.tf.selectable = false;
            var _loc_10:* = this.addHotspot(param1, param2, param3, _loc_9, param5, param6);
            _loc_10.title = param4;
            _loc_9.addEventListener(MouseEvent.CLICK, this.doClickHotspotFollowUrl);
            return _loc_10;
        }// end function

        public function addTextHotspot(param1:String, param2:Number, param3:Number, param4:String, param5:Number = 0, param6:Number = 0) : Hotspot
        {
            var _loc_7:* = new UrlHotspotClass();
            _loc_7.hstext.htmlText = param4;
            _loc_7.hstext.visible = param4.length > 0;
            if (param6 > 0 && param5 > 0)
            {
                _loc_7.hstext.tf.autoSize = TextFieldAutoSize.NONE;
                _loc_7.hstext.x = _loc_7.hstext.x + (_loc_7.hstext.width - param5) / 2;
                _loc_7.hstext.textWidth = param5;
                _loc_7.hstext.textHeight = param6;
            }
            else
            {
                _loc_7.hstext.tf.autoSize = TextFieldAutoSize.CENTER;
                if (param5 > 0)
                {
                    _loc_7.hstext.textWidth = param5;
                    _loc_7.hstext.x = (-param5) / 2;
                }
            }
            _loc_7.hstext.visible = false;
            _loc_7.useHandCursor = false;
            _loc_7.hstext.tf.wordWrap = this.hotspotWordWrap;
            _loc_7.hstext.backgroundColor = this.hotspottxtBackgroundColor;
            _loc_7.hstext.backgroundAlpha = this.hotspottxtBackgroundAlpha;
            _loc_7.hstext.background = this.hotspottxtBackgroundAlpha > 0;
            _loc_7.hstext.borderColor = this.hotspottxtBorderColor;
            _loc_7.hstext.borderAlpha = this.hotspottxtBorderAlpha;
            _loc_7.hstext.radius = this.hotspottxtBorderRadius;
            _loc_7.hstext.borderWidth = this.hotspottxtBorderWidth;
            _loc_7.hstext.tf.textColor = this.hotspottxtTextColor;
            _loc_7.hstext.tf.alpha = this.hotspottxtTextAlpha;
            _loc_7.hstext.tf.selectable = false;
            var _loc_8:* = this.addHotspot(param1, param2, param3, _loc_7);
            _loc_8.title = param4;
            return _loc_8;
        }// end function

        public function unloadHotspots() : void
        {
            var _loc_1:* = NaN;
            var _loc_2:* = null;
            _loc_1 = 0;
            while (_loc_1 < this.hotspots.length)
            {
                
                _loc_2 = this.hotspots[_loc_1];
                try
                {
                    this.viewer.hsClip.removeChild(_loc_2.clip);
                }
                catch (e:Error)
                {
                }
                _loc_1 = _loc_1 + 1;
            }
            if (this.onUnloadHotspots != null)
            {
                this.onUnloadHotspots();
            }
            this.hotspots = new Array();
            this.qthotspots = new Array();
            return;
        }// end function

        public function addHotspotTextField() : GgTextField
        {
            this.hotspot_txt = new GgTextField();
            var _loc_1:* = new TextFormat();
            _loc_1.font = "Verdana";
            _loc_1.size = 12;
            _loc_1.color = 0;
            _loc_1.align = TextFormatAlign.CENTER;
            this.hotspot_txt.tf.defaultTextFormat = _loc_1;
            this.hotspot_txt.tf.selectable = false;
            this.hotspot_txt.tf.borderColor = 0;
            this.hotspot_txt.tf.backgroundColor = 16777215;
            this.hotspot_txt.tf.type = TextFieldType.DYNAMIC;
            this.hotspot_txt.tf.htmlText = "HS";
            this.hotspot_txt.tf.alpha = 70;
            this.hotspot_txt.tf.border = true;
            this.hotspot_txt.tf.background = true;
            this.hotspot_txt.tf.multiline = true;
            this.hotspot_txt.tf.wordWrap = true;
            this.hotspot_txt.visible = false;
            return this.hotspot_txt;
        }// end function

        public function changeCurrentQtHotspot(param1:int, param2:int, param3:int) : void
        {
            var _loc_4:* = null;
            if (param1 > 0 && this.viewer.isInFocus)
            {
                _loc_4 = this.qthotspots[param1];
                this.changeCurrentHotspot(_loc_4, param2, param3);
                this.currentHotspotId = param1;
            }
            else
            {
                this.changeCurrentHotspot(null, param2, param3);
                this.currentHotspotId = 0;
            }
            return;
        }// end function

        public function changeCurrentHotspot(param1:Hotspot, param2:int, param3:int) : void
        {
            var npx:Number;
            var npy:Number;
            var hs:* = param1;
            var x:* = param2;
            var y:* = param3;
            if (this.currentHotspot != hs)
            {
                this.viewer.update();
                if (this.currentHotspot != null)
                {
                    if (this.onRollOutQtHotspot != null)
                    {
                        try
                        {
                            this.onRollOutQtHotspot(this.currentHotspot.id, this.currentHotspot.title, this.currentHotspot.url, this.currentHotspot.target);
                        }
                        catch (error:Error)
                        {
                        }
                    }
                    if (this.onRollOutSkinHotspot != null)
                    {
                        try
                        {
                            this.onRollOutSkinHotspot(this.currentHotspot.id);
                        }
                        catch (error:Error)
                        {
                        }
                    }
                }
                if (hs != null && this.hotspottxtEnabled)
                {
                    if (this.hotspottxtHeight > 0)
                    {
                        this.hotspot_txt.tf.autoSize = TextFieldAutoSize.NONE;
                        this.hotspot_txt.textWidth = this.hotspottxtWidth;
                        this.hotspot_txt.textHeight = this.hotspottxtHeight;
                    }
                    else
                    {
                        this.hotspot_txt.textWidth = this.hotspottxtWidth;
                        this.hotspot_txt.tf.autoSize = TextFieldAutoSize.CENTER;
                    }
                    this.hotspot_txt.tf.wordWrap = this.hotspotWordWrap;
                    this.hotspot_txt.htmlText = hs.title;
                    this.hotspot_txt.visible = hs.title.length > 0;
                    this.hotspot_txt.backgroundColor = this.hotspottxtBackgroundColor;
                    this.hotspot_txt.backgroundAlpha = this.hotspottxtBackgroundAlpha;
                    this.hotspot_txt.background = this.hotspottxtBackgroundAlpha > 0 && this.hotspottxtBackground;
                    this.hotspot_txt.borderColor = this.hotspottxtBorderColor;
                    this.hotspot_txt.borderAlpha = this.hotspottxtBorderAlpha;
                    this.hotspot_txt.radius = this.hotspottxtBorderRadius;
                    if (this.hotspottxtBorder)
                    {
                        this.hotspot_txt.borderWidth = this.hotspottxtBorderWidth;
                    }
                    else
                    {
                        this.hotspot_txt.borderWidth = 0;
                    }
                    this.hotspot_txt.tf.textColor = this.hotspottxtTextColor;
                    this.hotspot_txt.tf.alpha = this.hotspottxtTextAlpha;
                    this.hotspot_txt.tf.selectable = false;
                }
                else
                {
                    this.hotspot_txt.visible = false;
                }
                this.currentHotspot = hs;
                if (this.currentHotspot != null)
                {
                    if (this.onRollOverQtHotspot != null)
                    {
                        try
                        {
                            this.onRollOverQtHotspot(this.currentHotspot.id, this.currentHotspot.title, this.currentHotspot.url, this.currentHotspot.target);
                        }
                        catch (error:Error)
                        {
                        }
                    }
                    if (this.onRollOverSkinHotspot != null)
                    {
                        try
                        {
                            this.onRollOverSkinHotspot(this.currentHotspot.id);
                        }
                        catch (error:Error)
                        {
                        }
                    }
                }
            }
            if (this.currentHotspot != null)
            {
                npx = hs.ofs.x + x - this.hotspot_txt.width / 2;
                npy = hs.ofs.y + y + 20;
                if (this.hotspottxtContinous || Math.abs(this.hotspot_txt.x - npx) > this.hotspot_txt.width / 2 || Math.abs(this.hotspot_txt.y - npy) - 25 > this.hotspot_txt.height)
                {
                    this.hotspot_txt.x = npx;
                    this.hotspot_txt.y = npy;
                }
            }
            this.viewer.redrawCursor(null);
            return;
        }// end function

        public function updateHotspots(param1:Matrix4d, param2:Number) : void
        {
            var _loc_3:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = NaN;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_4:* = new GgVector3d();
            _loc_3 = 0;
            while (_loc_3 < this.hotspots.length)
            {
                
                _loc_6 = this.hotspots[_loc_3];
                if (_loc_6.clip)
                {
                    _loc_4.init(0, 0, -1);
                    _loc_4.rotx(_loc_6.posTilt * Math.PI / 180);
                    _loc_4.roty((-_loc_6.posPan) * Math.PI / 180);
                    _loc_5 = new GgVector3d();
                    param1.mulVector(_loc_4, _loc_5);
                    _loc_5.project(param2, this.viewer.rect.width / 2, this.viewer.rect.height / 2);
                    if (_loc_6.clip.hasOwnProperty("distort") && _loc_6.clip.hasOwnProperty("distortDistance") && _loc_6.clip["distort"])
                    {
                        _loc_7 = new Matrix3D();
                        _loc_8 = _loc_6.clip["distortDistance"];
                        if (_loc_8 <= 0)
                        {
                            _loc_8 = 500;
                        }
                        _loc_6.clip.x = 0;
                        _loc_6.clip.y = 0;
                        _loc_6.clip.visible = true;
                        _loc_6.position.x = 0;
                        _loc_6.position.y = 0;
                        _loc_7.appendTranslation(0, 0, _loc_8);
                        _loc_7.appendRotation(_loc_6.posTilt, new Vector3D(1, 0, 0));
                        _loc_7.appendRotation(-_loc_6.posPan, new Vector3D(0, 1, 0));
                        _loc_7.appendRotation(this.viewer.getPan(), new Vector3D(0, 1, 0));
                        _loc_7.appendRotation(-this.viewer.getTilt(), new Vector3D(1, 0, 0));
                        _loc_7.appendTranslation(0, 0, -param2);
                        _loc_7.appendTranslation(this.viewer.rect.width / 2, this.viewer.rect.height / 2, 0);
                        _loc_6.clip.transform.matrix3D = _loc_7;
                    }
                    else
                    {
                        _loc_6.clip.visible = _loc_5.pz < 0;
                        _loc_6.clip.x = _loc_6.ofs.x + _loc_5.px;
                        _loc_6.clip.y = _loc_6.ofs.y + _loc_5.py;
                        _loc_6.position.x = _loc_5.px;
                        _loc_6.position.y = _loc_5.py;
                    }
                }
                if (_loc_6.polygon)
                {
                    _loc_10 = new Array();
                    for each (_loc_9 in _loc_6.polygon)
                    {
                        
                        _loc_4.fromPanTilt(_loc_9.pan, -_loc_9.tilt);
                        _loc_5 = new GgVector3d();
                        param1.mulVector(_loc_4, _loc_5);
                        _loc_5.project(param2, this.viewer.rect.width / 2, this.viewer.rect.height / 2);
                        _loc_10.push(_loc_5);
                    }
                    _loc_6.outline = _loc_10;
                }
                _loc_3++;
            }
            return;
        }// end function

        public function configHotspot(param1:XML) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = NaN;
            var _loc_10:* = NaN;
            var _loc_11:* = null;
            var _loc_12:* = null;
            var _loc_13:* = 0;
            var _loc_14:* = 0;
            var _loc_15:* = null;
            var _loc_16:* = null;
            var _loc_17:* = null;
            var _loc_18:* = null;
            var _loc_19:* = null;
            var _loc_20:* = null;
            var _loc_21:* = null;
            var _loc_22:* = null;
            var _loc_23:* = null;
            var _loc_24:* = null;
            var _loc_25:* = null;
            var _loc_26:* = null;
            var _loc_27:* = null;
            if (param1.hasOwnProperty("hotspots"))
            {
                if (param1.hotspots.hasOwnProperty("label"))
                {
                    if (param1.hotspots.label.hasOwnProperty("@enabled"))
                    {
                        this.hotspottxtEnabled = param1.hotspots.label.@enabled == 1;
                    }
                    if (param1.hotspots.label.hasOwnProperty("@width"))
                    {
                        this.hotspottxtWidth = param1.hotspots.label.@width;
                    }
                    if (param1.hotspots.label.hasOwnProperty("@height"))
                    {
                        this.hotspottxtHeight = param1.hotspots.label.@height;
                    }
                    if (param1.hotspots.label.hasOwnProperty("@movement"))
                    {
                        this.hotspottxtContinous = param1.hotspots.label.@movement == 1;
                    }
                    if (param1.hotspots.label.hasOwnProperty("@border"))
                    {
                        this.hotspottxtBorder = param1.hotspots.label.@border == 1;
                    }
                    if (param1.hotspots.label.hasOwnProperty("@borderwidth"))
                    {
                        this.hotspottxtBorderWidth = param1.hotspots.label.@borderwidth;
                    }
                    if (param1.hotspots.label.hasOwnProperty("@borderradius"))
                    {
                        this.hotspottxtBorderRadius = param1.hotspots.label.@borderradius;
                    }
                    if (param1.hotspots.label.hasOwnProperty("@background"))
                    {
                        this.hotspottxtBackground = param1.hotspots.label.@background == 1;
                    }
                    if (param1.hotspots.label.hasOwnProperty("@bordercolor"))
                    {
                        this.hotspottxtBorderColor = param1.hotspots.label.@bordercolor;
                    }
                    if (param1.hotspots.label.hasOwnProperty("@backgroundcolor"))
                    {
                        this.hotspottxtBackgroundColor = param1.hotspots.label.@backgroundcolor;
                    }
                    if (param1.hotspots.label.hasOwnProperty("@textcolor"))
                    {
                        this.hotspottxtTextColor = param1.hotspots.label.@textcolor;
                    }
                    if (param1.hotspots.label.hasOwnProperty("@borderalpha"))
                    {
                        this.hotspottxtBorderAlpha = param1.hotspots.label.@borderalpha;
                    }
                    if (param1.hotspots.label.hasOwnProperty("@backgroundalpha"))
                    {
                        this.hotspottxtBackgroundAlpha = param1.hotspots.label.@backgroundalpha;
                    }
                    if (param1.hotspots.label.hasOwnProperty("@textalpha"))
                    {
                        this.hotspottxtTextAlpha = param1.hotspots.label.@textalpha;
                    }
                    if (param1.hotspots.label.hasOwnProperty("@wordwrap"))
                    {
                        this.hotspotWordWrap = param1.hotspots.label.@wordwrap == 1;
                    }
                }
                for each (_loc_2 in param1.hotspots.hotspot)
                {
                    
                    _loc_4 = "";
                    _loc_5 = "";
                    _loc_7 = "";
                    _loc_8 = "";
                    _loc_6 = "";
                    if (_loc_2.hasOwnProperty("@id"))
                    {
                        _loc_5 = _loc_2.@id;
                    }
                    if (_loc_2.hasOwnProperty("@skinid"))
                    {
                        _loc_4 = _loc_2.@skinid;
                    }
                    if (_loc_2.hasOwnProperty("@title"))
                    {
                        _loc_6 = _loc_2.@title;
                    }
                    if (_loc_2.hasOwnProperty("@url"))
                    {
                        _loc_7 = _loc_2.@url;
                    }
                    if (_loc_2.hasOwnProperty("@target"))
                    {
                        _loc_8 = _loc_2.@target;
                    }
                    _loc_9 = 0;
                    if (_loc_2.hasOwnProperty("@pan"))
                    {
                        _loc_9 = _loc_2.@pan;
                    }
                    _loc_10 = 0;
                    if (_loc_2.hasOwnProperty("@tilt"))
                    {
                        _loc_10 = _loc_2.@tilt;
                    }
                    _loc_13 = 0;
                    _loc_14 = 0;
                    _loc_13 = this.hotspottxtWidth;
                    _loc_14 = this.hotspottxtHeight;
                    if (_loc_2.hasOwnProperty("@width"))
                    {
                        _loc_13 = _loc_2.@width;
                    }
                    if (_loc_2.hasOwnProperty("@height"))
                    {
                        _loc_14 = _loc_2.@height;
                    }
                    if (_loc_2.hasOwnProperty("@wordwrap"))
                    {
                        this.hotspotWordWrap = _loc_2.@wordwrap == 1;
                    }
                    _loc_11 = null;
                    if (this.onAddHotspot != null)
                    {
                        _loc_11 = this.onAddHotspot(_loc_4, _loc_5, _loc_9, _loc_10, _loc_6, _loc_7, _loc_8, _loc_13, _loc_14);
                    }
                    if (_loc_11 == null)
                    {
                        if (_loc_7 == "")
                        {
                            _loc_11 = this.addTextHotspot(_loc_5, _loc_9, _loc_10, _loc_6, _loc_13, _loc_14);
                        }
                        else
                        {
                            _loc_11 = this.addUrlHotspot(_loc_5, _loc_9, _loc_10, _loc_6, _loc_7, _loc_8, _loc_13, _loc_14);
                        }
                    }
                    if (_loc_11 != null)
                    {
                        _loc_16 = new Array();
                        for each (_loc_15 in _loc_2.location)
                        {
                            
                            _loc_12 = new ObjHotspotLocation();
                            if (_loc_15.hasOwnProperty("@column"))
                            {
                                _loc_12.column = _loc_15.@column;
                            }
                            if (_loc_15.hasOwnProperty("@row"))
                            {
                                _loc_12.row = _loc_15.@row;
                            }
                            if (_loc_15.hasOwnProperty("@state"))
                            {
                                _loc_12.state = _loc_15.@state;
                            }
                            if (_loc_15.hasOwnProperty("@x"))
                            {
                                _loc_12.x = _loc_15.@x;
                            }
                            if (_loc_15.hasOwnProperty("@y"))
                            {
                                _loc_12.y = _loc_15.@y;
                            }
                            _loc_16.push(_loc_12);
                        }
                        _loc_11.objloc = _loc_16;
                    }
                }
                if (param1.hotspots.hasOwnProperty("polystyle"))
                {
                    if (param1.hotspots.polystyle.hasOwnProperty("@mode"))
                    {
                        this.polyMode = param1.hotspots.polystyle.@mode;
                    }
                    if (param1.hotspots.polystyle.hasOwnProperty("@bordercolor"))
                    {
                        this.polyBorderColor = param1.hotspots.polystyle.@bordercolor;
                    }
                    if (param1.hotspots.polystyle.hasOwnProperty("@backgroundcolor"))
                    {
                        this.polyBackgroundColor = param1.hotspots.polystyle.@backgroundcolor;
                    }
                    if (param1.hotspots.polystyle.hasOwnProperty("@borderalpha"))
                    {
                        this.polyBorderAlpha = param1.hotspots.polystyle.@borderalpha;
                    }
                    if (param1.hotspots.polystyle.hasOwnProperty("@backgroundalpha"))
                    {
                        this.polyBackgroundAlpha = param1.hotspots.polystyle.@backgroundalpha;
                    }
                }
                for each (_loc_2 in param1.hotspots.polyhotspot)
                {
                    
                    _loc_5 = "";
                    _loc_7 = "";
                    _loc_8 = "";
                    _loc_6 = "";
                    if (_loc_2.hasOwnProperty("@id"))
                    {
                        _loc_5 = _loc_2.@id;
                    }
                    if (_loc_2.hasOwnProperty("@title"))
                    {
                        _loc_6 = _loc_2.@title;
                    }
                    if (_loc_2.hasOwnProperty("@url"))
                    {
                        _loc_7 = _loc_2.@url;
                    }
                    if (_loc_2.hasOwnProperty("@target"))
                    {
                        _loc_8 = _loc_2.@target;
                    }
                    _loc_11 = new Hotspot();
                    _loc_11.id = _loc_5;
                    _loc_11.url = _loc_7;
                    _loc_11.target = _loc_8;
                    _loc_11.title = _loc_6;
                    _loc_11.ofs.x = 0;
                    _loc_11.ofs.y = 0;
                    _loc_11.isArea = true;
                    if (_loc_2.hasOwnProperty("@reuse"))
                    {
                        _loc_11.reuse = _loc_2.@reuse;
                    }
                    _loc_16 = new Array();
                    for each (_loc_3 in _loc_2.vertex)
                    {
                        
                        _loc_18 = new GgPanoVertex();
                        if (_loc_3.hasOwnProperty("@pan"))
                        {
                            _loc_18.pan = _loc_3.@pan;
                        }
                        if (_loc_3.hasOwnProperty("@tilt"))
                        {
                            _loc_18.tilt = _loc_3.@tilt;
                        }
                        _loc_16.push(_loc_18);
                    }
                    _loc_11.polygon = _loc_16;
                    _loc_16 = new Array();
                    for each (_loc_17 in _loc_2.polygon)
                    {
                        
                        _loc_12 = new ObjHotspotLocation();
                        if (_loc_17.hasOwnProperty("@column"))
                        {
                            _loc_12.column = _loc_17.@column;
                        }
                        if (_loc_17.hasOwnProperty("@row"))
                        {
                            _loc_12.row = _loc_17.@row;
                        }
                        if (_loc_17.hasOwnProperty("@state"))
                        {
                            _loc_12.state = _loc_17.@state;
                        }
                        if (_loc_17.hasOwnProperty("@vertices"))
                        {
                            _loc_19 = _loc_17.@vertices;
                            _loc_21 = new Array();
                            _loc_20 = _loc_19.split("|");
                            for each (_loc_22 in _loc_20)
                            {
                                
                                _loc_24 = new Array();
                                _loc_23 = _loc_22.split(";");
                                for each (_loc_25 in _loc_23)
                                {
                                    
                                    _loc_26 = _loc_25.split(",");
                                    if (_loc_26.length == 2)
                                    {
                                        _loc_27 = new Point(Number(_loc_26[0]), Number(_loc_26[1]));
                                        _loc_24.push(_loc_27);
                                    }
                                }
                                _loc_21.push(_loc_24);
                            }
                            _loc_12.polygons = _loc_21;
                        }
                        _loc_16.push(_loc_12);
                    }
                    _loc_11.objpolys = _loc_16;
                    _loc_11.borderColor = this.polyBorderColor;
                    _loc_11.borderAlpha = this.polyBorderAlpha;
                    _loc_11.backgroundColor = this.polyBackgroundColor;
                    _loc_11.backgroundAlpha = this.polyBackgroundAlpha;
                    if (_loc_2.hasOwnProperty("@bordercolor"))
                    {
                        _loc_11.borderColor = _loc_2.@bordercolor;
                    }
                    if (_loc_2.hasOwnProperty("@backgroundcolor"))
                    {
                        _loc_11.backgroundColor = _loc_2.@backgroundcolor;
                    }
                    if (_loc_2.hasOwnProperty("@borderalpha"))
                    {
                        _loc_11.borderAlpha = _loc_2.@borderalpha;
                    }
                    if (_loc_2.hasOwnProperty("@backgroundalpha"))
                    {
                        _loc_11.backgroundAlpha = _loc_2.@backgroundalpha;
                    }
                    this.hotspots.push(_loc_11);
                }
            }
            return;
        }// end function

        public function configQtHotspot(param1:XML) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            if (param1.qthotspots.hasOwnProperty("label"))
            {
                if (param1.qthotspots.label.hasOwnProperty("@enabled"))
                {
                    this.hotspottxtEnabled = param1.qthotspots.label.@enabled == 1;
                }
                if (param1.qthotspots.label.hasOwnProperty("@width"))
                {
                    this.hotspottxtWidth = param1.qthotspots.label.@width;
                }
                if (param1.qthotspots.label.hasOwnProperty("@height"))
                {
                    this.hotspottxtHeight = param1.qthotspots.label.@height;
                }
                if (param1.qthotspots.label.hasOwnProperty("@movement"))
                {
                    this.hotspottxtContinous = param1.qthotspots.label.@movement == 1;
                }
                if (param1.qthotspots.label.hasOwnProperty("@border"))
                {
                    this.hotspottxtBorder = param1.qthotspots.label.@border == 1;
                }
                if (param1.qthotspots.label.hasOwnProperty("@background"))
                {
                    this.hotspottxtBackground = param1.qthotspots.label.@background == 1;
                }
                if (param1.qthotspots.label.hasOwnProperty("@bordercolor"))
                {
                    this.hotspottxtBorderColor = param1.qthotspots.label.@bordercolor;
                }
                if (param1.qthotspots.label.hasOwnProperty("@backgroundcolor"))
                {
                    this.hotspottxtBackgroundColor = param1.qthotspots.label.@backgroundcolor;
                }
                if (param1.qthotspots.label.hasOwnProperty("@textcolor"))
                {
                    this.hotspottxtTextColor = param1.qthotspots.label.@textcolor;
                }
                if (param1.qthotspots.label.hasOwnProperty("@wordwrap"))
                {
                    this.hotspotWordWrap = param1.qthotspots.label.@wordwrap == 1;
                }
            }
            for each (_loc_2 in param1.qthotspots.hotspot)
            {
                
                _loc_5 = "";
                _loc_6 = "";
                _loc_4 = "";
                if (_loc_2.hasOwnProperty("@id"))
                {
                    if (_loc_2.hasOwnProperty("@title"))
                    {
                        _loc_4 = _loc_2.@title;
                    }
                    if (_loc_2.hasOwnProperty("@url"))
                    {
                        _loc_5 = _loc_2.@url;
                    }
                    if (_loc_2.hasOwnProperty("@target"))
                    {
                        _loc_6 = _loc_2.@target;
                    }
                    this.addQtHotspot(_loc_2.@id, _loc_4, _loc_5, _loc_6);
                }
            }
            return;
        }// end function

    }
}
