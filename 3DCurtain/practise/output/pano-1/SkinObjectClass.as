package 
{
    import SkinObjectClass.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.system.*;

    public class SkinObjectClass extends Sprite
    {
        public var id:String;
        public var isLoaded:Boolean;
        public var anchor:int;
        public var centerx:int;
        public var centery:int;
        public var default_width:int;
        public var default_height:int;
        public var mouseDown:Boolean;
        public var mouseRollIn:Boolean;
        public var mouseMoveIn:Boolean;
        public var hotspotProxy:String;
        public var speed:Number = 0;
        public var actions:Array;
        public var modifiers:Array;
        public var didLoadedAction:Boolean = false;
        public var cx:int;
        public var cy:int;
        public var textString:String;
        public var textField:GgTextField;
        public var dynamicText:Boolean;
        public var hotspot:Hotspot;
        public var modify:Boolean = false;
        public var rot:Number = 0;
        public var sx:Number = 1;
        public var sy:Number = 1;
        public var tx:Number = 0;
        public var ty:Number = 0;
        private var lrot:Number = 0;
        private var lsx:Number = 1;
        private var lsy:Number = 1;
        private var ltx:Number = 0;
        private var lty:Number = 0;
        private var lastString:String;
        public var defaultRot:Number = 0;
        public var currentRot:Number = 0;
        public var targetRot:Number = 0;
        public var defaultPos:Point;
        public var currentPos:Point;
        public var targetPos:Point;
        public var defaultScale:Point;
        public var currentScale:Point;
        public var targetScale:Point;
        public var currentAlpha:Number;
        public var defaultAlpha:Number;
        public var targetAlpha:Number;
        public var currentVisible:Boolean;
        public var activeState:Boolean = false;
        public var activeStateRot:Boolean = false;
        public var activeStateScale:Boolean = false;
        public var activeStateAlpha:Boolean = false;
        public var skin:SkinClass;
        private var stageInit:Boolean;
        private var clickTriggered:Boolean = false;
        private var doubleClickTriggered:Boolean = false;
        private var positionDirty:Boolean = false;
        public var childSwf:ReposSwfClass;
        public var nodeId:String;
        public var normalElement:SkinObjectClass;
        public var activeElement:SkinObjectClass;
        public var isActive:Boolean = false;
        protected var keyActive:Boolean = false;
        public var distortDistance:Number = 500;
        public var distort:Boolean = true;

        public function SkinObjectClass()
        {
            this.actions = new Array();
            this.modifiers = new Array();
            this.isLoaded = false;
            this.id = "";
            this.nodeId = "";
            this.anchor = 0;
            this.default_width = 0;
            this.default_height = 0;
            this.mouseDown = false;
            this.mouseRollIn = false;
            this.defaultPos = new Point(0, 0);
            this.currentPos = new Point(0, 0);
            this.currentScale = new Point(1, 1);
            this.defaultScale = new Point(1, 1);
            this.stageInit = true;
            this.dynamicText = false;
            this.targetAlpha = 1;
            this.currentAlpha = 1;
            this.defaultAlpha = 1;
            this.currentVisible = true;
            doubleClickEnabled = true;
            addEventListener(MouseEvent.CLICK, this.doClick, false, 0, true);
            addEventListener(MouseEvent.DOUBLE_CLICK, this.doDoubleClick, false, 0, true);
            addEventListener(MouseEvent.MOUSE_DOWN, this.doMouseDown, false, 0, true);
            addEventListener(MouseEvent.MOUSE_OVER, this.doMouseOver, false, 0, true);
            addEventListener(MouseEvent.MOUSE_OUT, this.doMouseOut, false, 0, true);
            addEventListener(MouseEvent.ROLL_OVER, this.doRollOver, false, 0, true);
            addEventListener(MouseEvent.ROLL_OUT, this.doRollOut, false, 0, true);
            addEventListener(KeyboardEvent.KEY_DOWN, this.doKeyDown, false, 0, true);
            addEventListener(KeyboardEvent.KEY_UP, this.doKeyUp, false, 0, true);
            return;
        }// end function

        override public function set visible(param1:Boolean) : void
        {
            if (super.visible != param1)
            {
                super.visible = param1;
                if (this.childSwf)
                {
                    if (param1)
                    {
                        this.childSwf.start();
                    }
                    else
                    {
                        this.childSwf.stop();
                    }
                }
            }
            return;
        }// end function

        public function cleanup() : void
        {
            stage.removeEventListener(Event.RESIZE, this.doStageResize);
            stage.removeEventListener(Event.FULLSCREEN, this.doFullScreenEvent);
            return;
        }// end function

        public function doInit() : void
        {
            var _loc_1:* = null;
            for each (_loc_1 in this.actions)
            {
                
                if (_loc_1.onInit != null)
                {
                    _loc_1.onInit();
                }
            }
            return;
        }// end function

        public function doViewerInit() : void
        {
            var _loc_1:* = null;
            for each (_loc_1 in this.actions)
            {
                
                if (_loc_1.onViewerInit != null)
                {
                    _loc_1.onViewerInit();
                }
            }
            return;
        }// end function

        public function doFullScreenEvent(event:Event) : void
        {
            var _loc_2:* = null;
            if (stage.displayState == StageDisplayState.FULL_SCREEN)
            {
                for each (_loc_2 in this.actions)
                {
                    
                    if (_loc_2.onEnterFullscreen != null)
                    {
                        _loc_2.onEnterFullscreen();
                    }
                }
            }
            else
            {
                for each (_loc_2 in this.actions)
                {
                    
                    if (_loc_2.onExitFullscreen != null)
                    {
                        _loc_2.onExitFullscreen();
                    }
                }
            }
            return;
        }// end function

        public function doClick(event:MouseEvent) : void
        {
            var _loc_3:* = null;
            if (this.clickTriggered)
            {
                return;
            }
            this.clickTriggered = true;
            var _loc_2:* = false;
            if (this.hotspot)
            {
                this.skin.pano.hotspots.currentHotspot = this.hotspot;
            }
            for each (_loc_3 in this.actions)
            {
                
                if (_loc_3.onMouseClick != null)
                {
                    _loc_3.onMouseClick();
                    _loc_2 = true;
                }
            }
            if (!_loc_2 && this.nodeId.length > 0)
            {
                this.skin.pano.openNext(this.nodeId);
            }
            return;
        }// end function

        public function doDoubleClick(event:MouseEvent) : void
        {
            var _loc_2:* = null;
            if (this.doubleClickTriggered)
            {
                return;
            }
            this.doubleClickTriggered = true;
            for each (_loc_2 in this.actions)
            {
                
                if (_loc_2.onMouseDoubleClick != null)
                {
                    _loc_2.onMouseDoubleClick();
                }
            }
            return;
        }// end function

        public function doMouseDown(event:MouseEvent) : void
        {
            var _loc_2:* = null;
            this.mouseDown = true;
            for each (_loc_2 in this.actions)
            {
                
                if (_loc_2.onMouseDown != null)
                {
                    _loc_2.onMouseDown();
                }
            }
            return;
        }// end function

        public function doMouseUp(event:MouseEvent) : void
        {
            var _loc_2:* = null;
            if (this.mouseDown)
            {
                this.mouseDown = false;
                for each (_loc_2 in this.actions)
                {
                    
                    if (_loc_2.onMouseUp != null)
                    {
                        _loc_2.onMouseUp();
                    }
                }
            }
            return;
        }// end function

        public function doRollOver(event:MouseEvent) : void
        {
            var _loc_2:* = null;
            if (!this.mouseRollIn)
            {
                this.mouseRollIn = true;
                if (this.hotspot)
                {
                    this.skin.pano.hotspots.currentHotspot = this.hotspot;
                }
                for each (_loc_2 in this.actions)
                {
                    
                    if (_loc_2.onMouseEnter != null)
                    {
                        _loc_2.onMouseEnter();
                    }
                }
            }
            return;
        }// end function

        public function doRollOut(event:MouseEvent) : void
        {
            var _loc_2:* = null;
            if (this.mouseRollIn)
            {
                this.mouseRollIn = false;
                if (this.hotspot)
                {
                    this.skin.pano.hotspots.currentHotspot = null;
                }
                for each (_loc_2 in this.actions)
                {
                    
                    if (_loc_2.onMouseLeave != null)
                    {
                        _loc_2.onMouseLeave();
                    }
                }
            }
            return;
        }// end function

        public function doMouseOver(event:MouseEvent) : void
        {
            if (!this.mouseMoveIn)
            {
                this.mouseMoveIn = true;
            }
            return;
        }// end function

        public function doMouseOut(event:MouseEvent) : void
        {
            if (this.mouseMoveIn)
            {
                this.mouseMoveIn = false;
            }
            return;
        }// end function

        public function doKeyDown(event:KeyboardEvent) : void
        {
            if (event.keyCode == 32 && !this.skin.pano.lockedKeyboard())
            {
                this.doMouseDown(null);
                this.keyActive = true;
            }
            return;
        }// end function

        public function doKeyUp(event:KeyboardEvent) : void
        {
            if (event.keyCode == 32 && !this.skin.pano.lockedKeyboard())
            {
                this.doMouseUp(null);
                this.keyActive = false;
            }
            return;
        }// end function

        private function doStageResize(event:Event) : void
        {
            this.positionDirty = true;
            return;
        }// end function

        private function doResize() : void
        {
            this.updatePosition();
            return;
        }// end function

        public function doLoadedLevels() : void
        {
            var _loc_1:* = null;
            for each (_loc_1 in this.actions)
            {
                
                if (_loc_1.onLoadedLevels != null)
                {
                    _loc_1.onLoadedLevels();
                }
            }
            return;
        }// end function

        public function doReloadLevels() : void
        {
            var _loc_1:* = null;
            for each (_loc_1 in this.actions)
            {
                
                if (_loc_1.onReloadLevels != null)
                {
                    _loc_1.onReloadLevels();
                }
            }
            return;
        }// end function

        public function doActivate() : void
        {
            var _loc_1:* = null;
            for each (_loc_1 in this.actions)
            {
                
                if (_loc_1.onActivate != null)
                {
                    _loc_1.onActivate();
                }
            }
            return;
        }// end function

        public function doDeactivate() : void
        {
            var _loc_1:* = null;
            for each (_loc_1 in this.actions)
            {
                
                if (_loc_1.onDeactivate != null)
                {
                    _loc_1.onDeactivate();
                }
            }
            return;
        }// end function

        public function updatePosition() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            if (parent)
            {
                _loc_1 = parent.width;
                _loc_2 = parent.height;
                if (this.skin && this.skin.rootSkinObject == parent && stage)
                {
                    if (stage.scaleMode == StageScaleMode.NO_SCALE && this.skin.pano.rect)
                    {
                        _loc_1 = this.skin.pano.rect.width;
                        _loc_2 = this.skin.pano.rect.height;
                    }
                    else
                    {
                        _loc_1 = this.skin.pano.windowWidth;
                        _loc_2 = this.skin.pano.windowHeight;
                    }
                    _loc_1 = _loc_1 + (this.skin.pano.marginLeft + this.skin.pano.marginRight);
                    _loc_2 = _loc_2 + (this.skin.pano.marginTop + this.skin.pano.marginBottom);
                }
                _loc_3 = this.anchor;
                if (_loc_3 == 0 || _loc_3 == 3 || _loc_3 == 6)
                {
                    this.cx = this.currentPos.x;
                }
                if (_loc_3 == 0 || _loc_3 == 1 || _loc_3 == 2)
                {
                    this.cy = this.currentPos.y;
                }
                if (_loc_3 == 1 || _loc_3 == 4 || _loc_3 == 7)
                {
                    this.cx = this.currentPos.x + _loc_1 / 2;
                }
                if (_loc_3 == 3 || _loc_3 == 4 || _loc_3 == 5)
                {
                    this.cy = this.currentPos.y + _loc_2 / 2;
                }
                if (_loc_3 == 2 || _loc_3 == 5 || _loc_3 == 8)
                {
                    this.cx = this.currentPos.x + _loc_1;
                }
                if (_loc_3 == 6 || _loc_3 == 7 || _loc_3 == 8)
                {
                    this.cy = this.currentPos.y + _loc_2;
                }
                if (this.modify)
                {
                    _loc_4 = new Matrix();
                    _loc_4.tx = _loc_4.tx - this.centerx;
                    _loc_4.ty = _loc_4.ty - this.centery;
                    _loc_4.scale(this.sx, this.sy);
                    if (this.rot != 0)
                    {
                        _loc_4.rotate(1e-015 + this.rot * Math.PI / 180);
                    }
                    _loc_4.tx = _loc_4.tx + (this.centerx + this.cx + this.tx);
                    _loc_4.ty = _loc_4.ty + (this.centery + this.cy + this.ty);
                    transform.matrix = _loc_4;
                }
                else
                {
                    x = this.cx;
                    y = this.cy;
                }
            }
            return;
        }// end function

        public function findObjectId(param1:String) : SkinObjectClass
        {
            var _loc_3:* = null;
            if (param1 == this.id)
            {
                return this;
            }
            var _loc_2:* = 0;
            while (_loc_2 < numChildren)
            {
                
                _loc_3 = getChildAt(_loc_2) as SkinObjectClass;
                if (_loc_3)
                {
                    _loc_3 = _loc_3.findObjectId(param1);
                    if (_loc_3 != null)
                    {
                        return _loc_3;
                    }
                }
                _loc_2++;
            }
            return null;
        }// end function

        public function replaceStringVariables(param1:String) : String
        {
            var _loc_3:* = null;
            var _loc_2:* = param1;
            _loc_2 = _loc_2.replace("$b", this.skin.bytesLoaded);
            _loc_2 = _loc_2.replace("$t", this.skin.bytesTotal);
            _loc_2 = _loc_2.replace("$B", Math.floor(this.skin.bytesLoaded / 1000));
            _loc_2 = _loc_2.replace("$T", Math.floor(this.skin.bytesTotal / 1000));
            if (this.hotspot != null)
            {
                _loc_2 = _loc_2.replace("$hs", this.hotspot.title);
                _loc_2 = _loc_2.replace("$hu", this.hotspot.url);
                _loc_2 = _loc_2.replace("$ht", this.hotspot.target);
                _loc_2 = _loc_2.replace("$hap", this.hotspot.posPan);
                _loc_2 = _loc_2.replace("$hat", this.hotspot.posTilt);
            }
            else if (this.skin.pano.hotspots.currentHotspot != null)
            {
                _loc_3 = this.skin.pano.hotspots.currentHotspot;
                _loc_2 = _loc_2.replace("$hs", _loc_3.title);
                _loc_2 = _loc_2.replace("$hu", _loc_3.url);
                _loc_2 = _loc_2.replace("$ht", _loc_3.target);
                _loc_2 = _loc_2.replace("$hap", _loc_3.posPan);
                _loc_2 = _loc_2.replace("$hat", _loc_3.posTilt);
            }
            else
            {
                _loc_2 = _loc_2.replace("$hs", "");
                _loc_2 = _loc_2.replace("$hu", "");
                _loc_2 = _loc_2.replace("$ht", "");
                _loc_2 = _loc_2.replace("$hap", "");
                _loc_2 = _loc_2.replace("$hat", "");
            }
            _loc_2 = _loc_2.replace("$mp", this.skin.mouseX + "/" + this.skin.mouseY);
            _loc_2 = _loc_2.replace("$ver", Capabilities.version);
            _loc_2 = _loc_2.replace("$ut", this.skin.pano.userdata[0]);
            _loc_2 = _loc_2.replace("$ud", this.skin.pano.userdata[1]);
            _loc_2 = _loc_2.replace("$ua", this.skin.pano.userdata[2]);
            _loc_2 = _loc_2.replace("$ue", this.skin.pano.userdata[3]);
            _loc_2 = _loc_2.replace("$uc", this.skin.pano.userdata[4]);
            _loc_2 = _loc_2.replace("$us", this.skin.pano.userdata[5]);
            _loc_2 = _loc_2.replace("$ui", this.skin.pano.userdata[6]);
            _loc_2 = _loc_2.replace("$uo", this.skin.pano.userdata[7]);
            _loc_2 = _loc_2.replace("$lat", this.skin.pano.latitude);
            _loc_2 = _loc_2.replace("$lng", this.skin.pano.longitude);
            return _loc_2;
        }// end function

        public function doEnterFrame() : void
        {
            var action:SkinActionClass;
            var diff:Point;
            var mspeed:Number;
            var l:Number;
            var pan:Number;
            var npan:Number;
            var tilt:Number;
            var fov:Number;
            var val:Number;
            var sm:SkinModifierClass;
            var tmpstr:String;
            this.sx = this.currentScale.x;
            this.sy = this.currentScale.y;
            this.rot = this.currentRot;
            this.tx = 0;
            this.ty = 0;
            this.clickTriggered = false;
            this.doubleClickTriggered = false;
            var moved:Boolean;
            if (stage != null && this.stageInit)
            {
                this.stageInit = false;
                stage.addEventListener(MouseEvent.MOUSE_UP, this.doMouseUp, false, 0, true);
                stage.addEventListener(Event.FULLSCREEN, this.doFullScreenEvent);
                if (parent && this.skin && this.skin.rootSkinObject == parent)
                {
                    this.doResize();
                    stage.addEventListener(Event.RESIZE, this.doStageResize);
                }
            }
            if (this.positionDirty)
            {
                this.positionDirty = false;
                this.doResize();
            }
            if (!this.didLoadedAction)
            {
                if (this.skin.bytesLoaded == this.skin.bytesTotal && this.skin.pano.isComplete())
                {
                    this.didLoadedAction = true;
                    var _loc_2:* = 0;
                    var _loc_3:* = this.actions;
                    while (_loc_3 in _loc_2)
                    {
                        
                        action = _loc_3[_loc_2];
                        if (action.onLoaded != null)
                        {
                            action.onLoaded();
                        }
                    }
                }
            }
            else if (this.skin.bytesLoaded < this.skin.bytesTotal || this.skin.pano.isReload)
            {
                this.didLoadedAction = false;
                var _loc_2:* = 0;
                var _loc_3:* = this.actions;
                while (_loc_3 in _loc_2)
                {
                    
                    action = _loc_3[_loc_2];
                    if (action.onReload != null)
                    {
                        action.onReload();
                    }
                }
            }
            if (this.currentAlpha != this.targetAlpha)
            {
                l = this.targetAlpha - this.currentAlpha;
                mspeed;
                if (Math.abs(l) > 0.01)
                {
                    if (Math.abs(l * 0.3) >= mspeed)
                    {
                        l = mspeed * l / Math.abs(l);
                    }
                    else
                    {
                        l = l * 0.5;
                    }
                    this.currentAlpha = this.currentAlpha + l;
                }
                else
                {
                    this.currentAlpha = this.targetAlpha;
                }
            }
            if (alpha != this.currentAlpha)
            {
                alpha = this.currentAlpha;
                this.visible = alpha > 0 && this.currentVisible;
            }
            if (visible)
            {
                if (this.mouseMoveIn || this.keyActive)
                {
                    var _loc_2:* = 0;
                    var _loc_3:* = this.actions;
                    while (_loc_3 in _loc_2)
                    {
                        
                        action = _loc_3[_loc_2];
                        if (this.mouseDown || this.keyActive)
                        {
                            if (action.onPressed != null)
                            {
                                action.onPressed();
                            }
                        }
                        if (action.onMouseOver != null)
                        {
                            action.onMouseOver();
                        }
                    }
                }
                if (this.targetPos)
                {
                    try
                    {
                        diff = this.targetPos.subtract(this.currentPos);
                        if (diff.x != 0 || diff.y != 0)
                        {
                            mspeed;
                            l = diff.length;
                            if (l > 1.5)
                            {
                                if (l * 0.3 >= mspeed)
                                {
                                    diff.normalize(mspeed);
                                }
                                else
                                {
                                    diff.normalize(l * 0.3);
                                }
                            }
                            this.currentPos = this.currentPos.add(diff);
                            moved;
                        }
                    }
                    catch (error:Error)
                    {
                    }
                }
                if (this.targetScale)
                {
                    try
                    {
                        diff = new Point(this.targetScale.x - this.currentScale.x, this.targetScale.y - this.currentScale.y);
                        if (diff.x != 0 || diff.y != 0)
                        {
                            mspeed;
                            l = diff.length;
                            if (l > 0.01)
                            {
                                if (l * 0.3 >= mspeed)
                                {
                                    diff.normalize(mspeed);
                                }
                                else
                                {
                                    diff.normalize(l * 0.5);
                                }
                            }
                            this.currentScale.x = this.currentScale.x + diff.x;
                            this.currentScale.y = this.currentScale.y + diff.y;
                            this.modify = true;
                        }
                        else
                        {
                            this.currentScale.x = this.targetScale.x;
                            this.currentScale.y = this.targetScale.y;
                        }
                    }
                    catch (error:Error)
                    {
                    }
                    this.sx = this.currentScale.x;
                    this.sy = this.currentScale.y;
                }
                if (this.currentRot != this.targetRot)
                {
                    l = this.targetRot - this.currentRot;
                    mspeed;
                    if (Math.abs(l) > 0.1)
                    {
                        if (Math.abs(l * 0.3) >= mspeed)
                        {
                            l = mspeed * l / Math.abs(l);
                        }
                        else
                        {
                            l = l * 0.5;
                        }
                        this.currentRot = this.currentRot + l;
                    }
                    else
                    {
                        this.currentRot = this.targetRot;
                    }
                }
                this.rot = this.currentRot;
                pan = this.skin.pano.getPan();
                npan = this.skin.pano.getPanNorth();
                if (this.skin.pano.wrapPan)
                {
                    while (pan > 180)
                    {
                        
                        pan = pan - 360;
                    }
                    while (pan < -180)
                    {
                        
                        pan = pan + 360;
                    }
                    while (npan > 180)
                    {
                        
                        npan = npan - 360;
                    }
                    while (npan < -180)
                    {
                        
                        npan = npan + 360;
                    }
                }
                tilt = this.skin.pano.getTilt();
                while (tilt > 180)
                {
                    
                    tilt = tilt - 360;
                }
                while (tilt < -180)
                {
                    
                    tilt = tilt + 360;
                }
                fov = this.skin.pano.getFov();
                if (this.dynamicText)
                {
                    tmpstr = this.replaceStringVariables(this.textString);
                    tmpstr = tmpstr.replace("$p", Math.floor(100 * this.skin.bytesProgress));
                    tmpstr = tmpstr.replace("$n", Math.floor(1000 * this.skin.bytesProgress) / 1000);
                    tmpstr = tmpstr.replace("$ap", Math.floor(10 * pan) / 10);
                    tmpstr = tmpstr.replace("$an", Math.floor(10 * npan) / 10);
                    tmpstr = tmpstr.replace("$at", Math.floor(10 * tilt) / 10);
                    tmpstr = tmpstr.replace("$af", Math.floor(10 * fov) / 10);
                    if (this.lastString != tmpstr)
                    {
                        this.lastString = tmpstr;
                        this.textField.htmlText = tmpstr;
                    }
                }
                else if (this.lastString != this.textString)
                {
                    this.lastString = this.textString;
                    this.textField.htmlText = this.textString;
                }
                var _loc_2:* = 0;
                var _loc_3:* = this.modifiers;
                while (_loc_3 in _loc_2)
                {
                    
                    sm = _loc_3[_loc_2];
                    val;
                    if (sm.src == "pan")
                    {
                        val = sm.factor * pan + sm.offset;
                    }
                    if (sm.src == "pannorth")
                    {
                        val = sm.factor * npan + sm.offset;
                    }
                    if (sm.src == "cospan")
                    {
                        val = Math.cos((pan * sm.factor + sm.offset) * Math.PI / 180);
                    }
                    if (sm.src == "tanpan")
                    {
                        val = Math.tan(pan / 2 * Math.PI / 180) * sm.factor + sm.offset;
                    }
                    if (sm.src == "tilt")
                    {
                        val = sm.factor * tilt + sm.offset;
                    }
                    if (sm.src == "costilt")
                    {
                        val = Math.cos((tilt * sm.factor + sm.offset) * Math.PI / 180);
                    }
                    if (sm.src == "tantilt")
                    {
                        val = Math.tan(tilt / 2 * Math.PI / 180) * sm.factor + sm.offset;
                    }
                    if (sm.src == "fov")
                    {
                        val = sm.factor * fov + sm.offset;
                    }
                    if (sm.src == "tanfov")
                    {
                        val = Math.tan(fov / 2 * Math.PI / 180) * sm.factor + sm.offset;
                    }
                    if (sm.src == "invtanfov")
                    {
                        val = 1 / Math.tan(fov / 2 * Math.PI / 180) * sm.factor + sm.offset;
                    }
                    if (sm.src == "loading")
                    {
                        val = sm.factor * this.skin.bytesProgress + sm.offset;
                    }
                    if (sm.src == "mousex")
                    {
                        val = this.skin.mouseX;
                    }
                    if (sm.src == "mousey")
                    {
                        val = this.skin.mouseY;
                    }
                    if (sm.type == "rotate")
                    {
                        this.rot = this.rot + (-val);
                        this.modify = true;
                    }
                    if (sm.type == "scalex")
                    {
                        this.sx = this.sx * val;
                        this.modify = true;
                    }
                    if (sm.type == "scaley")
                    {
                        this.sy = this.sy * val;
                        this.modify = true;
                    }
                    if (sm.type == "scale")
                    {
                        this.sx = this.sx * val;
                        this.sy = this.sy * val;
                        this.modify = true;
                    }
                    if (sm.type == "movex")
                    {
                        this.tx = this.tx + val;
                        this.modify = true;
                    }
                    if (sm.type == "movey")
                    {
                        this.ty = this.ty + val;
                        this.modify = true;
                    }
                }
                if (this.modify || moved)
                {
                    if (moved || this.lrot != this.rot || this.lsx != this.sx || this.lsy != this.sy || this.ltx != this.tx || this.lty != this.ty)
                    {
                        this.updatePosition();
                        if (this.textField && (this.lsx != this.sx || this.lsy != this.sy))
                        {
                            this.textField.display();
                        }
                        this.lrot = this.rot;
                        this.lsx = this.sx;
                        this.lsy = this.sy;
                        this.ltx = this.tx;
                        this.lty = this.ty;
                    }
                }
            }
            return;
        }// end function

    }
}
