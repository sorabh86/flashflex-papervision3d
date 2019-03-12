package 
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.text.*;

    public class GgViewer extends Sprite
    {
        public var enable_callback:Boolean = false;
        public var hsClip:MovieClip;
        public var hsMask:Shape;
        public var rect:Rectangle;
        public var windowWidth:Number = 100;
        public var windowHeight:Number = 100;
        public var marginLeft:int = 0;
        public var marginTop:int = 0;
        public var marginRight:int = 0;
        public var marginBottom:int = 0;
        public var isInFocus:Boolean = false;
        public var isLoadingLevels:Boolean = false;
        public var sounds:GgSounds;
        public var imageRepos:ImageRepository;
        public var imageReposGet:Function;
        public var hotspots:Hotspots;
        public var userdata:Array;
        public var latitude:String = "0";
        public var longitude:String = "0";
        public var userdataTags:Array;
        public var wrapPan:Boolean = true;
        public var debugText:TextField;
        public var ready:Boolean = false;
        public var currentNodeId:String;
        public var northOffset:Number;
        public var isReload:Boolean = false;
        public var basePath:String;

        public function GgViewer()
        {
            this.userdata = new Array();
            this.hotspots = new Hotspots();
            this.hotspots.viewer = this;
            this.rect = new Rectangle();
            this.currentNodeId = "";
            this.basePath = "";
            return;
        }// end function

        public function expandFilename(param1:String) : String
        {
            if (param1 != "")
            {
                if (param1.charAt(0) == "/" || param1.indexOf("://") > 0)
                {
                    return param1;
                }
                return this.basePath + param1;
            }
            else
            {
                return this.basePath;
            }
        }// end function

        public function bytesTotal() : int
        {
            return 1;
        }// end function

        public function bytesLoaded() : int
        {
            return 1;
        }// end function

        public function moveTo(param1:Number, param2:Number, param3:Number = 0, param4:Number = 0.4, param5:Boolean = true, param6:Boolean = true) : void
        {
            return;
        }// end function

        public function isComplete() : Boolean
        {
            return true;
        }// end function

        public function update() : void
        {
            return;
        }// end function

        public function update2() : void
        {
            return;
        }// end function

        public function changePan(param1:Number, param2:Boolean = false, param3:Boolean = false) : void
        {
            return;
        }// end function

        public function changeTilt(param1:Number, param2:Boolean = false, param3:Boolean = false) : void
        {
            return;
        }// end function

        public function changeFov(param1:Number, param2:Boolean = false, param3:Boolean = false) : void
        {
            return;
        }// end function

        public function changeFovLog(param1:Number, param2:Boolean = false, param3:Boolean = false) : void
        {
            this.changeFov(param1, param2, param3);
            return;
        }// end function

        public function changeViewState(param1:int, param2:Number = 0.1) : void
        {
            return;
        }// end function

        public function changeViewerMode(param1:int) : void
        {
            return;
        }// end function

        public function changePolygonMode(param1:int) : void
        {
            if (this.hotspots)
            {
                this.hotspots.polyMode = param1;
            }
            return;
        }// end function

        public function polygonMode() : int
        {
            if (this.hotspots)
            {
                return this.hotspots.polyMode;
            }
            return 0;
        }// end function

        public function setPan(param1:Number) : void
        {
            return;
        }// end function

        public function setTilt(param1:Number) : void
        {
            return;
        }// end function

        public function setFov(param1:Number) : void
        {
            return;
        }// end function

        public function getPan() : Number
        {
            return 0;
        }// end function

        public function getPanNorth() : Number
        {
            return this.getPan();
        }// end function

        public function getTilt() : Number
        {
            return 0;
        }// end function

        public function getFov() : Number
        {
            return 0;
        }// end function

        public function getPanDefault() : Number
        {
            return 0;
        }// end function

        public function getTiltDefault() : Number
        {
            return 0;
        }// end function

        public function getFovDefault() : Number
        {
            return 0;
        }// end function

        public function startAutorotate(param1:Number = 0, param2:Number = 0, param3:Number = 0) : void
        {
            return;
        }// end function

        public function stopAutorotate() : void
        {
            return;
        }// end function

        public function toggleAutorotate() : void
        {
            return;
        }// end function

        public function cleanup() : void
        {
            return;
        }// end function

        public function setLocked(param1:Boolean) : void
        {
            return;
        }// end function

        public function setLockedMouse(param1:Boolean) : void
        {
            return;
        }// end function

        public function setLockedKeyboard(param1:Boolean) : void
        {
            return;
        }// end function

        public function setLockedWheel(param1:Boolean) : void
        {
            return;
        }// end function

        public function lockedMouse() : Boolean
        {
            return false;
        }// end function

        public function lockedKeyboard() : Boolean
        {
            return false;
        }// end function

        public function lockedWheel() : Boolean
        {
            return false;
        }// end function

        public function redrawCursor(event:Event) : void
        {
            return;
        }// end function

        public function getViewerRect() : Rectangle
        {
            return this.rect.clone();
        }// end function

        public function getHotspots() : Array
        {
            return this.hotspots.hotspots;
        }// end function

        public function getQtHotspots() : Array
        {
            return this.hotspots.qthotspots;
        }// end function

        public function updateMargins() : void
        {
            this.rect.left = this.marginLeft;
            this.rect.top = this.marginTop;
            this.rect.width = this.windowWidth - this.marginLeft - this.marginRight;
            this.rect.height = this.windowHeight - this.marginTop - this.marginBottom;
            return;
        }// end function

        public function addHotspot(param1:String, param2:Number, param3:Number, param4:Sprite, param5:String = "", param6:String = "") : Hotspot
        {
            return null;
        }// end function

        public function addQtHotspot(param1:Number, param2:String, param3:String, param4:String) : void
        {
            this.hotspots.addQtHotspot(param1, param2, param3, param4);
            return;
        }// end function

        public function unloadHotspots() : void
        {
            this.hotspots.unloadHotspots();
            return;
        }// end function

        public function doMouseClick() : void
        {
            if (this.debugText)
            {
                this.debugText.htmlText = this.debugText.htmlText + "Mouse Click!";
            }
            if (this.hotspots.currentHotspot != null)
            {
                if (this.debugText)
                {
                    this.debugText.htmlText = this.debugText.htmlText + "HS";
                }
                if (this.hotspots.onClickSkinHotspot != null)
                {
                    if (this.debugText)
                    {
                        this.debugText.htmlText = this.debugText.htmlText + "HSSkin";
                    }
                    try
                    {
                        this.hotspots.onClickSkinHotspot(this.hotspots.currentHotspot.id);
                    }
                    catch (error:Error)
                    {
                    }
                }
                if (this.hotspots.currentHotspot.isArea)
                {
                    if (this.hotspots.onClickQtHotspot != null)
                    {
                        if (this.debugText)
                        {
                            this.debugText.htmlText = this.debugText.htmlText + "QtClick";
                        }
                        try
                        {
                            this.hotspots.onClickQtHotspot(this.hotspots.currentHotspot.id, this.hotspots.currentHotspot.title, this.hotspots.currentHotspot.url, this.hotspots.currentHotspot.target);
                        }
                        catch (error:Error)
                        {
                        }
                    }
                    else if (this.hotspots.currentHotspot.onCallback != null)
                    {
                        this.hotspots.currentHotspot.onCallback(this.hotspots.currentHotspot.id);
                    }
                    else
                    {
                        if (this.debugText)
                        {
                            this.debugText.htmlText = this.debugText.htmlText + "Goto";
                        }
                        if (this.hotspots.currentHotspot.url.length > 0)
                        {
                            this.openUrl(this.hotspots.currentHotspot.url, this.hotspots.currentHotspot.target);
                        }
                    }
                }
            }
            return;
        }// end function

        private function noEmpty(param1, param2:int, param3:Array) : Boolean
        {
            return param1 != "";
        }// end function

        public function configUserdata(param1:XML) : void
        {
            if (param1.hasOwnProperty("userdata"))
            {
                if (param1.userdata.hasOwnProperty("@title"))
                {
                    this.userdata[0] = param1.userdata.@title;
                }
                if (param1.userdata.hasOwnProperty("@description"))
                {
                    this.userdata[1] = param1.userdata.@description;
                }
                if (param1.userdata.hasOwnProperty("@author"))
                {
                    this.userdata[2] = param1.userdata.@author;
                }
                if (param1.userdata.hasOwnProperty("@datetime"))
                {
                    this.userdata[3] = param1.userdata.@datetime;
                }
                if (param1.userdata.hasOwnProperty("@copyright"))
                {
                    this.userdata[4] = param1.userdata.@copyright;
                }
                if (param1.userdata.hasOwnProperty("@source"))
                {
                    this.userdata[5] = param1.userdata.@source;
                }
                if (param1.userdata.hasOwnProperty("@info"))
                {
                    this.userdata[6] = param1.userdata.@info;
                }
                if (param1.userdata.hasOwnProperty("@comment"))
                {
                    this.userdata[7] = param1.userdata.@comment;
                }
                this.userdataTags = new Array();
                if (param1.userdata.hasOwnProperty("@tags"))
                {
                    this.userdataTags = param1.userdata.@tags.toString().split("|");
                    this.userdataTags = this.userdataTags.filter(this.noEmpty);
                }
                this.latitude = "0";
                this.longitude = "0";
                if (param1.userdata.hasOwnProperty("@latitude"))
                {
                    this.latitude = param1.userdata.@latitude;
                }
                if (param1.userdata.hasOwnProperty("@longitude"))
                {
                    this.longitude = param1.userdata.@longitude;
                }
            }
            return;
        }// end function

        public function openUrl(param1:String, param2:String = "") : void
        {
            var _loc_3:* = new URLRequest(param1);
            navigateToURL(_loc_3, param2);
            return;
        }// end function

        public function openNext(param1:String, param2:String = "") : void
        {
            return;
        }// end function

        public function videoPlay() : void
        {
            return;
        }// end function

        public function videoStop() : void
        {
            return;
        }// end function

        public function videoPause() : void
        {
            return;
        }// end function

        public function videoForward() : void
        {
            return;
        }// end function

        public function videoRewind() : void
        {
            return;
        }// end function

        public function videoStepForward() : void
        {
            return;
        }// end function

        public function videoStepBackward() : void
        {
            return;
        }// end function

        public function set onClickHotspot(param1:Function) : void
        {
            this.hotspots.onClickHotspot = param1;
            return;
        }// end function

        public function get onClickHotspot() : Function
        {
            return this.hotspots.onClickHotspot;
        }// end function

        public function set onRollOverHotspot(param1:Function) : void
        {
            this.hotspots.onRollOverHotspot = param1;
            return;
        }// end function

        public function get onRollOverHotspot() : Function
        {
            return this.hotspots.onRollOverHotspot;
        }// end function

        public function set onRollOutHotspot(param1:Function) : void
        {
            this.hotspots.onRollOutHotspot = param1;
            return;
        }// end function

        public function get onRollOutHotspot() : Function
        {
            return this.hotspots.onRollOutHotspot;
        }// end function

        public function set onClickQtHotspot(param1:Function) : void
        {
            this.hotspots.onClickQtHotspot = param1;
            return;
        }// end function

        public function get onClickQtHotspot() : Function
        {
            return this.hotspots.onClickQtHotspot;
        }// end function

        public function set onRollOverQtHotspot(param1:Function) : void
        {
            this.hotspots.onRollOverQtHotspot = param1;
            return;
        }// end function

        public function get onRollOverQtHotspot() : Function
        {
            return this.hotspots.onRollOverQtHotspot;
        }// end function

        public function set onRollOutQtHotspot(param1:Function) : void
        {
            this.hotspots.onRollOutQtHotspot = param1;
            return;
        }// end function

        public function get onRollOutQtHotspot() : Function
        {
            return this.hotspots.onRollOutQtHotspot;
        }// end function

    }
}
