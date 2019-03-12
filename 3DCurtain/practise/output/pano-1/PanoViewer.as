package 
{
    import PanoViewer.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    import flash.ui.*;

    public class PanoViewer extends GgViewer
    {
        public var CursorImageClass:Class;
        public var bmpVideo:BitmapData;
        public var busy:Boolean;
        public var dirty:Boolean;
        public var dirty2:int;
        public var dirtyMask:Boolean;
        public var mouseDown:Boolean;
        public var started:Boolean;
        public var completed:Boolean;
        protected var framecnt:Number;
        public var showfps:Boolean = false;
        public var fovMode:int = 0;
        protected var keyboardLocked:Boolean = false;
        protected var keyboardZoomLocked:Boolean = false;
        protected var mouseLocked:Boolean = false;
        protected var wheelLocked:Boolean = false;
        public var invertWheel:Boolean = false;
        public var speedWheel:Number = 1;
        public var invertControl:Boolean = false;
        public var fullscreenMenu:Boolean = true;
        public var alwaysScaleToFit:Boolean = true;
        protected var mdownt:Number;
        public var mdown:Point;
        public var mdownAngles:Point;
        public var mdownCAngles:Point;
        public var mdownPan:Number;
        public var mdownTilt:Number;
        protected var mcur:Point;
        protected var mtarget:Object;
        public var onRotate:Function;
        public var auto:AutoMove;
        protected var lastaction_dt:Number;
        public var bmpSmooth:Boolean;
        public var changeBmpSmooth:Boolean = false;
        public var changeStageQuality:Boolean = false;
        public var windowScaleIgnore:Boolean;
        public var sensitivity:Number;
        public var flagMassSimulation:Boolean;
        public var massSimCnt:int = 0;
        public var useMask:Boolean;
        public var key_down:Boolean = false;
        public var keyShiftDown:Boolean = false;
        public var keyCtrlDown:Boolean = false;
        public var keyAltDown:Boolean = false;
        public var lastkeycode:Number;
        public var lastkeyascii:Number;
        public var dPan:Number;
        public var dTilt:Number;
        public var dFov:Number;
        public var dA:Number;
        public var initMovClip:Boolean = true;
        protected var background:Shape;
        public var canv:MovieClip;
        public var canvOv:MovieClip;
        public var prevOverlay:Bitmap;
        protected var panomask:Shape;
        protected var panomaskOv:Shape;
        protected var prevmask:Shape;
        protected var lastMouseDown:Number;
        protected var cursor:Bitmap;
        protected var cursorData:BitmapData;
        public var useOwnCursor:Boolean = false;
        public var useOwnMoveCursor:Boolean = false;
        protected var oldCursorId:int = -1;
        public var stageMode:String = "stage";
        protected var isStopped:Boolean = false;
        public var showAboutPano2VR:Boolean;
        public var adContextMenuText:String;
        public var adContextMenuLink:String;
        protected var intBytesLoaded:int = 0;
        protected var intBytesTotal:int = 0;
        public var targetAlphaOverlay:Number = 1;
        public var targetAlphaOverlaySpeed:Number = 0.1;
        public var renderTile:RenderTile;
        public var isFlash10:Boolean = false;
        private var fpsText:TextField;
        private var fpscnt:int = 0;
        protected var lastFpsTime:Number = 0;
        public var fps:Number = 0;
        public var video:VideoPanoClass;
        protected var isNextPanorama:Boolean = false;
        protected var nextPanoLoader:Loader;
        protected var nextPanoPlayer:MovieClip;
        protected var nextPanoParameter:String;
        protected var nextPanoNodeId:String;
        protected var nextPanoAppDomain:ApplicationDomain;
        protected var nextPanoFlagInit:Boolean = false;
        protected var nextPanoFlagComplete:Boolean = false;
        protected var nextPanoMovePan:Number = 0;
        protected var nextPanoMoveTilt:Number = 0;
        protected var nextPanoMoveFov:Number = 70;
        protected var nextPanorama:Panorama;
        public var panorama:Panorama;
        public var bmpTile:Array;
        public var transitionEnabled:Boolean = false;
        public var transitionType:int = 0;
        public var transitionBlendTime:Number = 1;
        public var transitionZoomSpeed:Number = 2;
        public var transitionFov:Number = 5;
        public var transitionZoomIn:Boolean = true;
        public var transitionZoomOut:Boolean = true;
        public var transitionZoomOutLater:Boolean = true;
        public var transitionBlendColor:int = 8421504;
        protected var transitionBlendStartTime:Number = 0;
        protected var transitionFlag:Boolean;
        protected var trapMouseWheel:Boolean = true;
        protected var tourPanos:Array;
        protected var tourPanoIds:Array;
        public var startNode:String = "";
        public var onNodeChange:Function;

        public function PanoViewer()
        {
            var _loc_1:* = 0;
            this.CursorImageClass = PanoViewer_CursorImageClass;
            this.mdownCAngles = new Point();
            this.auto = new AutoMove();
            this.isFlash10 = Number(Capabilities.version.split(" ")[1].split(",")[0]) >= 10;
            this.framecnt = 0;
            this.showAboutPano2VR = true;
            this.adContextMenuText = "";
            this.adContextMenuLink = "";
            sounds = new GgSounds();
            sounds.viewer = this;
            this.fovMode = 0;
            imageRepos = new ImageRepository();
            imageReposGet = imageRepos.getImage;
            this.canv = new MovieClip();
            this.canvOv = new MovieClip();
            this.prevOverlay = new Bitmap(null, PixelSnapping.ALWAYS, false);
            this.background = new Shape();
            hsClip = new MovieClip();
            this.mdown = new Point();
            this.mdownAngles = new Point();
            this.mdown.x = mouseX;
            this.mdown.y = mouseY;
            this.mcur = new Point();
            this.mcur.x = mouseX;
            this.mcur.y = mouseY;
            this.mdownt = 0;
            this.mouseDown = false;
            this.dPan = 0;
            this.dTilt = 0;
            this.dFov = 0;
            this.bmpSmooth = true;
            enable_callback = true;
            this.completed = false;
            this.windowScaleIgnore = false;
            this.lastaction_dt = 0;
            this.sensitivity = 8;
            this.flagMassSimulation = true;
            this.useMask = true;
            this.dirty2 = 0;
            addEventListener(Event.ENTER_FRAME, this.init);
            this.renderTile = new RenderTile10();
            this.tourPanos = new Array();
            this.tourPanoIds = new Array();
            currentNodeId = "";
            return;
        }// end function

        public function init(event:Event) : void
        {
            var v:GgVector3d;
            var cf:Number;
            var k:Number;
            var event:* = event;
            removeEventListener(Event.ENTER_FRAME, this.init);
            this.started = false;
            this.updateBytesTotal();
            this.init_panorama();
            this.background.visible = false;
            addChild(this.background);
            addChild(this.canv);
            this.canvOv.visible = false;
            addChild(this.canvOv);
            this.prevOverlay.visible = false;
            addChild(this.prevOverlay);
            this.panomask = new Shape();
            addChild(this.panomask);
            this.prevmask = new Shape();
            addChild(this.prevmask);
            this.panomaskOv = new Shape();
            addChild(this.panomaskOv);
            hsMask = new Shape();
            addChild(hsMask);
            rect.width = windowWidth;
            rect.height = windowHeight;
            updateMargins();
            isInFocus = false;
            addEventListener(Event.ENTER_FRAME, this.doEnterFrame, false, 0, true);
            try
            {
                if (stage)
                {
                    stage.addEventListener(KeyboardEvent.KEY_DOWN, this.doKeyDown, false, 0, true);
                    stage.addEventListener(KeyboardEvent.KEY_UP, this.doKeyUp, false, 0, true);
                    stage.addEventListener(Event.RESIZE, this.doStageResize, false, 0, true);
                    stage.addEventListener(FullScreenEvent.FULL_SCREEN, this.doStageResize, false, 0, true);
                    stage.addEventListener(MouseEvent.MOUSE_DOWN, this.doMouseDown, false, 0, true);
                    stage.addEventListener(MouseEvent.MOUSE_UP, this.doMouseUp, false, 0, true);
                    stage.addEventListener(MouseEvent.MOUSE_MOVE, this.doMouseMove, false, 0, true);
                    stage.addEventListener(MouseEvent.MOUSE_WHEEL, this.doMouseWheel, false, 0, true);
                    stage.addEventListener(Event.DEACTIVATE, this.doDeactivate, false, 0, true);
                    stage.addEventListener(Event.MOUSE_LEAVE, this.doMouseLeave, false, 0, true);
                    if (this.trapMouseWheel)
                    {
                        MouseWheelTrap.setup(stage);
                    }
                }
                else
                {
                    addEventListener(KeyboardEvent.KEY_DOWN, this.doKeyDown, false, 0, true);
                    addEventListener(KeyboardEvent.KEY_UP, this.doKeyUp, false, 0, true);
                    addEventListener(MouseEvent.MOUSE_DOWN, this.doMouseDown, false, 0, true);
                    addEventListener(MouseEvent.MOUSE_UP, this.doMouseUp, false, 0, true);
                    addEventListener(MouseEvent.MOUSE_MOVE, this.doMouseMove, false, 0, true);
                    addEventListener(MouseEvent.MOUSE_WHEEL, this.doMouseWheel, false, 0, true);
                    addEventListener(Event.DEACTIVATE, this.doDeactivate, false, 0, true);
                }
            }
            catch (err:Error)
            {
            }
            addEventListener(MouseEvent.MOUSE_MOVE, this.redrawCursor, false, 0, true);
            this.canv.addEventListener(MouseEvent.MOUSE_OVER, this.doRollOver, false, 0, true);
            this.canv.addEventListener(MouseEvent.MOUSE_OUT, this.doRollOut, false, 0, true);
            this.canvOv.addEventListener(MouseEvent.MOUSE_OVER, this.doRollOver, false, 0, true);
            this.canvOv.addEventListener(MouseEvent.MOUSE_OUT, this.doRollOut, false, 0, true);
            try
            {
                if (stage && this.stageMode != "")
                {
                    if (this.stageMode == "no")
                    {
                        stage.scaleMode = StageScaleMode.NO_SCALE;
                    }
                    if (this.stageMode == "stage")
                    {
                        stage.scaleMode = StageScaleMode.NO_SCALE;
                        stage.align = StageAlign.TOP_LEFT;
                    }
                    if (this.stageMode == "noborder")
                    {
                        stage.scaleMode = StageScaleMode.NO_BORDER;
                    }
                    if (this.stageMode == "exact")
                    {
                        stage.scaleMode = StageScaleMode.EXACT_FIT;
                    }
                }
            }
            catch (err:Error)
            {
            }
            this.setMeshDensity(0);
            addChild(hotspots.addHotspotTextField());
            this.doStageResize(null);
            this.updateMask();
            if (this.showfps)
            {
                this.fpsText = new TextField();
                this.fpsText.x = 10;
                this.fpsText.y = 10;
                this.fpsText.htmlText = "<b>Text</b>";
                this.fpsText.autoSize = "left";
                this.fpsText.borderColor = 0;
                this.fpsText.backgroundColor = 16777215;
                this.fpsText.border = true;
                this.fpsText.background = true;
                addChild(this.fpsText);
            }
            if (debugText)
            {
                addChild(debugText);
            }
            this.cursor = new Bitmap();
            this.cursor.bitmapData = new BitmapData(32, 32, true);
            parent.addChild(this.cursor);
            this.cursor.addEventListener(MouseEvent.MOUSE_OVER, this.doRollOver, false, 0, true);
            this.cursor.addEventListener(MouseEvent.MOUSE_OUT, this.doRollOut, false, 0, true);
            this.cursor.visible = false;
            this.cursorData = new this.CursorImageClass().bitmapData;
            if (this.useOwnCursor)
            {
            }
            return;
        }// end function

        public function removeAllListener() : void
        {
            removeEventListener(Event.ENTER_FRAME, this.doEnterFrame);
            removeEventListener(MouseEvent.MOUSE_DOWN, this.doMouseDown);
            removeEventListener(MouseEvent.MOUSE_UP, this.doMouseUp);
            removeEventListener(MouseEvent.MOUSE_MOVE, this.doMouseMove);
            removeEventListener(MouseEvent.MOUSE_WHEEL, this.doMouseWheel);
            removeEventListener(KeyboardEvent.KEY_DOWN, this.doKeyDown);
            removeEventListener(KeyboardEvent.KEY_UP, this.doKeyUp);
            removeEventListener(Event.DEACTIVATE, this.doDeactivate);
            try
            {
                if (stage)
                {
                    stage.removeEventListener(Event.RESIZE, this.doStageResize);
                    stage.removeEventListener(FullScreenEvent.FULL_SCREEN, this.doStageResize);
                    stage.removeEventListener(Event.ENTER_FRAME, this.doEnterFrame);
                    stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.doMouseDown);
                    stage.removeEventListener(MouseEvent.MOUSE_UP, this.doMouseUp);
                    stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.doMouseMove);
                    stage.removeEventListener(MouseEvent.MOUSE_WHEEL, this.doMouseWheel);
                    stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.doKeyDown);
                    stage.removeEventListener(KeyboardEvent.KEY_UP, this.doKeyUp);
                    stage.removeEventListener(Event.DEACTIVATE, this.doDeactivate);
                    stage.removeEventListener(Event.MOUSE_LEAVE, this.doMouseLeave);
                }
            }
            catch (err:Error)
            {
            }
            removeEventListener(MouseEvent.MOUSE_MOVE, this.redrawCursor);
            this.canv.removeEventListener(MouseEvent.MOUSE_OVER, this.doRollOver);
            this.canv.removeEventListener(MouseEvent.MOUSE_OUT, this.doRollOut);
            this.canvOv.removeEventListener(MouseEvent.MOUSE_OVER, this.doRollOver);
            this.canvOv.removeEventListener(MouseEvent.MOUSE_OUT, this.doRollOut);
            this.cursor.removeEventListener(MouseEvent.MOUSE_OVER, this.doRollOver);
            this.cursor.removeEventListener(MouseEvent.MOUSE_OUT, this.doRollOut);
            return;
        }// end function

        public function doRollOver(event:MouseEvent) : void
        {
            isInFocus = true;
            return;
        }// end function

        public function doRollOut(event:MouseEvent) : void
        {
            isInFocus = false;
            this.hideCursor();
            return;
        }// end function

        public function hideCursor() : void
        {
            if (this.useOwnCursor || this.useOwnMoveCursor)
            {
                if (this.cursor.visible)
                {
                    this.cursor.visible = false;
                    Mouse.show();
                }
            }
            return;
        }// end function

        public function doMouseLeave(event:Event) : void
        {
            isInFocus = false;
            this.hideCursor();
            return;
        }// end function

        public function doDeactivate(event:Event) : void
        {
            isInFocus = false;
            if (this.mouseDown)
            {
                this.doMouseUp(event);
            }
            return;
        }// end function

        override public function cleanup() : void
        {
            try
            {
                parent.removeChild(this.cursor);
            }
            catch (error:Error)
            {
            }
            this.removeAllListener();
            return;
        }// end function

        override public function redrawCursor(event:Event) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = NaN;
            var _loc_5:* = 0;
            if (event != null)
            {
                if (event.type == MouseEvent.MOUSE_MOVE)
                {
                    isInFocus = true;
                }
            }
            if (this.useOwnMoveCursor)
            {
                if ((this.useOwnCursor || this.mouseDown) && isInFocus)
                {
                    if (!this.cursor.visible)
                    {
                        this.cursor.visible = true;
                        Mouse.hide();
                    }
                    this.cursor.x = root.mouseX - 16;
                    this.cursor.y = root.mouseY - 16;
                    _loc_2 = this.mdown.x - root.mouseX;
                    _loc_3 = this.mdown.y - root.mouseY;
                    _loc_4 = Math.abs(_loc_2) + Math.abs(_loc_3);
                    _loc_5 = 9;
                    if (this.mouseDown)
                    {
                        if (_loc_4 < 2)
                        {
                            _loc_5 = 4;
                        }
                        else
                        {
                            if (_loc_2 > 2 * Math.abs(_loc_3))
                            {
                                _loc_5 = 1;
                            }
                            if (-_loc_2 > 2 * Math.abs(_loc_3))
                            {
                                _loc_5 = 7;
                            }
                            if (_loc_3 > 2 * Math.abs(_loc_2))
                            {
                                _loc_5 = 3;
                            }
                            if (-_loc_3 > 2 * Math.abs(_loc_2))
                            {
                                _loc_5 = 5;
                            }
                            if (_loc_5 == 9)
                            {
                                if (_loc_2 > 0 && _loc_3 > 0)
                                {
                                    _loc_5 = 0;
                                }
                                if (_loc_2 < 0 && _loc_3 > 0)
                                {
                                    _loc_5 = 6;
                                }
                                if (_loc_2 > 0 && _loc_3 < 0)
                                {
                                    _loc_5 = 2;
                                }
                                if (_loc_2 < 0 && _loc_3 < 0)
                                {
                                    _loc_5 = 8;
                                }
                            }
                        }
                    }
                    else if (hotspots.currentHotspot != null)
                    {
                        if (hotspots.currentHotspot.url != "")
                        {
                            if (hotspots.currentHotspot.url.substr(hotspots.currentHotspot.url.length - 4, 4) == ".swf" || hotspots.currentHotspot.url.substr(hotspots.currentHotspot.url.length - 4, 4) == ".xml" || hotspots.currentHotspot.url.charAt(0) == "#" || hotspots.currentHotspot.url.charAt(0) == "{")
                            {
                                _loc_5 = 11;
                            }
                            else
                            {
                                _loc_5 = 10;
                            }
                        }
                        else
                        {
                            _loc_5 = 12;
                        }
                    }
                    if (_loc_5 != this.oldCursorId)
                    {
                        this.oldCursorId = _loc_5;
                        this.cursor.bitmapData.copyPixels(this.cursorData, new Rectangle(int(_loc_5 / 3) * 32, _loc_5 % 3 * 32, 32, 32), new Point(0, 0), null, null, false);
                    }
                }
                else if (this.cursor.visible)
                {
                    Mouse.show();
                    this.cursor.visible = false;
                }
            }
            return;
        }// end function

        protected function updateMask() : void
        {
            if (this.useMask && this.started)
            {
                this.panomask.graphics.clear();
                this.panomask.graphics.beginFill(16711680);
                this.panomask.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
                this.panomask.graphics.endFill();
                this.prevmask.graphics.clear();
                this.prevmask.graphics.beginFill(16711680);
                this.prevmask.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
                this.prevmask.graphics.endFill();
                this.panomaskOv.graphics.clear();
                this.panomaskOv.graphics.beginFill(16711680);
                this.panomaskOv.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
                this.panomaskOv.graphics.endFill();
                hsMask.graphics.clear();
                hsMask.graphics.beginFill(16711680);
                hsMask.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
                hsMask.graphics.endFill();
                this.canv.mask = this.panomask;
                this.canvOv.mask = this.panomaskOv;
                hsClip.mask = hsMask;
                this.prevOverlay.mask = this.prevmask;
            }
            else
            {
                this.canv.mask = null;
                this.canvOv.mask = null;
                hsClip.mask = null;
                this.prevOverlay.mask = null;
            }
            this.canv.x = rect.x;
            this.canv.y = rect.y;
            this.canvOv.x = rect.x;
            this.canvOv.y = rect.y;
            hsClip.x = rect.x;
            hsClip.y = rect.y;
            this.prevOverlay.x = rect.x;
            this.prevOverlay.y = rect.y;
            return;
        }// end function

        public function setWindowSize(param1:Number, param2:Number) : void
        {
            windowWidth = param1;
            windowHeight = param2;
            rect.width = windowWidth - marginLeft - marginRight;
            rect.height = windowHeight - marginTop - marginBottom;
            this.windowScaleIgnore = param1 > 0;
            this.dirtyMask = true;
            return;
        }// end function

        public function setWindowPos(param1:Number, param2:Number) : void
        {
            rect.left = param1 + marginLeft;
            rect.top = param2 + marginTop;
            rect.width = windowWidth - marginLeft - marginRight;
            rect.height = windowHeight - marginTop - marginBottom;
            this.dirtyMask = true;
            return;
        }// end function

        override public function update() : void
        {
            this.dirty = true;
            this.dirtyMask = true;
            return;
        }// end function

        override public function update2() : void
        {
            this.dirty = true;
            this.dirty2 = 2;
            this.dirtyMask = true;
            return;
        }// end function

        public function doStageResize(event:Event) : void
        {
            if (stage)
            {
                if (!this.windowScaleIgnore)
                {
                    rect.left = marginLeft;
                    rect.top = marginTop;
                    windowWidth = stage.stageWidth;
                    windowHeight = stage.stageHeight;
                    rect.width = windowWidth - marginLeft - marginRight;
                    rect.height = windowHeight - marginTop - marginBottom;
                    this.update2();
                    this.checkLimits();
                }
            }
            return;
        }// end function

        public function doKeyDown(event:KeyboardEvent) : void
        {
            if (!this.keyboardLocked)
            {
                this.lastkeycode = event.keyCode;
                this.lastkeyascii = event.charCode;
                this.keyShiftDown = event.shiftKey;
                this.keyCtrlDown = event.ctrlKey;
                this.keyAltDown = event.altKey;
                if (event.shiftKey)
                {
                    if (event.keyCode == 73)
                    {
                        this.showfps = !this.showfps;
                        if (!this.showfps)
                        {
                        }
                    }
                }
                this.key_down = event.keyCode != 32;
                this.dirty = true;
            }
            return;
        }// end function

        public function doKeyUp(event:KeyboardEvent) : void
        {
            this.key_down = false;
            this.dirty = true;
            this.keyShiftDown = event.shiftKey;
            this.keyCtrlDown = event.ctrlKey;
            this.keyAltDown = event.altKey;
            return;
        }// end function

        public function resetlastaction() : void
        {
            var _loc_1:* = new Date();
            this.lastaction_dt = _loc_1.getTime();
            this.massSimCnt = 100;
            return;
        }// end function

        public function init_faces() : void
        {
            this.loadBitmaps();
            this.started = true;
            this.dirtyMask = true;
            this.dirty = true;
            return;
        }// end function

        public function decodeStrip(param1:BitmapData) : void
        {
            return;
        }// end function

        protected function loadBitmaps() : void
        {
            this.panorama.loadBitmaps();
            return;
        }// end function

        public function init_panorama() : void
        {
            this.completed = false;
            if (this.panorama)
            {
                this.panorama.init();
            }
            this.setMeshDensity(0);
            return;
        }// end function

        public function doPaint() : void
        {
            try
            {
                this.checkLimits();
                var _loc_2:* = this;
                var _loc_3:* = this.framecnt + 1;
                _loc_2.framecnt = _loc_3;
                this.panorama.paint(1);
            }
            catch (error:Error)
            {
            }
            if (this.dirtyMask)
            {
                this.dirtyMask = false;
                this.updateMask();
            }
            return;
        }// end function

        override public function changeViewerMode(param1:int) : void
        {
            if (param1 == 0)
            {
                this.invertControl = false;
            }
            if (param1 == 1)
            {
                this.invertControl = true;
            }
            if (param1 == 2)
            {
                this.invertControl = !this.invertControl;
            }
            return;
        }// end function

        override public function changePan(param1:Number, param2:Boolean = false, param3:Boolean = false) : void
        {
            if (!isNaN(param1))
            {
                this.setPan(this.panorama.pan.cur + param1);
                if (param2)
                {
                    this.dPan = param1;
                }
                if (param3)
                {
                    this.resetlastaction();
                    this.auto.pause();
                }
            }
            return;
        }// end function

        override public function changeTilt(param1:Number, param2:Boolean = false, param3:Boolean = false) : void
        {
            if (!isNaN(param1))
            {
                this.setTilt(this.panorama.tilt.cur + param1);
                if (param2)
                {
                    this.dTilt = param1;
                }
                if (param3)
                {
                    this.resetlastaction();
                    this.auto.pause();
                }
            }
            return;
        }// end function

        override public function changeFov(param1:Number, param2:Boolean = false, param3:Boolean = false) : void
        {
            if (!isNaN(param1))
            {
                this.setFov(this.panorama.fov.cur + param1);
                if (param2)
                {
                    this.dFov = param1;
                }
                if (param3)
                {
                    this.resetlastaction();
                    this.auto.pause();
                }
            }
            return;
        }// end function

        override public function changeFovLog(param1:Number, param2:Boolean = false, param3:Boolean = false) : void
        {
            var _loc_4:* = NaN;
            if (!isNaN(param1))
            {
                _loc_4 = param1 / 90 * Math.cos(this.panorama.fov.cur * Math.PI / 360);
                _loc_4 = Math.exp(_loc_4);
                this.setFov(this.panorama.fov.cur * _loc_4);
                if (param2)
                {
                    this.dFov = param1;
                }
                if (param3)
                {
                    this.resetlastaction();
                    this.auto.pause();
                }
            }
            return;
        }// end function

        override public function setPan(param1:Number) : void
        {
            if (!isNaN(param1))
            {
                this.dirty = this.dirty || this.panorama.pan.cur != param1;
                this.panorama.pan.cur = param1;
            }
            this.checkLimits();
            return;
        }// end function

        override public function setTilt(param1:Number) : void
        {
            if (!isNaN(param1))
            {
                this.dirty = this.dirty || this.panorama.tilt.cur != param1;
                this.panorama.tilt.cur = param1;
            }
            this.checkLimits();
            return;
        }// end function

        override public function setFov(param1:Number) : void
        {
            if (!isNaN(param1))
            {
                if (this.panorama.fov.cur != param1)
                {
                    this.dirty = true;
                    this.panorama.fov.cur = param1;
                }
            }
            this.checkLimits();
            return;
        }// end function

        override public function getPan() : Number
        {
            if (this.panorama)
            {
                return this.panorama.pan.cur;
            }
            return 0;
        }// end function

        override public function getPanNorth() : Number
        {
            if (this.panorama)
            {
                return this.panorama.pan.cur - northOffset;
            }
            return 0;
        }// end function

        override public function getTilt() : Number
        {
            if (this.panorama)
            {
                return this.panorama.tilt.cur;
            }
            return 0;
        }// end function

        override public function getFov() : Number
        {
            if (this.panorama)
            {
                return this.panorama.fov.cur;
            }
            return 70;
        }// end function

        override public function getPanDefault() : Number
        {
            if (this.panorama)
            {
                return this.panorama.pan.def;
            }
            return 0;
        }// end function

        override public function getTiltDefault() : Number
        {
            if (this.panorama)
            {
                return this.panorama.tilt.def;
            }
            return 0;
        }// end function

        override public function getFovDefault() : Number
        {
            if (this.panorama)
            {
                return this.panorama.fov.def;
            }
            return 70;
        }// end function

        public function setPanLimits(param1:Number, param2:Number) : void
        {
            if (this.panorama)
            {
                this.panorama.pan.min = param1;
                this.panorama.pan.max = param2;
            }
            this.checkLimits();
            return;
        }// end function

        public function setTiltLimits(param1:Number, param2:Number) : void
        {
            if (this.panorama)
            {
                this.panorama.tilt.min = param1;
                this.panorama.tilt.max = param2;
            }
            this.checkLimits();
            return;
        }// end function

        public function setFovLimits(param1:Number, param2:Number) : void
        {
            if (this.panorama)
            {
                this.panorama.fov.min = param1;
                this.panorama.fov.max = param2;
            }
            this.checkLimits();
            return;
        }// end function

        override public function startAutorotate(param1:Number = 0, param2:Number = 0, param3:Number = -1) : void
        {
            this.auto.start(param1, param2, param3);
            return;
        }// end function

        override public function stopAutorotate() : void
        {
            this.auto.stop();
            return;
        }// end function

        override public function toggleAutorotate() : void
        {
            this.auto.toggle();
            return;
        }// end function

        override public function isComplete() : Boolean
        {
            return this.completed;
        }// end function

        override public function moveTo(param1:Number, param2:Number, param3:Number = 0, param4:Number = 0.4, param5:Boolean = true, param6:Boolean = true) : void
        {
            if (this.panorama)
            {
                this.panorama.pan.dest = param1;
                this.panorama.tilt.dest = param2;
                if (param3 == 0)
                {
                    param3 = this.panorama.fov.cur;
                }
                if (!(this.panorama is PanoramaFlat))
                {
                    if (wrapPan)
                    {
                        while (this.panorama.pan.dest - this.panorama.pan.cur > 180)
                        {
                            
                            this.panorama.pan.dest = this.panorama.pan.dest - 360;
                        }
                        while (this.panorama.pan.dest - this.panorama.pan.cur < -180)
                        {
                            
                            this.panorama.pan.dest = this.panorama.pan.dest + 360;
                        }
                    }
                    else
                    {
                        if (this.panorama.pan.dest > this.panorama.pan.max)
                        {
                            this.panorama.pan.dest = this.panorama.pan.max;
                        }
                        if (this.panorama.pan.dest < this.panorama.pan.min)
                        {
                            this.panorama.pan.dest = this.panorama.pan.min;
                        }
                    }
                    if (this.panorama.tilt.dest > this.panorama.tilt.max)
                    {
                        this.panorama.tilt.dest = this.panorama.tilt.max;
                    }
                    if (this.panorama.tilt.dest < this.panorama.tilt.min)
                    {
                        this.panorama.tilt.dest = this.panorama.tilt.min;
                    }
                }
                this.panorama.fov.dest = param3;
                if (this.panorama.fov.dest > this.panorama.fov.max)
                {
                    this.panorama.fov.dest = this.panorama.fov.max;
                }
                if (this.panorama.fov.dest < this.panorama.fov.min)
                {
                    this.panorama.fov.dest = this.panorama.fov.min;
                }
                if (isNaN(param4) || param4 <= 0)
                {
                    this.auto.moveSpeed = 0.4;
                }
                else
                {
                    this.auto.moveSpeed = param4;
                }
                this.auto.rotate_active = false;
                this.auto.moveTo = true;
                this.auto.easeIn = param5;
                this.auto.easeOut = param6;
            }
            return;
        }// end function

        public function getVFov() : Number
        {
            return this.panorama.getVFov();
        }// end function

        public function getHFov() : Number
        {
            var _loc_1:* = this.panorama.getVFov() / 2;
            return 2 * Math.atan(rect.width / rect.height * Math.tan(_loc_1 * Math.PI / 180)) * 180 / Math.PI;
        }// end function

        public function setVFov(param1:Number) : void
        {
            if (this.panorama)
            {
                this.panorama.setVFov(param1);
            }
            return;
        }// end function

        protected function checkLimits() : void
        {
            if (this.auto.forcedMove)
            {
                return;
            }
            if (this.panorama)
            {
                this.panorama.checkLimits();
            }
            return;
        }// end function

        public function setMeshDensity(param1:Number) : void
        {
            if (this.panorama)
            {
                this.panorama.setMeshDensity(param1);
            }
            return;
        }// end function

        protected function updateFps() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = NaN;
            var _loc_3:* = this;
            var _loc_4:* = this.fpscnt + 1;
            _loc_3.fpscnt = _loc_4;
            if (this.fpscnt >= 10)
            {
                this.fpscnt = 0;
                _loc_1 = new Date();
                _loc_2 = _loc_1.getTime();
                this.fps = 10000 / (_loc_2 - this.lastFpsTime + 1e-010);
                this.lastFpsTime = _loc_2;
                if (this.showfps)
                {
                    this.fpsText.text = this.fps.toFixed(1) + " fps";
                }
            }
            return;
        }// end function

        protected function checkCompleted() : void
        {
            var _loc_1:* = MovieClip(parent);
            if (!this.completed)
            {
                this.updateBytesTotal();
                this.init_faces();
                if (_loc_1 != null && this.intBytesTotal == this.intBytesLoaded && (_loc_1.currentFrame + 1) < _loc_1.totalFrames)
                {
                    _loc_1.gotoAndPlay((_loc_1.totalFrames - 1));
                }
                if (this.nextPanoPlayer != null && this.intBytesTotal == this.intBytesLoaded && (this.nextPanoPlayer.currentFrame + 1) < this.nextPanoPlayer.totalFrames)
                {
                    this.nextPanoPlayer.gotoAndPlay((this.nextPanoPlayer.totalFrames - 1));
                }
            }
            if (!this.isStopped && _loc_1 != null)
            {
                if (_loc_1.currentFrame >= 1)
                {
                }
                if (_loc_1.currentFrame == _loc_1.totalFrames && this.completed)
                {
                    this.isStopped = true;
                    _loc_1.stop();
                }
            }
            return;
        }// end function

        protected function handleKeyboard() : void
        {
            var _loc_1:* = NaN;
            if (this.key_down)
            {
                this.resetlastaction();
                this.auto.pause();
                this.dPan = 0;
                this.dTilt = 0;
                this.dFov = 0;
                if (this.lastkeycode == 39)
                {
                    this.dPan = -1;
                }
                if (this.lastkeycode == 37)
                {
                    this.dPan = 1;
                }
                if (this.lastkeycode == 40)
                {
                    this.dTilt = -1;
                }
                if (this.lastkeycode == 38)
                {
                    this.dTilt = 1;
                }
                if (this.lastkeyascii == 43)
                {
                    this.dFov = -1;
                }
                if (this.lastkeyascii == 45)
                {
                    this.dFov = 1;
                }
                if (!this.keyboardZoomLocked)
                {
                    if (this.keyCtrlDown)
                    {
                        this.dFov = 1;
                    }
                    if (this.keyShiftDown)
                    {
                        this.dFov = -1;
                    }
                }
                _loc_1 = this.getVFov() / 90;
                this.dPan = this.dPan * _loc_1;
                this.dTilt = this.dTilt * _loc_1;
                this.changeTilt(this.dTilt);
                this.changePan(this.dPan);
                this.changeFovLog(this.dFov);
                this.dA = this.dPan * this.dPan + this.dTilt * this.dTilt + this.dFov * this.dFov;
                this.setMeshDensity(this.dA);
            }
            return;
        }// end function

        protected function handleMouse() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            if (this.mouseDown)
            {
                this.resetlastaction();
                this.auto.pause();
                _loc_1 = new Date();
                if (this.invertControl)
                {
                    _loc_2 = this.getPositionAngles(this.mcur.x, this.mcur.y);
                    this.dPan = this.mdownCAngles.x - this.panorama.pan.cur - (this.mdownAngles.x - _loc_2.x);
                    this.dTilt = this.mdownCAngles.y - this.panorama.tilt.cur - (this.mdownAngles.y - _loc_2.y);
                }
                else
                {
                    this.mdownt = 2 * this.sensitivity * 1e-005;
                    this.dTilt = (-(this.mcur.y - this.mdown.y)) * this.mdownt * this.panorama.fov.cur;
                    this.dPan = (-(this.mcur.x - this.mdown.x)) * this.mdownt * this.panorama.fov.cur;
                }
                this.dFov = 0;
                this.dA = this.dPan * this.dPan + this.dTilt * this.dTilt + this.dFov * this.dFov;
                this.setMeshDensity(this.dA);
                this.changeTilt(this.dTilt);
                this.changePan(this.dPan);
                this.dirty = this.dA != 0;
            }
            return;
        }// end function

        protected function handleAutorotation() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = NaN;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            if (this.auto.rotate_enabled && !this.auto.rotate_active)
            {
                _loc_1 = new Date();
                if ((_loc_1.getTime() - this.lastaction_dt) / 1000 > this.auto.rotate_timeout)
                {
                    if ((!this.auto.rotate_onlyinfocus || isInFocus) && (!this.auto.rotate_onlyloaded || this.intBytesTotal == this.intBytesLoaded))
                    {
                        this.auto.activate();
                    }
                }
            }
            if (this.auto.rotate_active && this.auto.rotate_onlyinfocus && !isInFocus)
            {
                this.auto.rotate_active = false;
            }
            if (this.auto.rotate_active || this.auto.moveTo)
            {
                if (this.auto.moveTo)
                {
                    this.dTilt = this.panorama.tilt.dest - this.panorama.tilt.cur;
                    this.dFov = this.panorama.fov.dest - this.panorama.fov.cur;
                    this.dPan = this.panorama.pan.dest - this.panorama.pan.cur;
                    _loc_2 = Math.sqrt(this.dPan * this.dPan + this.dTilt * this.dTilt + this.dFov * this.dFov);
                    if (_loc_2 > this.panorama.fov.cur / 1000)
                    {
                        if (_loc_2 > 5 * this.auto.moveSpeed || !this.auto.easeOut)
                        {
                            this.dA = this.auto.moveSpeed;
                            if (this.auto.easeIn)
                            {
                                this.dA = this.auto.currentSpeed * 0.95 + this.dA * 0.05;
                            }
                            if (this.dA > _loc_2)
                            {
                                this.dA = _loc_2;
                            }
                        }
                        else
                        {
                            this.dA = _loc_2 * 0.2;
                        }
                        this.auto.currentSpeed = this.dA;
                        this.resetlastaction();
                    }
                    else
                    {
                        this.dA = _loc_2;
                        if (_loc_2 == 0)
                        {
                            _loc_2 = 1;
                        }
                        this.auto.forcedMove = false;
                        this.auto.pause();
                    }
                    this.dPan = this.dPan / _loc_2 * this.dA;
                    this.dTilt = this.dTilt / _loc_2 * this.dA;
                    this.dFov = this.dFov / _loc_2 * this.dA;
                }
                else
                {
                    this.dTilt = this.auto.rotate_tilt_force * -this.panorama.tilt.cur / 100;
                    this.dFov = this.auto.rotate_tilt_force * (this.panorama.fov.def - this.panorama.fov.cur) / 100;
                    this.dPan = this.dPan * 0.95 + (-this.auto.rotate_pan) * 0.05;
                    if (this.auto.node_timeout > 0 && currentNodeId != "" && this.tourPanoIds.length > 1)
                    {
                        _loc_3 = new Date();
                        if (_loc_3.getTime() - this.auto.rotate_start > this.auto.node_timeout * 1000)
                        {
                            _loc_5 = 1000;
                            do
                            {
                                
                                _loc_4 = this.tourPanoIds[Math.floor(Math.random() * this.tourPanoIds.length)];
                            }while (_loc_5-- && _loc_4 == currentNodeId)
                            this.auto.rotate_start = _loc_3.getTime();
                            this.openNext("{" + _loc_4 + "}");
                        }
                    }
                }
                this.dA = this.dPan * this.dPan + this.dTilt * this.dTilt + this.dFov * this.dFov;
                this.setMeshDensity(this.dA);
                this.changeTilt(this.dTilt);
                this.changePan(this.dPan);
                this.changeFovLog(this.dFov);
                this.dirty = true;
            }
            return;
        }// end function

        protected function massSimulation() : void
        {
            if (!this.key_down && !this.mouseDown && !this.auto.rotate_active && !this.auto.moveTo)
            {
                if (this.flagMassSimulation)
                {
                    this.dTilt = this.dTilt * 0.9;
                    this.dPan = this.dPan * 0.9;
                    this.dFov = this.dFov * 0.9;
                    this.dA = this.dPan * this.dPan + this.dTilt * this.dTilt + this.dFov * this.dFov;
                }
                else
                {
                    this.dA = 0;
                    this.massSimCnt = 0;
                }
                if (this.massSimCnt > 0)
                {
                    var _loc_1:* = this;
                    var _loc_2:* = this.massSimCnt - 1;
                    _loc_1.massSimCnt = _loc_2;
                }
                if (this.massSimCnt == 0)
                {
                    this.setMeshDensity(0);
                    if (this.dA > 0)
                    {
                        this.dirty = true;
                    }
                    this.dTilt = 0;
                    this.dPan = 0;
                    this.dFov = 0;
                }
                else
                {
                    this.setMeshDensity(this.dA);
                    this.changeTilt(this.dTilt);
                    this.changePan(this.dPan);
                    this.changeFovLog(this.dFov);
                    this.dirty = true;
                }
            }
            else
            {
                this.massSimCnt = 100;
            }
            return;
        }// end function

        protected function adaptQuality() : void
        {
            if (this.dA < 0.01)
            {
                if (this.changeBmpSmooth)
                {
                    this.bmpSmooth = true;
                }
                if (this.changeStageQuality)
                {
                    if (stage)
                    {
                        stage.quality = "HIGH";
                    }
                }
            }
            else
            {
                if (this.changeBmpSmooth)
                {
                    this.bmpSmooth = false;
                }
                if (this.changeStageQuality)
                {
                    if (stage)
                    {
                        stage.quality = "LOW";
                    }
                }
            }
            return;
        }// end function

        public function doEnterFrame(event:Event) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = NaN;
            this.checkCompleted();
            this.panorama.doEnterFrame();
            if (this.started)
            {
                this.updateFps();
                if (this.intBytesLoaded != this.intBytesTotal)
                {
                    this.updateBytesLoaded();
                }
                this.dA = 0;
                if (this.auto.forcedMove)
                {
                    this.handleAutorotation();
                }
                else if (this.nextPanoFlagInit)
                {
                    this.nextPanoFlagInit = false;
                    this.nextPanoDoInit();
                    this.panorama.enableDecodeLimit = true;
                    if (this.transitionEnabled && this.transitionBlendTime > 0)
                    {
                        if (debugText)
                        {
                            debugText.htmlText = debugText.htmlText + this.transitionBlendTime;
                        }
                        this.prevOverlay.bitmapData = new BitmapData(this.canv.width, this.canv.height, false);
                        _loc_2 = new Matrix();
                        _loc_2.translate(-this.canv.x, -this.canv.y);
                        this.prevOverlay.bitmapData.draw(this, _loc_2);
                        if (this.transitionType == 0)
                        {
                            this.prevOverlay.alpha = 1;
                        }
                        if (this.transitionType == 1)
                        {
                            this.prevOverlay.alpha = 0;
                            this.transitionFlag = true;
                        }
                        this.prevOverlay.visible = true;
                        _loc_3 = new Date();
                        this.transitionBlendStartTime = _loc_3.getTime();
                        this.background.graphics.beginFill(this.transitionBlendColor);
                        this.background.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
                        this.background.visible = true;
                    }
                    if (this.transitionEnabled && this.transitionZoomOut)
                    {
                        if (!this.transitionZoomOutLater)
                        {
                            this.moveTo(this.panorama.pan.cur, this.panorama.tilt.cur, this.panorama.fov.cur, this.transitionZoomSpeed, true);
                            this.auto.forcedMove = true;
                        }
                        else
                        {
                            this.panorama.pan.dest = this.panorama.pan.cur;
                            this.panorama.tilt.dest = this.panorama.tilt.cur;
                            this.panorama.fov.dest = this.panorama.fov.cur;
                        }
                        this.panorama.fov.cur = this.transitionFov;
                    }
                }
                else
                {
                    this.handleMouse();
                    this.handleKeyboard();
                    this.handleAutorotation();
                    this.massSimulation();
                }
                this.adaptQuality();
                if (this.nextPanoFlagComplete)
                {
                    this.nextPanoFlagComplete = false;
                }
                if (this.transitionEnabled && this.transitionBlendTime > 0)
                {
                    if (this.prevOverlay.visible)
                    {
                        _loc_4 = new Date();
                        _loc_5 = (_loc_4.getTime() - this.transitionBlendStartTime) / (this.transitionBlendTime * 1000);
                        if (_loc_5 < 1)
                        {
                            if (this.transitionType == 0)
                            {
                                this.prevOverlay.alpha = 1 - _loc_5;
                                hsClip.alpha = _loc_5;
                            }
                            if (this.transitionType == 1)
                            {
                                if (_loc_5 < 0.5)
                                {
                                    this.prevOverlay.alpha = 1 - 2 * _loc_5;
                                    this.canv.alpha = 0;
                                    hsClip.alpha = 0;
                                }
                                else
                                {
                                    if (this.transitionFlag)
                                    {
                                        this.transitionFlag = false;
                                        this.prevOverlay.bitmapData = new BitmapData(this.canv.width, this.canv.height, false, this.transitionBlendColor);
                                    }
                                    this.prevOverlay.alpha = 2 * (1 - _loc_5);
                                    this.canv.alpha = 1;
                                    hsClip.alpha = 2 * (_loc_5 - 0.5);
                                }
                            }
                        }
                        else
                        {
                            this.prevOverlay.visible = false;
                            this.canv.alpha = 1;
                            hsClip.alpha = 1;
                            this.background.visible = false;
                            if (this.transitionZoomOut)
                            {
                                if (this.transitionZoomOutLater)
                                {
                                    this.moveTo(this.panorama.pan.dest, this.panorama.tilt.dest, this.panorama.fov.dest, this.transitionZoomSpeed, true);
                                    this.auto.forcedMove = true;
                                }
                            }
                        }
                    }
                }
                if (this.dirty || this.dirty2 > 0)
                {
                    if (this.dirty2 > 0)
                    {
                        var _loc_6:* = this;
                        var _loc_7:* = this.dirty2 - 1;
                        _loc_6.dirty2 = _loc_7;
                        this.dirty = true;
                    }
                    else
                    {
                        this.dirty = false;
                    }
                    this.doPaint();
                }
                if (this.panorama.hasHotspots)
                {
                    this.checkHotspots(this.mcur.x, this.mcur.y);
                }
                else
                {
                    hotspots.currentHotspotId = 0;
                }
            }
            if (sounds != null)
            {
                sounds.currentPan = this.panorama.pan.cur;
                sounds.currentTilt = this.panorama.tilt.cur;
                sounds.currentFov = this.panorama.fov.cur;
            }
            return;
        }// end function

        public function doMouseDown(event:MouseEvent) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = NaN;
            this.mdown.x = event.stageX;
            this.mdown.y = event.stageY;
            this.mdown = globalToLocal(this.mdown);
            this.mcur.x = this.mdown.x;
            this.mcur.y = this.mdown.y;
            this.mdownAngles = this.getPositionAngles(this.mdown.x, this.mdown.y);
            this.mdownCAngles.x = this.panorama.pan.cur;
            this.mdownCAngles.y = this.panorama.tilt.cur;
            var _loc_2:* = this.getPositionVector(this.mdown.x, this.mdown.y);
            this.mdownPan = _loc_2.asPan();
            this.mdownTilt = _loc_2.asTilt();
            this.mtarget = event.target;
            if (!this.mouseLocked && this.isCanvas(this.mtarget))
            {
                if (!this.useOwnCursor && this.useOwnMoveCursor)
                {
                    Mouse.hide();
                    this.cursor.visible = true;
                    this.redrawCursor(event);
                }
                _loc_3 = new Date();
                _loc_4 = _loc_3.getTime();
                if (_loc_4 - this.lastMouseDown < 500)
                {
                }
                this.lastMouseDown = _loc_4;
                if (isInFocus)
                {
                    this.mouseDown = true;
                    this.auto.pause();
                }
                if (this.useOwnCursor)
                {
                    this.redrawCursor(event);
                }
            }
            return;
        }// end function

        public function doMouseWheel(event:MouseEvent) : void
        {
            var _loc_2:* = NaN;
            if (isInFocus)
            {
                if (!this.lockedWheel() && !this.mouseLocked)
                {
                    _loc_2 = Math.abs(event.delta / 4) * this.speedWheel;
                    if (this.invertWheel && event.delta < 0 || !this.invertWheel && event.delta > 0)
                    {
                        this.changeFovLog(_loc_2, true);
                    }
                    else
                    {
                        this.changeFovLog(-_loc_2, true);
                    }
                    this.massSimCnt = 100;
                    this.auto.pause();
                    this.dirty2 = 2;
                    this.resetlastaction();
                    event.stopImmediatePropagation();
                    event.preventDefault();
                }
            }
            return;
        }// end function

        public function doMouseMove(event:MouseEvent) : void
        {
            this.mcur.x = event.stageX;
            this.mcur.y = event.stageY;
            this.mcur = globalToLocal(this.mcur);
            this.mtarget = event.target;
            return;
        }// end function

        public function doMouseUp(event:Event) : void
        {
            var _loc_3:* = NaN;
            if (!this.useOwnCursor && this.useOwnMoveCursor)
            {
                Mouse.show();
                this.cursor.visible = false;
            }
            if (this.mouseDown)
            {
                this.mouseDown = false;
                this.dirty = true;
            }
            var _loc_2:* = new Date();
            _loc_3 = _loc_2.getTime();
            if (_loc_3 - this.lastMouseDown < 500 && Math.abs(this.mdown.x - this.mcur.x) < 10 && Math.abs(this.mdown.y - this.mcur.y) < 10)
            {
                doMouseClick();
            }
            if (this.useOwnCursor)
            {
                this.redrawCursor(event);
            }
            return;
        }// end function

        public function doMouseDoubleClick() : void
        {
            return;
        }// end function

        override public function addHotspot(param1:String, param2:Number, param3:Number, param4:Sprite, param5:String = "", param6:String = "") : Hotspot
        {
            return hotspots.addHotspot(param1, param2, param3, param4, param5, param6);
        }// end function

        public function getPositionAngles(param1:int, param2:int) : Point
        {
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            var _loc_6:* = this.getVFov();
            _loc_3 = rect.height / (2 * Math.tan(_loc_6 * Math.PI / 360));
            _loc_4 = param1 - rect.x - rect.width / 2;
            _loc_5 = param2 - rect.y - rect.height / 2;
            var _loc_7:* = new Point();
            _loc_7.x = 180 * Math.atan(_loc_4 / _loc_3) / Math.PI;
            _loc_7.y = 180 * Math.atan(_loc_5 / Math.sqrt(_loc_4 * _loc_4 + _loc_3 * _loc_3)) / Math.PI;
            return _loc_7;
        }// end function

        public function getPositionVector(param1:int, param2:int) : GgVector3d
        {
            var _loc_3:* = this.getPositionAngles(param1, param2);
            var _loc_4:* = new GgVector3d(0, 0, -1);
            _loc_4.rotx(_loc_3.y * Math.PI / 180);
            _loc_4.roty(_loc_3.x * Math.PI / 180);
            _loc_4.rotx((-this.getTilt()) * Math.PI / 180);
            _loc_4.roty((-this.getPan()) * Math.PI / 180);
            return _loc_4;
        }// end function

        protected function isCanvas(param1:Object) : Boolean
        {
            var _loc_2:* = false;
            if (param1 == this.canv || param1 == this.canvOv)
            {
                _loc_2 = true;
            }
            return _loc_2;
        }// end function

        protected function checkHotspots(param1:int, param2:int) : void
        {
            if (this.panorama.hotspots.currentHotspot && this.panorama.hotspots.currentHotspot.clip)
            {
                this.panorama.hotspots.hotspot_txt.visible = false;
            }
            else if (this.isCanvas(this.mtarget))
            {
                if (this.panorama.hotspots.qthotspots.length > 0)
                {
                    this.panorama.checkHotspots(param1, param2);
                    if (this.panorama.hotspots.currentHotspotId == 0)
                    {
                        this.panorama.checkPolygonHotspots(param1, param2);
                    }
                }
                else
                {
                    this.panorama.checkPolygonHotspots(param1, param2);
                }
            }
            else
            {
                hotspots.changeCurrentHotspot(null, param1, param2);
            }
            return;
        }// end function

        public function setAutorotate(param1:Number, param2:Number, param3:Number, param4:Boolean = false) : void
        {
            if (param1 != 0)
            {
                this.auto.start(param1, param2, param3, param4);
            }
            else
            {
                this.auto.stop();
            }
            return;
        }// end function

        override public function setLocked(param1:Boolean) : void
        {
            this.setLockedMouse(param1);
            this.setLockedWheel(param1);
            this.setLockedKeyboard(param1);
            return;
        }// end function

        override public function setLockedMouse(param1:Boolean) : void
        {
            this.mouseLocked = param1;
            return;
        }// end function

        override public function setLockedKeyboard(param1:Boolean) : void
        {
            this.keyboardLocked = param1;
            return;
        }// end function

        public function setLockedKeyboardZoom(param1:Boolean) : void
        {
            this.keyboardZoomLocked = param1;
            return;
        }// end function

        override public function setLockedWheel(param1:Boolean) : void
        {
            this.wheelLocked = param1;
            return;
        }// end function

        override public function lockedMouse() : Boolean
        {
            return this.mouseLocked;
        }// end function

        override public function lockedKeyboard() : Boolean
        {
            return this.keyboardLocked;
        }// end function

        override public function lockedWheel() : Boolean
        {
            return this.wheelLocked;
        }// end function

        public function xmlConfig(param1:XML) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            if (param1.name() == "tour")
            {
                this.tourPanos = new Array();
                this.tourPanoIds = new Array();
                _loc_3 = param1.@start;
                if (this.startNode != "")
                {
                    _loc_3 = this.startNode.toString();
                    this.startNode = "";
                }
                for each (_loc_2 in param1.panorama)
                {
                    
                    _loc_4 = _loc_2.@id;
                    this.tourPanos[_loc_4] = _loc_2;
                    this.tourPanoIds.push(_loc_4);
                    if (_loc_3 == "")
                    {
                        _loc_3 = _loc_4;
                    }
                }
                currentNodeId = _loc_3;
                this.panorama = this.getPanoramaFromConfig(XML(this.tourPanos[currentNodeId]));
            }
            else
            {
                this.panorama = this.getPanoramaFromConfig(param1);
                currentNodeId = "";
            }
            this.readAddonConfig(this.panorama.config);
            if (this.onNodeChange != null)
            {
                this.onNodeChange();
            }
            ready = true;
            return;
        }// end function

        public function updateBytesTotal() : void
        {
            var v:int;
            var cf:int;
            var ldr:Loader;
            v;
            if (this.nextPanoLoader)
            {
                this.intBytesTotal = this.nextPanoLoader.contentLoaderInfo.bytesTotal;
            }
            else
            {
                if (root)
                {
                    v = root.loaderInfo.bytesTotal;
                }
                if (this.panorama)
                {
                    cf;
                    while (cf < 8)
                    {
                        
                        if (this.panorama.externalTiles[cf] != null)
                        {
                            ldr = this.panorama.externalTiles[cf];
                            try
                            {
                                v = v + ldr.contentLoaderInfo.bytesTotal;
                            }
                            catch (e:Error)
                            {
                                v = (v + 1);
                            }
                        }
                        cf = (cf + 1);
                    }
                }
                this.intBytesTotal = v;
            }
            return;
        }// end function

        public function updateBytesLoaded() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_1:* = 0;
            if (this.nextPanoLoader)
            {
                this.intBytesLoaded = this.nextPanoLoader.contentLoaderInfo.bytesLoaded;
            }
            else
            {
                if (root)
                {
                    _loc_1 = root.loaderInfo.bytesLoaded;
                }
                if (this.panorama)
                {
                    _loc_2 = 0;
                    while (_loc_2 < 8)
                    {
                        
                        if (this.panorama.externalTiles[_loc_2] != null)
                        {
                            _loc_3 = this.panorama.externalTiles[_loc_2];
                            try
                            {
                                _loc_1 = _loc_1 + _loc_3.contentLoaderInfo.bytesLoaded;
                            }
                            catch (e:Error)
                            {
                            }
                        }
                        _loc_2++;
                    }
                }
                this.intBytesLoaded = _loc_1;
            }
            return;
        }// end function

        public function setAlphaOverlay(param1:Number) : void
        {
            return;
        }// end function

        override public function bytesTotal() : int
        {
            return this.intBytesTotal;
        }// end function

        override public function bytesLoaded() : int
        {
            return this.intBytesLoaded;
        }// end function

        private function clearHotspots() : void
        {
            if (hotspots.currentHotspot)
            {
                if (hotspots.onRollOutSkinHotspot != null)
                {
                    try
                    {
                        hotspots.onRollOutSkinHotspot(hotspots.currentHotspot.id);
                    }
                    catch (error:Error)
                    {
                    }
                }
                hotspots.currentHotspot = null;
            }
            hotspots.unloadHotspots();
            return;
        }// end function

        private function startTransition() : void
        {
            if (this.transitionEnabled && this.transitionZoomIn)
            {
                if (hotspots.currentHotspot)
                {
                    if (hotspots.currentHotspot.isArea)
                    {
                        this.moveTo(this.mdownPan, this.mdownTilt, this.transitionFov, this.transitionZoomSpeed, true, false);
                    }
                    else
                    {
                        this.moveTo(hotspots.currentHotspot.posPan, hotspots.currentHotspot.posTilt, this.transitionFov, this.transitionZoomSpeed, true, false);
                    }
                }
                else
                {
                    this.moveTo(this.panorama.pan.cur, this.panorama.tilt.cur, this.transitionFov, this.transitionZoomSpeed, true, false);
                }
                if (this.panorama.fov.dest < this.panorama.fov.min)
                {
                    this.panorama.fov.dest = this.panorama.fov.min;
                }
                this.auto.forcedMove = true;
            }
            return;
        }// end function

        override public function openUrl(param1:String, param2:String = "") : void
        {
            var _loc_3:* = null;
            if (param1.length > 0 && param1 != "#")
            {
                if (param1.charAt(0) == "{" || param1.substr(param1.length - 4, 4) == ".swf" || param1.substr(param1.length - 4, 4) == ".xml")
                {
                    this.openNext(param1, param2);
                }
                else
                {
                    _loc_3 = new URLRequest(param1);
                    navigateToURL(_loc_3, param2);
                }
            }
            return;
        }// end function

        override public function openNext(param1:String, param2:String = "") : void
        {
            var v:Array;
            var id:String;
            var context:LoaderContext;
            var exUrl:String;
            var li:int;
            var urlReq:URLRequest;
            var cleanPath:RegExp;
            var url:* = param1;
            var parameter:* = param2;
            isReload = true;
            this.nextPanoParameter = parameter;
            if (parameter == "$cur")
            {
                this.nextPanoParameter = this.panorama.pan.cur.toFixed(1) + "/" + this.panorama.tilt.cur.toFixed(1) + "/" + this.panorama.fov.cur.toFixed(1);
            }
            this.nextPanoParameter = this.nextPanoParameter.replace("$ap", this.getPan());
            this.nextPanoParameter = this.nextPanoParameter.replace("$an", this.getPanNorth());
            this.nextPanoParameter = this.nextPanoParameter.replace("$at", this.getTilt());
            this.nextPanoParameter = this.nextPanoParameter.replace("$af", this.getFov());
            if (this.nextPanoParameter != "")
            {
                v = this.nextPanoParameter.split("/");
                if (v.length >= 4 && v[3] != "")
                {
                    this.startNode = v[3];
                }
            }
            if (url.charAt(0) == "{")
            {
                id = url.substr(1, url.length - 2);
                if (this.tourPanos[id])
                {
                    this.nextPanoNodeId = id;
                    this.startTransition();
                    this.nextPanorama = this.getPanoramaFromConfig(XML(this.tourPanos[this.nextPanoNodeId]));
                    this.nextPanoFlagInit = true;
                    this.isNextPanorama = true;
                    this.nextPanoFlagComplete = true;
                    ;
                }
                return;
            }
            if (this.nextPanoLoader)
            {
                try
                {
                    this.nextPanoLoader.close();
                    if ("unloadAndStop" in this.nextPanoLoader)
                    {
                        this.nextPanoLoader.unloadAndStop();
                    }
                    else
                    {
                        this.nextPanoLoader.unload();
                    }
                }
                catch (e:Error)
                {
                }
                try
                {
                }
                this.nextPanoFlagInit = false;
                this.nextPanoFlagComplete = false;
                this.nextPanoLoader = new Loader();
                if (debugText)
                {
                    debugText.htmlText = debugText.htmlText + hotspots.currentHotspot;
                }
                this.startTransition();
                context = new LoaderContext();
                this.nextPanoAppDomain = new ApplicationDomain(null);
                context.applicationDomain = this.nextPanoAppDomain;
                exUrl = expandFilename(url);
                li = exUrl.lastIndexOf("/");
                if (li > 0)
                {
                    basePath = exUrl.substr(0, (li + 1));
                    cleanPath = /\/([\w\-])+\/\.\.\//g;
                    basePath = basePath.replace(cleanPath, "/");
                    basePath = basePath.replace(cleanPath, "/");
                    basePath = basePath.replace(cleanPath, "/");
                    if (debugText)
                    {
                        debugText.htmlText = debugText.htmlText + ("  New Base path: " + basePath);
                    }
                }
                urlReq = new URLRequest(exUrl);
                this.nextPanoLoader.load(urlReq, context);
                this.nextPanoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.nextPanoLoaderComplete);
                this.nextPanoLoader.contentLoaderInfo.addEventListener(Event.INIT, this.nextPanoLoaderInit);
                this.nextPanoLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioError);
                this.intBytesLoaded = 0;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        private function ioError(event:IOErrorEvent) : void
        {
            return;
        }// end function

        private function nextPanoLoaderInit(event:Event) : void
        {
            this.nextPanoPlayer = this.nextPanoLoader.content as MovieClip;
            if (this.nextPanoPlayer)
            {
                this.nextPanoPlayer.slave = 1;
            }
            this.nextPanoFlagInit = true;
            this.isNextPanorama = true;
            return;
        }// end function

        protected function nextPanoDoInit() : void
        {
            var NRpos:Class;
            var v:Array;
            var vpan:Number;
            var vtilt:Number;
            var vfov:Number;
            this.clearHotspots();
            if (this.nextPanoLoader)
            {
                this.nextPanoPlayer = this.nextPanoLoader.content as MovieClip;
            }
            if (this.nextPanoPlayer)
            {
                this.nextPanoPlayer.slave = 1;
                hotspots.currentHotspotId = 0;
                hotspots.hotspot_txt.visible = false;
                this.panorama.unload();
                this.redrawCursor(null);
                try
                {
                    NRpos = this.nextPanoAppDomain.getDefinition("ImageRepository") as Class;
                    imageReposGet = new NRpos.getImage;
                }
                catch (e:Error)
                {
                }
                this.panorama = null;
                if (sounds)
                {
                    try
                    {
                        sounds.removeDirectional();
                        sounds.getSoundRepos = new NRpos.getSound;
                        if (this.nextPanoPlayer.soundstr)
                        {
                            sounds.xmlConfig(new XML(this.nextPanoPlayer.soundstr));
                        }
                    }
                    catch (e:Error)
                    {
                    }
                }
                this.xmlConfig(new XML(this.nextPanoPlayer.panoramastr));
            }
            else if (this.nextPanoNodeId)
            {
                hotspots.currentHotspotId = 0;
                hotspots.hotspot_txt.visible = false;
                this.redrawCursor(null);
                this.clearHotspots();
                this.panorama.unload();
                this.panorama = this.nextPanorama;
                this.nextPanorama = null;
                currentNodeId = this.nextPanoNodeId;
                if (sounds)
                {
                    try
                    {
                        sounds.removeDirectional();
                    }
                    catch (e:Error)
                    {
                    }
                }
                this.readAddonConfig(this.panorama.config);
                this.nextPanoNodeId = "";
            }
            if (this.onNodeChange != null)
            {
                this.onNodeChange();
            }
            hotspots.currentHotspot = null;
            this.init_panorama();
            if (this.nextPanoParameter != "")
            {
                v = this.nextPanoParameter.split("/");
                vpan = Number(v[0]);
                vtilt = Number(v[1]);
                vfov = Number(v[2]);
                if (v[0] != null && !isNaN(vpan))
                {
                    this.setPan(vpan);
                }
                if (v[1] != null && !isNaN(vtilt))
                {
                    this.setTilt(vtilt);
                }
                if (v[2] != null && !isNaN(vfov))
                {
                    this.setFov(vfov);
                }
            }
            return;
        }// end function

        private function nextPanoLoaderComplete(event:Event) : void
        {
            this.nextPanoFlagComplete = true;
            return;
        }// end function

        override public function videoPlay() : void
        {
            if (this.video)
            {
                this.video.play();
            }
            return;
        }// end function

        override public function videoStop() : void
        {
            if (this.video)
            {
                this.video.stop();
            }
            return;
        }// end function

        override public function videoPause() : void
        {
            if (this.video)
            {
                this.video.pause();
            }
            return;
        }// end function

        override public function videoForward() : void
        {
            if (this.video)
            {
                this.video.forward();
            }
            return;
        }// end function

        override public function videoRewind() : void
        {
            if (this.video)
            {
                this.video.backward();
            }
            return;
        }// end function

        override public function videoStepForward() : void
        {
            if (this.video)
            {
                this.video.stepForward();
            }
            return;
        }// end function

        override public function videoStepBackward() : void
        {
            if (this.video)
            {
                this.video.stepBackward();
            }
            return;
        }// end function

        public function getNodeIds() : Array
        {
            return this.tourPanoIds;
        }// end function

        public function getNodeUserdata(param1:String = "") : Array
        {
            var _loc_2:* = null;
            _loc_2 = new Array();
            _loc_2.push("test");
            _loc_2.push("test2");
            _loc_2.push("test5");
            _loc_2["title"] = "Title for " + param1;
            _loc_2.title = "Title for " + param1;
            return _loc_2;
        }// end function

        public function getNodeLatLng(param1:String = "") : Array
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            _loc_2 = new Array();
            _loc_3 = this.panorama.config;
            if (param1 != "")
            {
                _loc_3 = XML(this.tourPanos[param1]);
            }
            if (_loc_3.hasOwnProperty("userdata"))
            {
                if (_loc_3.userdata.hasOwnProperty("@latitude") && _loc_3.userdata.hasOwnProperty("@longitude"))
                {
                    _loc_2[0] = Number(_loc_3.userdata.@latitude);
                    _loc_2[1] = Number(_loc_3.userdata.@longitude);
                }
            }
            return _loc_2;
        }// end function

        public function getNodeTitle(param1:String = "") : String
        {
            var _loc_2:* = null;
            _loc_2 = this.panorama.config;
            if (param1 != "")
            {
                _loc_2 = XML(this.tourPanos[param1]);
            }
            if (_loc_2.userdata.hasOwnProperty("@title"))
            {
                return _loc_2.userdata.@title;
            }
            return "";
        }// end function

        protected function readAddonConfig(param1:XML) : void
        {
            if (param1.hasOwnProperty("media"))
            {
                if (sounds)
                {
                    sounds.xmlConfig(new XML(param1.media));
                }
            }
            this.panorama.readAddonConfig(this.panorama.config);
            configUserdata(param1);
            this.panorama.hasHotspots = false;
            if (param1.hasOwnProperty("qthotspots"))
            {
                hotspots.configQtHotspot(param1);
                this.panorama.hasHotspots = hotspots.qthotspots.length > 0;
            }
            if (param1.hasOwnProperty("hotspots"))
            {
                hotspots.configHotspot(param1);
                this.panorama.hasHotspots = true;
            }
            return;
        }// end function

        public function getPanoramaFromConfig(param1:XML) : Panorama
        {
            var v:String;
            var pano:Panorama;
            var h:String;
            var config:* = param1;
            var isCylinder:Boolean;
            var isFlat:Boolean;
            var isEqui:Boolean;
            try
            {
                if (config.hasOwnProperty("@hideabout"))
                {
                    this.showAboutPano2VR = config.@hideabout != 1;
                }
                if (config.hasOwnProperty("input"))
                {
                    if (config.input.hasOwnProperty("@overlap"))
                    {
                        this.renderTile.tileOverlap = config.input.@overlap;
                    }
                    else
                    {
                        this.renderTile.tileOverlap = 0;
                    }
                    if (config.input.hasOwnProperty("@cylinder"))
                    {
                        isCylinder = config.input.@cylinder == 1;
                        if (config.input.hasOwnProperty("@flat"))
                        {
                            isFlat = config.input.@flat == 1;
                        }
                        else
                        {
                            isFlat;
                        }
                    }
                    else
                    {
                        isCylinder;
                        isFlat;
                        if (config.input.hasOwnProperty("@equi"))
                        {
                            isEqui = config.input.@equi == 1;
                        }
                    }
                }
                wrapPan = true;
                if (isCylinder)
                {
                    if (isFlat)
                    {
                        pano = new PanoramaFlat();
                        wrapPan = false;
                    }
                    else
                    {
                        pano = new PanoramaCylinder();
                    }
                }
                else if (isEqui)
                {
                    pano = new PanoramaEquirect();
                }
                else
                {
                    pano = new PanoramaCube();
                }
                pano.rect = rect;
                pano.hotspots = hotspots;
                pano.renderTile = this.renderTile;
                pano.viewer = this;
                this.bmpTile = pano.bmpTile;
                pano.readConfig(config);
                pano.loadTilesConfig(config);
                if (wrapPan)
                {
                    wrapPan = pano.pan.max - pano.pan.min == 360;
                }
                if (config.hasOwnProperty("view"))
                {
                    if (config.view.hasOwnProperty("@fovmode"))
                    {
                        this.fovMode = config.view.@fovmode;
                    }
                    northOffset = 0;
                    if (config.view.hasOwnProperty("@pannorth"))
                    {
                        northOffset = config.view.@pannorth;
                    }
                    if (config.view.hasOwnProperty("start"))
                    {
                        if (config.view.start.hasOwnProperty("@pan"))
                        {
                            pano.pan.cur = config.view.start.@pan;
                            pano.pan.def = config.view.start.@pan;
                        }
                        if (config.view.start.hasOwnProperty("@tilt"))
                        {
                            pano.tilt.cur = config.view.start.@tilt;
                            pano.tilt.def = config.view.start.@tilt;
                        }
                        if (config.view.start.hasOwnProperty("@fov"))
                        {
                            pano.fov.cur = config.view.start.@fov;
                            pano.fov.def = config.view.start.@fov;
                        }
                        if (config.view.start.hasOwnProperty("@vfov"))
                        {
                            this.setVFov(config.view.start.@vfov);
                            pano.fov.def = pano.fov.cur;
                        }
                    }
                    if (config.view.hasOwnProperty("min"))
                    {
                        if (config.view.min.hasOwnProperty("@pan"))
                        {
                            pano.pan.min = config.view.min.@pan;
                        }
                        if (config.view.min.hasOwnProperty("@tilt"))
                        {
                            pano.tilt.min = config.view.min.@tilt;
                        }
                        if (config.view.min.hasOwnProperty("@fov"))
                        {
                            pano.fov.min = config.view.min.@fov;
                        }
                    }
                    if (config.view.hasOwnProperty("max"))
                    {
                        if (config.view.max.hasOwnProperty("@pan"))
                        {
                            pano.pan.max = config.view.max.@pan;
                        }
                        if (config.view.max.hasOwnProperty("@tilt"))
                        {
                            pano.tilt.max = config.view.max.@tilt;
                        }
                        if (config.view.max.hasOwnProperty("@fov"))
                        {
                            pano.fov.max = config.view.max.@fov;
                        }
                    }
                }
                this.auto.readConfig(config);
                if (!this.isNextPanorama)
                {
                    if (config.hasOwnProperty("control"))
                    {
                        if (config.control.hasOwnProperty("@sensitifity"))
                        {
                            this.sensitivity = config.control.@sensitifity;
                        }
                        if (config.control.hasOwnProperty("@sensitivity"))
                        {
                            this.sensitivity = config.control.@sensitivity;
                        }
                        if (config.control.hasOwnProperty("@simulatemass"))
                        {
                            this.flagMassSimulation = config.control.@simulatemass == 1;
                        }
                        if (config.control.hasOwnProperty("@locked"))
                        {
                            this.setLocked(config.control.@locked == 1);
                        }
                        if (config.control.hasOwnProperty("@lockedmouse"))
                        {
                            this.setLockedMouse(config.control.@lockedmouse == 1);
                        }
                        if (config.control.hasOwnProperty("@lockedkeyboard"))
                        {
                            this.setLockedKeyboard(config.control.@lockedkeyboard == 1);
                        }
                        if (config.control.hasOwnProperty("@lockedkeyboardzoom"))
                        {
                            this.setLockedKeyboardZoom(config.control.@lockedkeyboardzoom == 1);
                        }
                        if (config.control.hasOwnProperty("@lockedwheel"))
                        {
                            this.setLockedWheel(config.control.@lockedwheel == 1);
                        }
                        if (config.control.hasOwnProperty("@invertwheel"))
                        {
                            this.invertWheel = config.control.@invertwheel == 1;
                        }
                        if (config.control.hasOwnProperty("@speedwheel"))
                        {
                            this.speedWheel = config.control.@speedwheel;
                        }
                        if (config.control.hasOwnProperty("@trapwheel"))
                        {
                            this.trapMouseWheel = config.control.@trapwheel == 1;
                        }
                        if (config.control.hasOwnProperty("@invertcontrol"))
                        {
                            this.invertControl = config.control.@invertcontrol == 1;
                        }
                    }
                    if (config.hasOwnProperty("cursor"))
                    {
                        if (config.cursor.hasOwnProperty("@ownonmovement"))
                        {
                            this.useOwnMoveCursor = config.cursor.@ownonmovement == 1;
                        }
                        if (config.cursor.hasOwnProperty("@ownondefault"))
                        {
                            this.useOwnCursor = config.cursor.@ownondefault == 1;
                        }
                    }
                    if (config.hasOwnProperty("display"))
                    {
                        if (config.display.hasOwnProperty("@width"))
                        {
                            windowWidth = config.display.@width;
                        }
                        if (config.display.hasOwnProperty("@height"))
                        {
                            windowHeight = config.display.@height;
                        }
                        if (config.display.hasOwnProperty("@changestagequality"))
                        {
                            this.changeStageQuality = config.display.@changestagequality == 1;
                        }
                        if (config.display.hasOwnProperty("@smoothing"))
                        {
                            this.changeBmpSmooth = config.display.@smoothing == 1;
                        }
                        if (config.display.hasOwnProperty("@fullscreenmenu"))
                        {
                            this.fullscreenMenu = config.display.@fullscreenmenu == 1;
                        }
                        if (config.display.hasOwnProperty("@custommenutext"))
                        {
                            this.adContextMenuText = config.display.@custommenutext;
                        }
                        if (config.display.hasOwnProperty("@custommenulink"))
                        {
                            this.adContextMenuLink = config.display.@custommenulink;
                        }
                        if (config.display.hasOwnProperty("@scalemode"))
                        {
                            h = config.display.@scalemode;
                            this.stageMode = h;
                            this.windowScaleIgnore = h == "no";
                        }
                        if (config.display.hasOwnProperty("@scaletofit"))
                        {
                            this.alwaysScaleToFit = config.display.@scaletofit == 1;
                        }
                    }
                    if (config.hasOwnProperty("transition"))
                    {
                        if (config.transition.hasOwnProperty("@enabled"))
                        {
                            this.transitionEnabled = config.transition.@enabled == 1;
                        }
                        if (config.transition.hasOwnProperty("@type"))
                        {
                            v = config.transition.@type;
                            if (v == "crossdissolve")
                            {
                                this.transitionType = 0;
                            }
                            if (v == "diptocolor")
                            {
                                this.transitionType = 1;
                            }
                        }
                        if (config.transition.hasOwnProperty("@blendtime"))
                        {
                            this.transitionBlendTime = config.transition.@blendtime;
                        }
                        if (config.transition.hasOwnProperty("@zoomspeed"))
                        {
                            this.transitionZoomSpeed = config.transition.@zoomspeed;
                        }
                        if (config.transition.hasOwnProperty("@zoomfov"))
                        {
                            this.transitionFov = config.transition.@zoomfov;
                        }
                        if (config.transition.hasOwnProperty("@zoomin"))
                        {
                            this.transitionZoomIn = config.transition.@zoomin == 1;
                        }
                        if (config.transition.hasOwnProperty("@zoomout"))
                        {
                            this.transitionZoomOut = config.transition.@zoomout == 1;
                        }
                        if (config.transition.hasOwnProperty("@zoomoutpause"))
                        {
                            this.transitionZoomOutLater = config.transition.@zoomoutpause == 1;
                        }
                        if (config.transition.hasOwnProperty("@blendcolor"))
                        {
                            this.transitionBlendColor = config.transition.@blendcolor;
                        }
                    }
                }
            }
            catch (error:Error)
            {
                if (debugText)
                {
                    debugText.htmlText = error + ":" + error.getStackTrace();
                    ;
                }
            }
            pano.config = config;
            return pano;
        }// end function

    }
}
