package 
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.text.*;

    public class SkinClass extends Sprite
    {
        public var imageRepos:ImageRepository;
        private var objs:Array;
        private var hsobjs:Array;
        public var pano:GgViewer;
        public var sounds:GgSounds;
        public var rootSkinObject:SkinObjectClass;
        public var bytesLoaded:int;
        public var bytesTotal:int;
        public var bytesProgress:Number;
        private var isInit:Boolean;
        private var isViewerInit:Boolean;
        public var hotspotElements:Array;
        public var hotspotTemplates:Array;
        public var defaultSpeed:Number = 0.4;
        public var versNr:int = 0;
        public var debugText:TextField;
        public var loadlevelActive:Boolean = false;
        public var markerElements:Array;

        public function SkinClass(param1:GgViewer)
        {
            this.imageRepos = new ImageRepository();
            this.pano = param1;
            this.objs = new Array();
            this.hsobjs = new Array();
            addEventListener(Event.ENTER_FRAME, this.doEnterFrame, false, 0, true);
            this.isInit = false;
            this.isViewerInit = false;
            visible = false;
            this.hotspotElements = new Array();
            this.hotspotTemplates = new Array();
            this.markerElements = new Array();
            return;
        }// end function

        public function cleanup() : void
        {
            removeEventListener(Event.ENTER_FRAME, this.doEnterFrame);
            if (this.rootSkinObject)
            {
                removeChild(this.rootSkinObject);
            }
            this.clearHotspots();
            return;
        }// end function

        public function xmlConfigElement(param1:SkinObjectClass, param2:XML, param3:Boolean = false) : SkinObjectClass
        {
            var x:int;
            var y:int;
            var w:int;
            var h:int;
            var center:int;
            var action:XML;
            var modifier:XML;
            var ldr:Loader;
            var button:SimpleButton;
            var rpswf:ReposSwfClass;
            var v:Number;
            var element:XML;
            var a:SkinActionClass;
            var m:SkinModifierClass;
            var rpb:ReposBitmapClass;
            var txt:GgTextField;
            var text_fmt:TextFormat;
            var al:int;
            var bar_bgcolor:Number;
            var bar_bgalpha:Number;
            var bar_color:Number;
            var bar_alpha:Number;
            var bar_bgvisible:Boolean;
            var wd:Number;
            var br:Number;
            var ma:Shape;
            var parent:* = param1;
            var config:* = param2;
            var isHotspot:* = param3;
            var type:* = config.@type;
            var skinObj:* = new SkinObjectClass();
            skinObj.skin = this;
            skinObj.speed = this.defaultSpeed;
            if (config.hasOwnProperty("@id"))
            {
                skinObj.id = config.@id;
            }
            if (type == "hotspot" && !isHotspot)
            {
                this.hotspotElements.push(config);
                this.hotspotTemplates.push(skinObj);
            }
            else
            {
                x;
                y;
                w;
                h;
                skinObj.hotspot = parent.hotspot;
                if (type == "hotspot")
                {
                    x;
                    y;
                    w;
                    h;
                }
                else
                {
                    if (config.hasOwnProperty("@x"))
                    {
                        x = config.@x;
                    }
                    if (config.hasOwnProperty("@y"))
                    {
                        y = config.@y;
                    }
                    if (config.hasOwnProperty("@width"))
                    {
                        w = config.@width;
                    }
                    if (config.hasOwnProperty("@height"))
                    {
                        h = config.@height;
                    }
                    if (config.hasOwnProperty("@anchor"))
                    {
                        skinObj.anchor = config.@anchor;
                    }
                }
                if (type == "hotspot")
                {
                    if (config.hasOwnProperty("@distort"))
                    {
                        skinObj.distort = config.@distort == 1;
                    }
                    if (config.hasOwnProperty("@distance"))
                    {
                        skinObj.distortDistance = config.@distance;
                    }
                }
                if (config.hasOwnProperty("@visible"))
                {
                    skinObj.currentVisible = config.@visible == 1;
                    skinObj.visible = skinObj.currentVisible && skinObj.alpha > 0;
                }
                if (config.hasOwnProperty("@handcursor"))
                {
                    skinObj.useHandCursor = config.@handcursor == 1;
                    if (config.@handcursor == 1)
                    {
                        skinObj.buttonMode = true;
                    }
                }
                if (config.hasOwnProperty("@alpha"))
                {
                    skinObj.alpha = Number(config.@alpha);
                    skinObj.visible = skinObj.currentVisible && skinObj.alpha > 0;
                    skinObj.currentAlpha = Number(config.@alpha);
                    skinObj.defaultAlpha = skinObj.currentAlpha;
                    skinObj.targetAlpha = skinObj.currentAlpha;
                }
                if (config.hasOwnProperty("@angle"))
                {
                    skinObj.currentRot = Number(config.@angle);
                    skinObj.targetRot = skinObj.currentRot;
                    skinObj.defaultRot = skinObj.currentRot;
                }
                if (config.hasOwnProperty("@hotspotproxy"))
                {
                    skinObj.hotspotProxy = config.@hotspotproxy;
                }
                skinObj.x = x;
                skinObj.y = y;
                skinObj.defaultPos = new Point(x, y);
                skinObj.currentPos = skinObj.defaultPos.clone();
                center;
                if (config.hasOwnProperty("@center"))
                {
                    center = config.@center;
                }
                if (center == 0 || center == 3 || center == 6)
                {
                    skinObj.centerx = 0;
                }
                if (center == 0 || center == 1 || center == 2)
                {
                    skinObj.centery = 0;
                }
                if (center == 1 || center == 4 || center == 7)
                {
                    skinObj.centerx = w / 2;
                }
                if (center == 3 || center == 4 || center == 5)
                {
                    skinObj.centery = h / 2;
                }
                if (center == 2 || center == 5 || center == 8)
                {
                    skinObj.centerx = w;
                }
                if (center == 6 || center == 7 || center == 8)
                {
                    skinObj.centery = h;
                }
                var _loc_5:* = 0;
                var _loc_6:* = config.action;
                while (_loc_6 in _loc_5)
                {
                    
                    action = _loc_6[_loc_5];
                    a = new SkinActionClass();
                    a.obj = skinObj;
                    if (action.hasOwnProperty("@src"))
                    {
                        a.src = action.attribute("src");
                    }
                    if (action.hasOwnProperty("@type"))
                    {
                        a.type = action.attribute("type");
                    }
                    if (action.hasOwnProperty("@value"))
                    {
                        a.value = action.attribute("value");
                    }
                    if (action.hasOwnProperty("@value2"))
                    {
                        a.value2 = action.attribute("value2");
                    }
                    if (action.hasOwnProperty("@target"))
                    {
                        a.targetId = action.attribute("target");
                    }
                    a.setup();
                    skinObj.actions.push(a);
                }
                var _loc_5:* = 0;
                var _loc_6:* = config.modifier;
                while (_loc_6 in _loc_5)
                {
                    
                    modifier = _loc_6[_loc_5];
                    m = new SkinModifierClass();
                    m.obj = skinObj;
                    if (modifier.hasOwnProperty("@src"))
                    {
                        m.src = modifier.attribute("src");
                    }
                    if (modifier.hasOwnProperty("@type"))
                    {
                        m.type = modifier.attribute("type");
                    }
                    if (modifier.hasOwnProperty("@offset"))
                    {
                        m.offset = modifier.attribute("offset");
                    }
                    if (modifier.hasOwnProperty("@factor"))
                    {
                        m.factor = modifier.attribute("factor");
                    }
                    m.setup();
                    skinObj.modifiers.push(m);
                }
                if (config.hasOwnProperty("@img"))
                {
                    rpb = new ReposBitmapClass(config.@img.toString());
                    skinObj.addChild(rpb);
                }
                if (config.hasOwnProperty("@imgurl"))
                {
                    try
                    {
                        ldr = new Loader();
                        ldr.load(new URLRequest(this.pano.expandFilename(config.@imgurl)));
                        skinObj.addChild(ldr);
                    }
                    catch (error:Error)
                    {
                    }
                }
                if (config.hasOwnProperty("@btn"))
                {
                    button = new SimpleButton();
                    button.visible = true;
                    button.doubleClickEnabled = true;
                    button.upState = new ReposBitmapClass(config.@btn.toString());
                    button.hitTestState = button.upState;
                    button.useHandCursor = skinObj.useHandCursor;
                    if (config.hasOwnProperty("@over"))
                    {
                        button.overState = new ReposBitmapClass(config.@over.toString());
                    }
                    else
                    {
                        button.overState = button.upState;
                    }
                    if (config.hasOwnProperty("@down"))
                    {
                        button.downState = new ReposBitmapClass(config.@down.toString());
                    }
                    else
                    {
                        button.downState = button.overState;
                    }
                    skinObj.addChild(button);
                }
                if (config.hasOwnProperty("@btnurl"))
                {
                    try
                    {
                        button = new SimpleButton();
                        button.visible = true;
                        button.doubleClickEnabled = true;
                        ldr = new Loader();
                        ldr.load(new URLRequest(this.pano.expandFilename(config.@btnurl)));
                        button.upState = ldr;
                        button.hitTestState = button.upState;
                        if (config.hasOwnProperty("@overurl"))
                        {
                            ldr = new Loader();
                            ldr.load(new URLRequest(this.pano.expandFilename(config.@overurl)));
                            button.overState = ldr;
                        }
                        else
                        {
                            button.overState = button.upState;
                        }
                        if (config.hasOwnProperty("@downurl"))
                        {
                            ldr = new Loader();
                            ldr.load(new URLRequest(this.pano.expandFilename(config.@downurl)));
                            button.downState = ldr;
                        }
                        else
                        {
                            button.downState = button.overState;
                        }
                        skinObj.addChild(button);
                    }
                    catch (error:Error)
                    {
                    }
                }
                rpswf;
                if (config.hasOwnProperty("@swf"))
                {
                    rpswf = new ReposSwfClass(config.@swf.toString());
                }
                if (config.hasOwnProperty("@swfurl"))
                {
                    rpswf = new ReposSwfClass(this.pano.expandFilename(config.@swfurl.toString()), true);
                }
                if (rpswf)
                {
                    rpswf.doubleClickEnabled = true;
                    rpswf.parentSkinObj = skinObj;
                    skinObj.addChild(rpswf);
                    rpswf.debugText = this.debugText;
                    skinObj.childSwf = rpswf;
                    if (config.hasOwnProperty("@unloadonhide"))
                    {
                        rpswf.unloadOnHide = config.@unloadonhide == 1;
                    }
                    else
                    {
                        rpswf.unloadOnHide = true;
                    }
                    if (skinObj.visible == false)
                    {
                        skinObj.childSwf.stop();
                    }
                }
                if (type == "text")
                {
                    txt = new GgTextField();
                    txt.tabChildren = false;
                    txt.tabEnabled = false;
                    txt.tf.doubleClickEnabled = true;
                    txt.tf.multiline = true;
                    text_fmt = new TextFormat();
                    if (config.hasOwnProperty("@font"))
                    {
                        text_fmt.font = config.@font;
                    }
                    else
                    {
                        text_fmt.font = "Verdana";
                    }
                    if (config.hasOwnProperty("@size"))
                    {
                        text_fmt.size = config.@size;
                    }
                    else
                    {
                        text_fmt.size = 12;
                    }
                    if (config.hasOwnProperty("@color"))
                    {
                        text_fmt.color = config.@color;
                    }
                    else
                    {
                        text_fmt.color = 0;
                    }
                    al;
                    switch(al)
                    {
                        case 0:
                        {
                            break;
                        }
                        case 1:
                        {
                            break;
                        }
                        case 2:
                        {
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    if (config.hasOwnProperty("@autosize"))
                    {
                        switch(int(al))
                        {
                            case 0:
                            {
                                break;
                            }
                            case 1:
                            {
                                break;
                            }
                            case 2:
                            {
                                break;
                            }
                            default:
                            {
                                break;
                            }
                        }
                    }
                    if (config.hasOwnProperty("@wordwrap"))
                    {
                        txt.tf.wordWrap = config.@wordwrap == 1;
                    }
                    if (config.hasOwnProperty("@scrollbar"))
                    {
                        txt.hasScrollBar = config.@scrollbar == 1;
                    }
                    txt.tf.defaultTextFormat = text_fmt;
                    txt.tf.selectable = false;
                    if (config.hasOwnProperty("@bordercolor"))
                    {
                        txt.borderColor = config.@bordercolor;
                    }
                    else
                    {
                        txt.borderColor = 0;
                    }
                    if (config.hasOwnProperty("@borderalpha"))
                    {
                        txt.borderAlpha = config.@borderalpha;
                    }
                    if (config.hasOwnProperty("@backgroundcolor"))
                    {
                        txt.backgroundColor = config.@backgroundcolor;
                    }
                    else
                    {
                        txt.backgroundColor = 16777215;
                    }
                    if (config.hasOwnProperty("@backgroundalpha"))
                    {
                        txt.backgroundAlpha = config.@backgroundalpha;
                    }
                    if (config.hasOwnProperty("@backgroundvisible"))
                    {
                        txt.background = config.@backgroundvisible == 1;
                    }
                    else
                    {
                        txt.background = true;
                    }
                    if (config.hasOwnProperty("@borderwidth"))
                    {
                        txt.borderWidth = config.@borderwidth;
                    }
                    if (config.hasOwnProperty("@borderradius"))
                    {
                        txt.radius = config.@borderradius;
                    }
                    txt.textWidth = w;
                    txt.textHeight = h;
                    txt.tf.type = TextFieldType.DYNAMIC;
                    if (config.hasOwnProperty("@text"))
                    {
                        txt.htmlText = config.@text;
                        skinObj.textString = config.@text;
                        skinObj.dynamicText = skinObj.textString.indexOf("$") >= 0;
                    }
                    else
                    {
                        txt.htmlText = "Text";
                    }
                    txt.tf.multiline = true;
                    skinObj.textField = txt;
                    skinObj.addChild(txt);
                }
                if (type == "rectangle")
                {
                    bar_bgcolor;
                    bar_bgalpha;
                    bar_color;
                    bar_alpha;
                    bar_bgvisible;
                    wd;
                    br;
                    if (config.hasOwnProperty("@bordercolor"))
                    {
                        bar_color = config.@bordercolor;
                    }
                    if (config.hasOwnProperty("@borderalpha"))
                    {
                        bar_alpha = config.@borderalpha;
                    }
                    if (config.hasOwnProperty("@backgroundcolor"))
                    {
                        bar_bgcolor = config.@backgroundcolor;
                    }
                    if (config.hasOwnProperty("@backgroundalpha"))
                    {
                        bar_bgalpha = config.@backgroundalpha;
                    }
                    if (config.hasOwnProperty("@backgroundvisible"))
                    {
                        bar_bgvisible = config.@backgroundvisible == 1;
                    }
                    if (config.hasOwnProperty("@borderwidth"))
                    {
                        wd = config.@borderwidth;
                    }
                    if (config.hasOwnProperty("@borderradius"))
                    {
                        br = config.@borderradius;
                    }
                    skinObj.graphics.clear();
                    if (bar_bgvisible)
                    {
                        skinObj.graphics.beginFill(bar_bgcolor, bar_bgalpha);
                    }
                    if (wd > 0)
                    {
                        skinObj.graphics.lineStyle(wd, bar_color, bar_alpha);
                    }
                    if (br > 0)
                    {
                        skinObj.graphics.drawRoundRect(0, 0, w, h, br);
                    }
                    else
                    {
                        skinObj.graphics.drawRect(0, 0, w, h);
                    }
                    if (bar_bgvisible)
                    {
                        skinObj.graphics.endFill();
                    }
                }
                if (type == "container")
                {
                    if (config.hasOwnProperty("@mask"))
                    {
                        if (config.@mask == 1)
                        {
                            ma = new Shape();
                            ma.graphics.beginFill(16711680);
                            ma.graphics.drawRect(0, 0, w, h);
                            ma.graphics.endFill();
                            skinObj.addChild(ma);
                            skinObj.mask = ma;
                        }
                    }
                }
                if (type == "marker")
                {
                    if (config.hasOwnProperty("@nodeid"))
                    {
                        skinObj.nodeId = config.@nodeid;
                    }
                    if (config.hasOwnProperty("active"))
                    {
                        skinObj.activeElement = this.xmlConfigElement(skinObj, new XML(config.active.element), isHotspot);
                        skinObj.activeElement.visible = false;
                        skinObj.activeElement.currentVisible = false;
                        skinObj.activeElement.updatePosition();
                    }
                    if (config.hasOwnProperty("normal"))
                    {
                        skinObj.normalElement = this.xmlConfigElement(skinObj, new XML(config.normal.element), isHotspot);
                        skinObj.normalElement.visible = true;
                        skinObj.normalElement.currentVisible = true;
                        skinObj.normalElement.updatePosition();
                    }
                    this.markerElements.push(skinObj);
                }
                if (config.hasOwnProperty("@width"))
                {
                    skinObj.default_width = config.@width;
                    if (skinObj.textField)
                    {
                        skinObj.textField.default_width = skinObj.default_width;
                    }
                }
                else
                {
                    skinObj.default_height = skinObj.width;
                }
                if (config.hasOwnProperty("@height"))
                {
                    skinObj.default_height = config.@height;
                }
                else
                {
                    skinObj.default_height = skinObj.height;
                }
                if (config.hasOwnProperty("@scalex"))
                {
                    v = config.@scalex;
                    skinObj.sx = v;
                    skinObj.currentScale.x = v;
                    skinObj.modify = true;
                    skinObj.defaultScale.x = v;
                }
                if (config.hasOwnProperty("@scaley"))
                {
                    v = config.@scaley;
                    skinObj.sy = v;
                    skinObj.currentScale.y = v;
                    skinObj.modify = true;
                    skinObj.defaultScale.y = v;
                }
                parent.addChild(skinObj);
                skinObj.updatePosition();
                if (isHotspot)
                {
                    this.hsobjs.push(skinObj);
                }
                else
                {
                    this.objs.push(skinObj);
                }
                var _loc_5:* = this;
                var _loc_6:* = this.versNr + 1;
                _loc_5.versNr = _loc_6;
                var _loc_5:* = 0;
                var _loc_6:* = config.element;
                while (_loc_6 in _loc_5)
                {
                    
                    element = _loc_6[_loc_5];
                    this.xmlConfigElement(skinObj, element, isHotspot);
                }
            }
            return skinObj;
        }// end function

        public function createHotspot(param1:String, param2:String, param3:Number, param4:Number, param5:String, param6:String, param7:String, param8:Number = 0, param9:Number = 0) : Hotspot
        {
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_12:* = null;
            var _loc_13:* = null;
            var _loc_14:* = 0;
            var _loc_15:* = 0;
            if (this.hotspotElements.length > 0)
            {
                _loc_10 = new SkinObjectClass();
                _loc_10.skin = this;
                _loc_10.speed = this.defaultSpeed;
                _loc_10.defaultPos = new Point(0, 0);
                _loc_10.currentPos = new Point(0, 0);
                _loc_10.hotspot = this.pano.addHotspot(param2, param3, param4, _loc_10, param6, param7);
                _loc_10.hotspot.title = param5;
                _loc_15 = -1;
                _loc_14 = 0;
                while (_loc_14 < this.hotspotElements.length)
                {
                    
                    if (this.hotspotElements[_loc_14].@id == param1)
                    {
                        _loc_13 = this.hotspotElements[_loc_14];
                        _loc_15 = _loc_14;
                    }
                    _loc_14++;
                }
                if (_loc_13 == null)
                {
                    _loc_13 = this.hotspotElements[0];
                    _loc_15 = 0;
                }
                _loc_11 = this.xmlConfigElement(_loc_10, _loc_13, true);
                if (_loc_15 >= 0)
                {
                    _loc_12 = this.hotspotTemplates[_loc_15];
                    _loc_11.alpha = _loc_12.currentAlpha;
                    _loc_11.currentAlpha = _loc_12.currentAlpha;
                    _loc_11.visible = _loc_12.visible;
                    _loc_11.currentVisible = _loc_12.currentVisible;
                    _loc_11.currentPos = _loc_12.currentPos.clone();
                    _loc_11.currentScale = _loc_12.currentScale.clone();
                    _loc_11.currentRot = _loc_12.currentRot;
                    _loc_11.targetRot = _loc_12.targetRot;
                    if (_loc_12.targetPos)
                    {
                        _loc_11.targetPos = _loc_12.targetPos.clone();
                    }
                    if (_loc_12.targetScale)
                    {
                        _loc_11.targetScale = _loc_12.targetScale.clone();
                    }
                    _loc_11.targetAlpha = _loc_12.targetAlpha;
                    _loc_11.activeState = _loc_12.activeState;
                    _loc_11.activeStateRot = _loc_12.activeStateRot;
                    _loc_11.activeStateScale = _loc_12.activeStateScale;
                    _loc_11.activeStateAlpha = _loc_12.activeStateAlpha;
                    _loc_11.updatePosition();
                }
                _loc_10.distort = _loc_11.distort;
                _loc_10.distortDistance = _loc_11.distortDistance;
                this.pano.hsClip.addChild(_loc_10);
                return _loc_10.hotspot;
            }
            else
            {
                return null;
            }
        }// end function

        public function clearHotspots() : void
        {
            this.hsobjs = new Array();
            var _loc_1:* = this;
            var _loc_2:* = this.versNr + 1;
            _loc_1.versNr = _loc_2;
            return;
        }// end function

        public function findObjectId(param1:String) : SkinObjectClass
        {
            var _loc_2:* = null;
            for each (_loc_2 in this.objs)
            {
                
                if (_loc_2.id != "" && _loc_2.id == param1)
                {
                    return _loc_2;
                }
            }
            for each (_loc_2 in this.hsobjs)
            {
                
                if (_loc_2.id != "" && _loc_2.id == param1)
                {
                    return _loc_2;
                }
            }
            return null;
        }// end function

        public function escapePattern(param1:String) : String
        {
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_2:* = param1.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_5 = param1.charCodeAt(_loc_4);
                switch(_loc_5)
                {
                    case 9:
                    {
                        _loc_3 = _loc_3 + "\\t";
                        break;
                    }
                    case 10:
                    {
                        _loc_3 = _loc_3 + "\\n";
                        break;
                    }
                    case 13:
                    {
                        _loc_3 = _loc_3 + "\\r";
                        break;
                    }
                    case "\\":
                    {
                        _loc_3 = _loc_3 + "\\\\";
                        break;
                    }
                    case "^":
                    case "$":
                    case "/":
                    case ".":
                    case "*":
                    case "+":
                    case "?":
                    case "(":
                    case ")":
                    case "[":
                    case "]":
                    case "|":
                    {
                        _loc_3 = _loc_3 + ("\\" + param1.charAt(_loc_4));
                        break;
                    }
                    case 34:
                    {
                        _loc_3 = _loc_3 + "\\\"";
                        break;
                    }
                    default:
                    {
                        if (_loc_5 >= 32 && _loc_5 < 128)
                        {
                            _loc_3 = _loc_3 + param1.charAt(_loc_4);
                        }
                        else if (_loc_5 < 256)
                        {
                            _loc_3 = _loc_3 + ("\\x" + _loc_5.toString(16));
                        }
                        else
                        {
                            _loc_3 = _loc_3 + ("\\u%1" + _loc_5.toString(16));
                        }
                        break;
                    }
                }
                _loc_4++;
            }
            return _loc_3;
        }// end function

        public function findObjectIds(param1:String) : Array
        {
            var _loc_2:* = null;
            var _loc_4:* = null;
            var _loc_5:* = false;
            var _loc_6:* = null;
            var _loc_3:* = new Array();
            if (param1.charAt(0) == "#")
            {
                _loc_4 = param1.substr(1);
                _loc_6 = new RegExp("^" + _loc_4 + "$");
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
            for each (_loc_2 in this.hotspotTemplates)
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
            for each (_loc_2 in this.objs)
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
            for each (_loc_2 in this.hsobjs)
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

        public function hotspotClick(param1:String) : void
        {
            var _loc_2:* = null;
            if (param1 != "")
            {
                for each (_loc_2 in this.objs)
                {
                    
                    if (_loc_2.hotspotProxy == param1 || _loc_2.hotspotProxy == "*")
                    {
                        _loc_2.doClick(null);
                    }
                }
            }
            return;
        }// end function

        public function hotspotRollOver(param1:String) : void
        {
            var _loc_2:* = null;
            if (param1 != "")
            {
                for each (_loc_2 in this.objs)
                {
                    
                    if (_loc_2.hotspotProxy == param1 || _loc_2.hotspotProxy == "*")
                    {
                        _loc_2.doRollOver(null);
                    }
                }
            }
            return;
        }// end function

        public function hotspotRollOut(param1:String) : void
        {
            var _loc_2:* = null;
            if (param1 != "")
            {
                for each (_loc_2 in this.objs)
                {
                    
                    if (_loc_2.hotspotProxy == param1 || _loc_2.hotspotProxy == "*")
                    {
                        _loc_2.doRollOut(null);
                    }
                }
            }
            return;
        }// end function

        public function nodeChanged() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = false;
            var _loc_3:* = null;
            for each (_loc_1 in this.markerElements)
            {
                
                _loc_2 = false;
                if (_loc_1.nodeId.charAt(0) == "{")
                {
                    _loc_2 = _loc_1.nodeId.substr(1, _loc_1.nodeId.length - 2) == this.pano.currentNodeId;
                }
                else
                {
                    for each (_loc_3 in this.pano.userdataTags)
                    {
                        
                        if (_loc_3 == _loc_1.nodeId)
                        {
                            _loc_2 = true;
                        }
                    }
                }
                if (_loc_2 != _loc_1.isActive)
                {
                    if (_loc_2)
                    {
                        if (_loc_1.activeElement)
                        {
                            _loc_1.activeElement.visible = true;
                            _loc_1.activeElement.currentVisible = true;
                        }
                        if (_loc_1.normalElement)
                        {
                            _loc_1.normalElement.visible = false;
                            _loc_1.normalElement.currentVisible = false;
                        }
                        _loc_1.doActivate();
                    }
                    else
                    {
                        if (_loc_1.activeElement)
                        {
                            _loc_1.activeElement.visible = false;
                            _loc_1.activeElement.currentVisible = false;
                        }
                        if (_loc_1.normalElement)
                        {
                            _loc_1.normalElement.visible = true;
                            _loc_1.normalElement.currentVisible = true;
                        }
                        _loc_1.doDeactivate();
                    }
                    _loc_1.isActive = _loc_2;
                }
            }
            return;
        }// end function

        public function doInit() : void
        {
            var _loc_1:* = null;
            for each (_loc_1 in this.hotspotTemplates)
            {
                
                _loc_1.doInit();
            }
            for each (_loc_1 in this.objs)
            {
                
                _loc_1.doInit();
            }
            for each (_loc_1 in this.hsobjs)
            {
                
                _loc_1.doInit();
            }
            return;
        }// end function

        public function doViewerInit() : void
        {
            var _loc_1:* = null;
            for each (_loc_1 in this.hotspotTemplates)
            {
                
                _loc_1.doViewerInit();
            }
            for each (_loc_1 in this.objs)
            {
                
                _loc_1.doViewerInit();
            }
            for each (_loc_1 in this.hsobjs)
            {
                
                _loc_1.doViewerInit();
            }
            return;
        }// end function

        public function doEnterFrame(event:Event) : void
        {
            var _loc_2:* = null;
            this.bytesLoaded = this.pano.bytesLoaded();
            this.bytesTotal = this.pano.bytesTotal();
            if (this.bytesTotal == 0)
            {
                this.bytesProgress = 0;
            }
            else
            {
                this.bytesProgress = this.bytesLoaded / this.bytesTotal;
                if (this.bytesProgress < 0)
                {
                    this.bytesProgress = 0;
                }
                if (this.bytesProgress > 1)
                {
                    this.bytesProgress = 1;
                }
            }
            if (!this.isInit)
            {
                this.isInit = true;
                visible = true;
            }
            if (!this.isViewerInit)
            {
                if (this.pano && this.pano.ready)
                {
                    this.isViewerInit = true;
                    this.doViewerInit();
                }
            }
            for each (_loc_2 in this.hotspotTemplates)
            {
                
                _loc_2.doEnterFrame();
            }
            for each (_loc_2 in this.objs)
            {
                
                _loc_2.doEnterFrame();
            }
            for each (_loc_2 in this.hsobjs)
            {
                
                _loc_2.doEnterFrame();
            }
            if (this.pano)
            {
                if (this.pano.isLoadingLevels && !this.loadlevelActive)
                {
                    this.loadlevelActive = true;
                    for each (_loc_2 in this.hotspotTemplates)
                    {
                        
                        _loc_2.doReloadLevels();
                    }
                    for each (_loc_2 in this.objs)
                    {
                        
                        _loc_2.doReloadLevels();
                    }
                    for each (_loc_2 in this.hsobjs)
                    {
                        
                        _loc_2.doReloadLevels();
                    }
                }
                if (!this.pano.isLoadingLevels && this.loadlevelActive)
                {
                    this.loadlevelActive = false;
                    for each (_loc_2 in this.hotspotTemplates)
                    {
                        
                        _loc_2.doLoadedLevels();
                    }
                    for each (_loc_2 in this.objs)
                    {
                        
                        _loc_2.doLoadedLevels();
                    }
                    for each (_loc_2 in this.hsobjs)
                    {
                        
                        _loc_2.doLoadedLevels();
                    }
                }
            }
            this.pano.isReload = false;
            return;
        }// end function

        public function xmlConfig(param1:XML) : void
        {
            var _loc_2:* = null;
            this.rootSkinObject = new SkinObjectClass();
            this.rootSkinObject.skin = this;
            this.rootSkinObject.speed = this.defaultSpeed;
            this.rootSkinObject.defaultPos = new Point(0, 0);
            this.rootSkinObject.currentPos = new Point(0, 0);
            addChild(this.rootSkinObject);
            if (param1.hasOwnProperty("@marginleft"))
            {
                this.pano.marginLeft = param1.@marginleft;
            }
            if (param1.hasOwnProperty("@marginright"))
            {
                this.pano.marginRight = param1.@marginright;
            }
            if (param1.hasOwnProperty("@margintop"))
            {
                this.pano.marginTop = param1.@margintop;
            }
            if (param1.hasOwnProperty("@marginbottom"))
            {
                this.pano.marginBottom = param1.@marginbottom;
            }
            this.pano.updateMargins();
            for each (_loc_2 in param1.element)
            {
                
                this.xmlConfigElement(this.rootSkinObject, _loc_2);
            }
            this.rootSkinObject.updatePosition();
            this.doInit();
            return;
        }// end function

    }
}
