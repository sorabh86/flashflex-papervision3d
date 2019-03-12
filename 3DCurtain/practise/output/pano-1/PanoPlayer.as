package 
{
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    import flash.ui.*;
    import mx.core.*;

    public class PanoPlayer extends MovieClip
    {
        private var tf:TextField;
        public var pano:PanoViewer;
        public var skin:SkinClass;
        public var skin2:SkinClass;
        private var ldr:Loader;
        public var video:VideoPanoClass;
        public var panoramastr:String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<panorama id=\"\" hideabout=\"1\">\n  <view fovmode=\"0\" pannorth=\"0\">\n    <start pan=\"0\" fov=\"70\" tilt=\"0\"/>\n    <min pan=\"0\" fov=\"5\" tilt=\"-90\"/>\n    <max pan=\"360\" fov=\"120\" tilt=\"90\"/>\n  </view>\n  <userdata title=\"\" datetime=\"\" description=\"\" copyright=\"\" tags=\"\" author=\"\" source=\"\" comment=\"\" info=\"\" longitude=\"\" latitude=\"\"/>\n  <hotspots width=\"180\" height=\"0\" wordwrap=\"1\">\n    <label width=\"180\" backgroundalpha=\"1\" enabled=\"1\" height=\"0\" backgroundcolor=\"0xffffff\" bordercolor=\"0x000000\" border=\"1\" textcolor=\"0x000000\" background=\"1\" borderalpha=\"1\" borderradius=\"1\" wordwrap=\"1\" textalpha=\"1\"/>\n    <polystyle mode=\"2\" backgroundalpha=\"0.2509803921568627\" backgroundcolor=\"0x0000ff\" bordercolor=\"0x0000ff\" borderalpha=\"1\"/>\n    <polyhotspot title=\"Change Screen\" target=\"\" url=\"\" id=\"screentv\">\n      <vertex pan=\"-39.359\" tilt=\"-5.0817\"/>\n      <vertex pan=\"-53.966\" tilt=\"-3.71538\"/>\n      <vertex pan=\"-54.0408\" tilt=\"-14.0365\"/>\n      <vertex pan=\"-39.4361\" tilt=\"-18.3875\"/>\n    </polyhotspot>\n  </hotspots>\n  <qthotspots>\n    <label width=\"180\" movement=\"1\" enabled=\"1\" height=\"0\" backgroundcolor=\"0xffffff\" bordercolor=\"0x000000\" border=\"1\" textcolor=\"0x000000\" background=\"1\" wordwrap=\"1\"/>\n  </qthotspots>\n  <media>\n    <image width=\"1304\" rotx=\"-5\" roty=\"-1\" rotz=\"0\" pan=\"-89.5823\" stretch=\"1\" fov=\"43.96\" height=\"957\" id=\"_element_0\" tilt=\"-5.42049\" clickmode=\"1\">\n      <source url=\"red-curtain.png\"/>\n    </image>\n  </media>\n  <input tile0url=\"images/tile-preview_o_0.jpg\" tile5url=\"images/tile-preview_o_5.jpg\" tile4url=\"images/tile-preview_o_4.jpg\" tilesize=\"637\" tile3url=\"images/tile-preview_o_3.jpg\" tile2url=\"images/tile-preview_o_2.jpg\" tile1url=\"images/tile-preview_o_1.jpg\">\n    <preview images=\"1\" color=\"0x808080\"/>\n  </input>\n  <control simulatemass=\"1\" lockedmouse=\"0\" lockedkeyboard=\"0\" invertwheel=\"0\" lockedkeyboardzoom=\"0\" trapwheel=\"1\" lockedwheel=\"0\" invertcontrol=\"0\" speedwheel=\"1\" sensitivity=\"8\"/>\n  <cursor ownonmovement=\"1\" ownondefault=\"1\"/>\n  <display width=\"640\" scalemode=\"stage\" scaletofit=\"1\" height=\"480\" custommenulink=\"\" changestagequality=\"1\" custommenutext=\"\" fullscreenmenu=\"0\" smoothing=\"1\"/>\n  <transition blendcolor=\"0x000000\" enabled=\"0\" blendtime=\"1\" zoomin=\"1\" zoomfov=\"5\" type=\"crossdissolve\" zoomoutpause=\"1\" zoomspeed=\"2\" zoomout=\"1\"/>\n</panorama>\n";
        public var skinstr:String = "<skin marginleft=\"0\" marginright=\"0\" margintop=\"0\" marginbottom=\"0\" ><element x=\"10\" y=\"10\" anchor=\"0\" width=\"179\" height=\"20\" id=\"Loading text\" visible=\"1\" alpha=\"1\" angle=\"0\" scalex=\"1\" scaley=\"1\" center=\"4\" handcursor=\"0\" type=\"text\" text=\"&lt;b&gt;Loading...$p%&lt;/b&gt;\" align=\"0\" color=\"0x000000\" bordercolor=\"0x000000\" borderalpha=\"1\" backgroundcolor=\"0xffffff\" backgroundalpha=\"1\" backgroundvisible=\"0\" borderwidth=\"0\" borderradius=\"0\" wordwrap=\"0\" scrollbar=\"0\" autosize=\"0\" >\n<action src=\"loaded\" type=\"hide\" value=\"\" value2=\"\" target=\"$self\" />\n</element>\n<element x=\"10\" y=\"30\" anchor=\"0\" width=\"180\" height=\"10\" id=\"Loading rectangle\" visible=\"1\" alpha=\"1\" angle=\"0\" scalex=\"1\" scaley=\"1\" center=\"3\" handcursor=\"0\" type=\"rectangle\" bordercolor=\"0x000080\" borderalpha=\"1\" backgroundcolor=\"0x0000ff\" backgroundalpha=\"0.298039\" backgroundvisible=\"1\" borderwidth=\"2\" borderradius=\"0\" >\n<action src=\"loaded\" type=\"hide\" value=\"\" value2=\"\" target=\"$self\" />\n<modifier src=\"loading\" type=\"scalex\" offset=\"0\" factor=\"1\" />\n</element>\n</skin>";
        public var lockstr:String = "<locks>\n</locks>";
        public var slave:int = 0;
        public var isFlash10:Boolean = false;
        private var lock:GgLock;
        private var dbgCnt:int = 0;
        private var xmlLoader:URLLoader;
        private var xmlSkinLoader:URLLoader;
        private var xmlLoadingDelayed:Boolean = false;

        public function PanoPlayer()
        {
            var baa:* = new ByteArrayAsset();
            try
            {
                Security.allowDomain("*");
                Security.allowInsecureDomain("*");
            }
            catch (error:Error)
            {
            }
            this.isFlash10 = Number(Capabilities.version.split(" ")[1].split(",")[0]) >= 10;
            if (Capabilities.version == "FL 10,1,123,391")
            {
                this.isFlash10 = false;
            }
            if (loaderInfo.parameters.noflash10)
            {
                this.isFlash10 = loaderInfo.parameters.noflash10 != 1;
            }
            if (loaderInfo.parameters.slave || this.slave == 1)
            {
                return;
            }
            addEventListener(Event.ENTER_FRAME, this.initPanoViewer);
            this.lock = new GgLock();
            addChild(this.lock);
            if (this.lock.checkLock(new XML(this.lockstr)))
            {
                removeChild(this.lock);
            }
            else
            {
                this.slave = 1;
            }
            return;
        }// end function

        private function initPano() : void
        {
            var videostr:String;
            var soundstr:String;
            try
            {
                if (this.pano.debugText)
                {
                    this.pano.debugText.htmlText = this.pano.debugText.htmlText + "Init Pano";
                }
                addChild(this.pano);
                addChild(this.pano.hsClip);
                if (this.tf)
                {
                    addChild(this.tf);
                }
                this.pano.windowWidth = 600;
                this.pano.windowHeight = 400;
                this.skin = new SkinClass(this.pano);
                if (loaderInfo.parameters.skin)
                {
                    this.skinstr = root.loaderInfo.parameters.skin;
                }
                if (this.skinstr.length > 20)
                {
                    try
                    {
                        this.skin.xmlConfig(new XML(this.skinstr));
                        addChild(this.skin);
                        this.linkSkin();
                    }
                    catch (error:Error)
                    {
                        if (pano.debugText)
                        {
                            pano.debugText.htmlText = error + ":" + error.getStackTrace();
                        }
                    }
                }
                else
                {
                    addChild(this.skin);
                }
                if (loaderInfo.parameters.skin2)
                {
                    try
                    {
                        this.skin2 = new SkinClass(this.pano);
                        this.skin2.xmlConfig(new XML(root.loaderInfo.parameters.skin2));
                        addChild(this.skin2);
                    }
                    catch (error:Error)
                    {
                    }
                }
                if (loaderInfo.parameters.startnode)
                {
                    this.pano.startNode = loaderInfo.parameters.startnode;
                }
                this.pano.xmlConfig(new XML(this.panoramastr));
                if (loaderInfo.parameters.panorama)
                {
                    this.pano.xmlConfig(new XML(root.loaderInfo.parameters.panorama));
                }
                if (loaderInfo.parameters.panoxml)
                {
                    this.xmlLoader = new URLLoader(new URLRequest(loaderInfo.parameters.panoxml));
                    this.xmlLoader.addEventListener(Event.COMPLETE, this.xmlLoaded);
                }
                if (loaderInfo.parameters.skinxml)
                {
                    this.xmlSkinLoader = new URLLoader(new URLRequest(loaderInfo.parameters.skinxml));
                    this.xmlSkinLoader.addEventListener(Event.COMPLETE, this.xmlSkinLoaded);
                }
                if (this.pano.stageMode == "stage")
                {
                    try
                    {
                        if (stage)
                        {
                            stage.scaleMode = StageScaleMode.NO_SCALE;
                            stage.align = StageAlign.TOP_LEFT;
                        }
                    }
                    catch (err:Error)
                    {
                    }
                }
                if (this.panoramastr.length < 25)
                {
                }
                this.updateContextMenu();
                this.loadExternalParameter();
                videostr;
                if (loaderInfo.parameters.video)
                {
                    videostr = root.loaderInfo.parameters.video;
                }
                if (videostr.length > 15)
                {
                    this.attachVideo(videostr);
                }
                if (loaderInfo.parameters.externalinterface)
                {
                    this.addExternalInterface();
                }
                if (loaderInfo.parameters.sound)
                {
                    soundstr = loaderInfo.parameters.sound;
                    this.pano.sounds.xmlConfig(new XML(soundstr));
                }
                addEventListener(Event.ENTER_FRAME, this.pano.sounds.doEnterFrame, false, 0, true);
            }
            catch (err:Error)
            {
                if (tf)
                {
                    tf.htmlText = err.toString();
                }
            }
            return;
        }// end function

        public function readConfigUrl(param1:String) : void
        {
            this.xmlLoader = new URLLoader(new URLRequest(param1));
            this.xmlLoader.addEventListener(Event.COMPLETE, this.xmlLoaded);
            return;
        }// end function

        public function readConfigString(param1:String) : void
        {
            this.pano.xmlConfig(new XML(param1));
            return;
        }// end function

        private function linkSkin() : void
        {
            this.pano.hotspots.onClickSkinHotspot = this.skin.hotspotClick;
            this.pano.hotspots.onRollOverSkinHotspot = this.skin.hotspotRollOver;
            this.pano.hotspots.onRollOutSkinHotspot = this.skin.hotspotRollOut;
            this.pano.hotspots.onAddHotspot = this.skin.createHotspot;
            this.pano.hotspots.onUnloadHotspots = this.skin.clearHotspots;
            this.pano.onNodeChange = this.skin.nodeChanged;
            return;
        }// end function

        private function xmlLoaded(event:Event) : void
        {
            if (this.xmlSkinLoader)
            {
                this.xmlLoadingDelayed = true;
                if (this.pano.debugText)
                {
                    this.pano.debugText.htmlText = this.pano.debugText.htmlText + "xml delayed";
                }
                return;
            }
            this.pano.xmlConfig(new XML(this.xmlLoader.data));
            if (this.pano.debugText)
            {
                this.pano.debugText.htmlText = this.pano.debugText.htmlText + "xml loaded";
            }
            this.pano.init_panorama();
            this.updateContextMenu();
            this.loadExternalParameter();
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("ggXmlReady");
                }
            }
            catch (e:Error)
            {
            }
            this.xmlLoader = null;
            return;
        }// end function

        private function xmlSkinLoaded(event:Event) : void
        {
            var event:* = event;
            try
            {
                this.skin.xmlConfig(new XML(this.xmlSkinLoader.data));
                if (this.pano.debugText)
                {
                    this.pano.debugText.htmlText = this.pano.debugText.htmlText + "xmlskin loaded";
                }
                this.linkSkin();
                this.xmlSkinLoader = null;
                if (this.xmlLoader && this.xmlLoadingDelayed)
                {
                    this.xmlLoaded(event);
                }
            }
            catch (error:Error)
            {
                if (pano.debugText)
                {
                    pano.debugText.htmlText = error + ":" + error.getStackTrace();
                }
            }
            return;
        }// end function

        private function initPanoViewer(event:Event) : void
        {
            removeEventListener(Event.ENTER_FRAME, this.initPanoViewer);
            if (this.slave != 1)
            {
                this.pano = new PanoViewer();
                this.initPano();
                if (this.pano.debugText)
                {
                    this.pano.debugText.htmlText = this.pano.debugText.htmlText + "Init Pano Viewer";
                }
                ;
            }
            return;
        }// end function

        public function cleanup() : void
        {
            if (this.pano != null)
            {
                this.pano.cleanup();
            }
            if (this.skin != null)
            {
                this.skin.cleanup();
            }
            if (this.skin2 != null)
            {
                this.skin2.cleanup();
            }
            if (this.pano.sounds != null)
            {
                this.pano.removeEventListener(Event.ENTER_FRAME, this.pano.sounds.doEnterFrame);
                this.pano.sounds.removeAll();
            }
            return;
        }// end function

        private function addExternalInterface() : void
        {
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.addCallback("getPan", this.pano.getPan);
                    ExternalInterface.addCallback("setPan", this.pano.setPan);
                    ExternalInterface.addCallback("changePan", this.pano.changePan);
                    ExternalInterface.addCallback("getPanNorth", this.pano.getPanNorth);
                    ExternalInterface.addCallback("getTilt", this.pano.getTilt);
                    ExternalInterface.addCallback("setTilt", this.pano.setTilt);
                    ExternalInterface.addCallback("changeTilt", this.pano.changeTilt);
                    ExternalInterface.addCallback("getFov", this.pano.getFov);
                    ExternalInterface.addCallback("setFov", this.pano.setFov);
                    ExternalInterface.addCallback("changeFov", this.pano.changeFov);
                    ExternalInterface.addCallback("moveTo", this.pano.moveTo);
                    ExternalInterface.addCallback("setAutorotate", this.pano.setAutorotate);
                    ExternalInterface.addCallback("setLocked", this.pano.setLocked);
                    ExternalInterface.addCallback("isComplete", this.pano.isComplete);
                    ExternalInterface.addCallback("stopAutorotate", this.pano.stopAutorotate);
                    ExternalInterface.addCallback("openNext", this.pano.openNext);
                    ExternalInterface.addCallback("clickHotspot", this.pano.hotspots.onClickSkinHotspot);
                    ExternalInterface.addCallback("attachVideo", this.attachVideo);
                    ExternalInterface.addCallback("detachVideo", this.detachVideo);
                    ExternalInterface.addCallback("getNodeIds", this.pano.getNodeIds);
                    ExternalInterface.addCallback("getNodeUserdata", this.pano.getNodeUserdata);
                    ExternalInterface.addCallback("getNodeTitle", this.pano.getNodeTitle);
                    ExternalInterface.addCallback("getNodeLatLng", this.pano.getNodeLatLng);
                    ExternalInterface.addCallback("readConfigUrl", this.readConfigUrl);
                    ExternalInterface.addCallback("readConfigString", this.readConfigString);
                    ExternalInterface.call("ggSwfReady");
                }
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        public function attachVideo(param1:String) : void
        {
            var str:* = param1;
            if (this.video)
            {
                this.detachVideo();
            }
            try
            {
                this.video = new VideoPanoClass(this.pano);
                this.video.xmlConfig(new XML(str));
                this.pano.video = this.video;
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        public function detachVideo() : void
        {
            try
            {
                this.video.cleanup();
                this.video = null;
                this.pano.video = null;
                this.pano.bmpVideo = null;
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        private function adContextMenu(event:Event) : void
        {
            var _loc_2:* = new URLRequest(this.pano.adContextMenuLink);
            navigateToURL(_loc_2, "_blank");
            return;
        }// end function

        private function toogleFullscreen(event:Event) : void
        {
            if (stage)
            {
                this.pano.update2();
                switch(stage.displayState)
                {
                    case StageDisplayState.FULL_SCREEN:
                    {
                        stage.displayState = StageDisplayState.NORMAL;
                        break;
                    }
                    case StageDisplayState.NORMAL:
                    default:
                    {
                        stage.displayState = StageDisplayState.FULL_SCREEN;
                        break;
                        break;
                    }
                }
            }
            return;
        }// end function

        private function updateContextMenu() : void
        {
            var customContextMenu:ContextMenu;
            var menuItem:ContextMenuItem;
            try
            {
                customContextMenu = new ContextMenu();
                customContextMenu.hideBuiltInItems();
                if (loaderInfo.parameters.hideabout)
                {
                    this.pano.showAboutPano2VR = root.loaderInfo.parameters.hideabout != 1;
                }
                if (loaderInfo.parameters.showfps)
                {
                    this.pano.showfps = root.loaderInfo.parameters.showfps == 1;
                }
                if (this.pano.adContextMenuText.length > 0)
                {
                    menuItem = new ContextMenuItem(this.pano.adContextMenuText);
                    menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.adContextMenu);
                    customContextMenu.customItems.push(menuItem);
                }
                if (this.pano.showAboutPano2VR)
                {
                    menuItem = new ContextMenuItem("About Pano2VR Player...");
                    menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, about);
                    customContextMenu.customItems.push(menuItem);
                }
                if (this.pano.fullscreenMenu)
                {
                    menuItem = new ContextMenuItem("Fullscreen");
                    menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.toogleFullscreen);
                    customContextMenu.customItems.push(menuItem);
                }
                contextMenu = customContextMenu;
            }
            catch (err:Error)
            {
                if (tf)
                {
                    tf.htmlText = err.toString();
                }
            }
            return;
        }// end function

        private function loadExternalParameter() : void
        {
            if (loaderInfo.parameters.pan)
            {
                this.pano.setPan(root.loaderInfo.parameters.pan);
            }
            if (loaderInfo.parameters.tilt)
            {
                this.pano.setTilt(root.loaderInfo.parameters.tilt);
            }
            if (loaderInfo.parameters.fov)
            {
                this.pano.setFov(root.loaderInfo.parameters.fov);
            }
            return;
        }// end function

        private static function about(event:Event) : void
        {
            var _loc_2:* = new URLRequest("http://gardengnomesoftware.com/pano2vr");
            navigateToURL(_loc_2, "_blank");
            return;
        }// end function

    }
}
