package 
{
    import flash.display.*;
    import flash.geom.*;

    public class SkinActionClass extends Object
    {
        public var obj:SkinObjectClass;
        public var type:String;
        public var src:String;
        public var value:String;
        public var value2:String;
        public var targetId:String;
        public var targetObj:SkinObjectClass;
        public var targetObjs:Array;
        public var skinVerNr:int = -1;
        public var onMouseClick:Function;
        public var onMouseDoubleClick:Function;
        public var onPressed:Function;
        public var onMouseDown:Function;
        public var onMouseUp:Function;
        public var onMouseEnter:Function;
        public var onMouseLeave:Function;
        public var onMouseOver:Function;
        public var onLoaded:Function;
        public var onReload:Function;
        public var onLoadedLevels:Function;
        public var onReloadLevels:Function;
        public var onActivate:Function;
        public var onDeactivate:Function;
        public var onInit:Function;
        public var onViewerInit:Function;
        public var onEnterFullscreen:Function;
        public var onExitFullscreen:Function;
        public var speed:Number = 0;

        public function SkinActionClass()
        {
            this.value = "";
            this.value2 = "";
            this.targetId = "";
            this.targetObj = null;
            return;
        }// end function

        public function s2n(param1:String) : Number
        {
            var _loc_2:* = null;
            _loc_2 = param1.replace(",", ".");
            return Number(_loc_2);
        }// end function

        public function getValue() : String
        {
            var _loc_1:* = null;
            if (this.value.indexOf("$") >= 0)
            {
                _loc_1 = this.obj.replaceStringVariables(this.value);
                _loc_1 = _loc_1.replace("$ap", this.obj.skin.pano.getPan());
                _loc_1 = _loc_1.replace("$at", this.obj.skin.pano.getTilt());
                _loc_1 = _loc_1.replace("$af", this.obj.skin.pano.getFov());
                return _loc_1;
            }
            return this.value;
        }// end function

        public function getValue2() : String
        {
            var _loc_1:* = null;
            if (this.value2.indexOf("$") >= 0)
            {
                _loc_1 = this.obj.replaceStringVariables(this.value2);
                _loc_1 = _loc_1.replace("$ap", this.obj.skin.pano.getPan());
                _loc_1 = _loc_1.replace("$at", this.obj.skin.pano.getTilt());
                _loc_1 = _loc_1.replace("$af", this.obj.skin.pano.getFov());
                return _loc_1;
            }
            return this.value2;
        }// end function

        public function getTarget() : String
        {
            var _loc_1:* = null;
            if (this.targetId.indexOf("$") >= 0)
            {
                _loc_1 = this.obj.replaceStringVariables(this.targetId);
                _loc_1 = _loc_1.replace("$ap", this.obj.skin.pano.getPan());
                _loc_1 = _loc_1.replace("$at", this.obj.skin.pano.getTilt());
                _loc_1 = _loc_1.replace("$af", this.obj.skin.pano.getFov());
                return _loc_1;
            }
            return this.targetId;
        }// end function

        public function gotoHome() : void
        {
            this.obj.skin.pano.setPan(this.obj.skin.pano.getPanDefault());
            this.obj.skin.pano.setTilt(this.obj.skin.pano.getTiltDefault());
            this.obj.skin.pano.setFov(this.obj.skin.pano.getFovDefault());
            return;
        }// end function

        public function moveToHome() : void
        {
            this.obj.skin.pano.moveTo(this.obj.skin.pano.getPanDefault(), this.obj.skin.pano.getTiltDefault(), this.obj.skin.pano.getFovDefault(), this.speed);
            return;
        }// end function

        public function moveTo() : void
        {
            var _loc_1:* = this.getValue().split("/");
            var _loc_2:* = 0;
            var _loc_3:* = this.obj.skin.pano.getTiltDefault();
            var _loc_4:* = this.obj.skin.pano.getFovDefault();
            _loc_2 = this.s2n(_loc_1[0]);
            if (_loc_1.length >= 2)
            {
                _loc_3 = this.s2n(_loc_1[1]);
            }
            if (_loc_1.length >= 3)
            {
                _loc_4 = this.s2n(_loc_1[2]);
                if (_loc_4 == 0)
                {
                    _loc_4 = this.obj.skin.pano.getFovDefault();
                }
            }
            _loc_1 = this.getValue2().split("/");
            var _loc_5:* = this.s2n(_loc_1[0]);
            if (this.s2n(_loc_1[0]) > 0 && !isNaN(_loc_5))
            {
                this.speed = _loc_5;
            }
            else
            {
                this.speed = this.obj.skin.defaultSpeed;
            }
            var _loc_6:* = 3;
            if (_loc_1.length >= 2)
            {
                _loc_6 = _loc_1[1];
            }
            this.obj.skin.pano.moveTo(_loc_2, _loc_3, _loc_4, this.speed, (_loc_6 & 1) > 0, (_loc_6 & 2) > 0);
            return;
        }// end function

        public function toggleFullscreen() : void
        {
            if (this.obj.skin.pano.isComplete())
            {
                this.obj.skin.pano.update2();
                switch(this.obj.stage.displayState)
                {
                    case StageDisplayState.FULL_SCREEN:
                    {
                        this.obj.stage.displayState = StageDisplayState.NORMAL;
                        break;
                    }
                    case StageDisplayState.NORMAL:
                    default:
                    {
                        this.obj.stage.displayState = StageDisplayState.FULL_SCREEN;
                        break;
                        break;
                    }
                }
            }
            return;
        }// end function

        public function enterFullscreen() : void
        {
            if (this.obj.skin.pano.isComplete())
            {
                this.obj.skin.pano.update2();
                this.obj.stage.displayState = StageDisplayState.FULL_SCREEN;
            }
            return;
        }// end function

        public function exitFullscreen() : void
        {
            this.obj.stage.displayState = StageDisplayState.NORMAL;
            return;
        }// end function

        public function trim(param1:String) : String
        {
            return param1.replace(/^([\s|\t|\n]+)?(.*)([\s|\t|\n]+)?$/gm, "$2");
        }// end function

        public function gotoUrl() : void
        {
            var _loc_1:* = this.trim(this.getValue());
            this.obj.skin.pano.openUrl(_loc_1, this.getValue2());
            return;
        }// end function

        public function gotoNext() : void
        {
            this.obj.skin.pano.openNext(this.getValue(), this.getValue2());
            return;
        }// end function

        public function panLeft() : void
        {
            this.obj.skin.pano.changePan(this.speed, true, true);
            return;
        }// end function

        public function panRight() : void
        {
            this.obj.skin.pano.changePan(-this.speed, true, true);
            return;
        }// end function

        public function tiltUp() : void
        {
            this.obj.skin.pano.changeTilt(this.speed, true, true);
            return;
        }// end function

        public function tiltDown() : void
        {
            this.obj.skin.pano.changeTilt(-this.speed, true, true);
            return;
        }// end function

        public function zoomIn() : void
        {
            this.obj.skin.pano.changeFovLog(-this.speed, true, true);
            return;
        }// end function

        public function zoomOut() : void
        {
            this.obj.skin.pano.changeFovLog(this.speed, true, true);
            return;
        }// end function

        private function findObject(param1:String) : SkinObjectClass
        {
            var _loc_3:* = null;
            var _loc_2:* = null;
            if (param1 == "$self")
            {
                return this.obj;
            }
            if (param1 == "$parent")
            {
                return SkinObjectClass(this.obj.parent);
            }
            if (param1 != "")
            {
                _loc_2 = this.obj.findObjectId(param1);
                if (_loc_2 == null)
                {
                    _loc_3 = this.obj.parent as SkinObjectClass;
                    if (_loc_3)
                    {
                        _loc_2 = _loc_3.findObjectId(param1);
                    }
                }
                if (_loc_2 == null)
                {
                    _loc_2 = this.obj.skin.findObjectId(param1);
                }
            }
            if (_loc_2 == null)
            {
                _loc_2 = SkinObjectClass(this.obj.parent);
            }
            return _loc_2;
        }// end function

        private function getTargetObject() : SkinObjectClass
        {
            if (this.skinVerNr != this.obj.skin.versNr)
            {
                this.skinVerNr = this.obj.skin.versNr;
                this.targetObj = null;
            }
            if (this.targetObj == null)
            {
                this.targetObj = this.findObject(this.getTarget());
            }
            return this.targetObj;
        }// end function

        private function getTargetObjects() : Array
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (this.skinVerNr != this.obj.skin.versNr)
            {
                this.skinVerNr = this.obj.skin.versNr;
                this.targetObjs = null;
            }
            if (this.targetObjs == null)
            {
                _loc_1 = null;
                _loc_2 = this.getTarget();
                if (_loc_2 == "$self")
                {
                    this.targetObjs = new Array();
                    this.targetObjs.push(this.obj);
                    return this.targetObjs;
                }
                if (_loc_2 == "$parent")
                {
                    this.targetObjs = new Array();
                    this.targetObjs.push(SkinObjectClass(this.obj.parent));
                    return this.targetObjs;
                }
                if (_loc_2 != "")
                {
                    if (_loc_2.charAt(0) == "%" || _loc_2.charAt(0) == "#")
                    {
                        this.targetObjs = this.obj.skin.findObjectIds(_loc_2);
                    }
                    else
                    {
                        this.targetObjs = new Array();
                        _loc_1 = this.obj.findObjectId(_loc_2);
                        if (_loc_1 == null)
                        {
                            _loc_3 = this.obj.parent as SkinObjectClass;
                            if (_loc_3)
                            {
                                _loc_1 = _loc_3.findObjectId(_loc_2);
                            }
                        }
                        if (_loc_1 == null)
                        {
                            _loc_1 = this.obj.skin.findObjectId(_loc_2);
                        }
                    }
                    if (_loc_1 != null)
                    {
                        this.targetObjs.push(_loc_1);
                    }
                }
            }
            return this.targetObjs;
        }// end function

        public function setScale() : void
        {
            var _loc_5:* = null;
            var _loc_1:* = this.getValue().split("/");
            var _loc_2:* = 1;
            var _loc_3:* = 1;
            if (_loc_1.length == 1)
            {
                _loc_2 = this.s2n(_loc_1[0]);
                _loc_3 = _loc_2;
            }
            if (_loc_1.length == 2)
            {
                _loc_2 = this.s2n(_loc_1[0]);
                _loc_3 = this.s2n(_loc_1[1]);
            }
            var _loc_4:* = this.getTargetObjects();
            for each (_loc_5 in _loc_4)
            {
                
                _loc_5.targetScale = new Point(_loc_2, _loc_3);
                _loc_5.currentScale = new Point(_loc_2, _loc_3);
            }
            return;
        }// end function

        public function changeScale() : void
        {
            var _loc_5:* = null;
            var _loc_1:* = this.getValue().split("/");
            var _loc_2:* = 1;
            var _loc_3:* = 1;
            if (_loc_1.length == 1)
            {
                _loc_2 = this.s2n(_loc_1[0]);
                _loc_3 = _loc_2;
            }
            if (_loc_1.length == 2)
            {
                _loc_2 = this.s2n(_loc_1[0]);
                _loc_3 = this.s2n(_loc_1[1]);
            }
            var _loc_4:* = this.getTargetObjects();
            for each (_loc_5 in _loc_4)
            {
                
                _loc_5.targetScale = new Point(_loc_2, _loc_3);
            }
            return;
        }// end function

        public function toggleScale() : void
        {
            var _loc_6:* = null;
            var _loc_1:* = this.getValue().split("/");
            var _loc_2:* = 1;
            var _loc_3:* = 1;
            if (_loc_1.length == 1)
            {
                _loc_2 = this.s2n(_loc_1[0]);
                _loc_3 = _loc_2;
            }
            if (_loc_1.length == 2)
            {
                _loc_2 = this.s2n(_loc_1[0]);
                _loc_3 = this.s2n(_loc_1[1]);
            }
            var _loc_4:* = false;
            var _loc_5:* = this.getTargetObjects();
            if (_loc_5.length > 0)
            {
                _loc_4 = !_loc_5[0].activeStateScale;
            }
            for each (_loc_6 in _loc_5)
            {
                
                _loc_6.activeStateScale = _loc_4;
                if (_loc_6.activeStateScale)
                {
                    _loc_6.targetScale = new Point(_loc_2, _loc_3);
                    continue;
                }
                _loc_6.targetScale = _loc_6.defaultScale.clone();
            }
            return;
        }// end function

        public function setAlpha() : void
        {
            var _loc_3:* = null;
            var _loc_1:* = this.s2n(this.getValue());
            var _loc_2:* = this.getTargetObjects();
            if (!isNaN(_loc_1))
            {
                for each (_loc_3 in _loc_2)
                {
                    
                    _loc_3.targetAlpha = _loc_1;
                    _loc_3.currentAlpha = _loc_1;
                }
            }
            return;
        }// end function

        public function changeAlpha() : void
        {
            var _loc_3:* = null;
            var _loc_1:* = this.s2n(this.getValue());
            var _loc_2:* = this.getTargetObjects();
            if (!isNaN(_loc_1))
            {
                for each (_loc_3 in _loc_2)
                {
                    
                    _loc_3.targetAlpha = _loc_1;
                }
            }
            return;
        }// end function

        public function toggleAlpha() : void
        {
            var _loc_4:* = null;
            var _loc_1:* = this.s2n(this.getValue());
            var _loc_2:* = this.getTargetObjects();
            var _loc_3:* = false;
            if (_loc_2.length > 0)
            {
                _loc_3 = !_loc_2[0].activeStateAlpha;
            }
            if (!isNaN(_loc_1))
            {
                for each (_loc_4 in _loc_2)
                {
                    
                    _loc_4.activeStateAlpha = _loc_3;
                    if (_loc_4.activeStateAlpha)
                    {
                        _loc_4.targetAlpha = _loc_1;
                        continue;
                    }
                    _loc_4.targetAlpha = _loc_4.defaultAlpha;
                }
            }
            return;
        }// end function

        public function changePosition() : void
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_1:* = this.getValue().split("/");
            var _loc_2:* = Number(_loc_1[0]);
            var _loc_3:* = Number(_loc_1[1]);
            var _loc_4:* = this.getTargetObjects();
            if (isNaN(_loc_2))
            {
                _loc_6 = this.findObject(this.value);
                if (_loc_6 != null)
                {
                    _loc_2 = _loc_6.currentPos.x;
                    _loc_3 = _loc_6.currentPos.y;
                }
            }
            for each (_loc_5 in _loc_4)
            {
                
                (_loc_5).targetPos = _loc_5.defaultPos.add(new Point(_loc_2, _loc_3));
            }
            return;
        }// end function

        public function setPosition() : void
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_1:* = this.getValue().split("/");
            var _loc_2:* = Number(_loc_1[0]);
            var _loc_3:* = Number(_loc_1[1]);
            var _loc_4:* = this.getTargetObjects();
            if (isNaN(_loc_2))
            {
                _loc_6 = this.findObject(this.value);
                if (_loc_6 != null)
                {
                    _loc_2 = _loc_6.currentPos.x;
                    _loc_3 = _loc_6.currentPos.y;
                }
            }
            for each (_loc_5 in _loc_4)
            {
                
                (_loc_5).targetPos = _loc_5.defaultPos.add(new Point(_loc_2, _loc_3));
                _loc_5.currentPos = _loc_5.targetPos;
                _loc_5.updatePosition();
            }
            return;
        }// end function

        public function changeRelativePosition() : void
        {
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_1:* = this.getValue().split("/");
            var _loc_2:* = Number(_loc_1[0]);
            var _loc_3:* = Number(_loc_1[1]);
            var _loc_4:* = Number(_loc_1[2]);
            var _loc_5:* = Number(_loc_1[3]);
            var _loc_6:* = this.getTargetObjects();
            if (isNaN(_loc_2))
            {
                _loc_8 = this.findObject(this.value);
                if (_loc_8 != null)
                {
                    _loc_2 = _loc_8.currentPos.x;
                    _loc_3 = _loc_8.currentPos.y;
                }
            }
            for each (_loc_7 in _loc_6)
            {
                
                if (_loc_7.targetPos == null)
                {
                    _loc_7.targetPos = _loc_7.currentPos.clone();
                }
                _loc_7.targetPos = _loc_7.targetPos.add(new Point(_loc_2, _loc_3));
                if (_loc_2 > 0 && _loc_1.length >= 3)
                {
                    _loc_7.targetPos.x = Math.min(_loc_7.defaultPos.x + _loc_4, _loc_7.targetPos.x);
                }
                if (_loc_2 < 0 && _loc_1.length >= 3)
                {
                    _loc_7.targetPos.x = Math.max(_loc_7.defaultPos.x + _loc_4, _loc_7.targetPos.x);
                }
                if (_loc_3 > 0 && _loc_1.length >= 3)
                {
                    _loc_7.targetPos.y = Math.min(_loc_7.defaultPos.y + _loc_5, _loc_7.targetPos.y);
                }
                if (_loc_3 < 0 && _loc_1.length >= 3)
                {
                    _loc_7.targetPos.y = Math.max(_loc_7.defaultPos.y + _loc_5, _loc_7.targetPos.y);
                }
            }
            return;
        }// end function

        public function setRelativePosition() : void
        {
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_1:* = this.getValue().split("/");
            var _loc_2:* = Number(_loc_1[0]);
            var _loc_3:* = Number(_loc_1[1]);
            var _loc_4:* = Number(_loc_1[2]);
            var _loc_5:* = Number(_loc_1[3]);
            var _loc_6:* = this.getTargetObjects();
            if (isNaN(_loc_2))
            {
                _loc_8 = this.findObject(this.value);
                if (_loc_8 != null)
                {
                    _loc_2 = _loc_8.currentPos.x;
                    _loc_3 = _loc_8.currentPos.y;
                }
            }
            for each (_loc_7 in _loc_6)
            {
                
                if (_loc_7.targetPos == null)
                {
                    _loc_7.targetPos = _loc_7.currentPos.clone();
                }
                _loc_7.targetPos = _loc_7.targetPos.add(new Point(_loc_2, _loc_3));
                if (_loc_2 > 0 && _loc_1.length >= 3)
                {
                    _loc_7.targetPos.x = Math.min(_loc_7.defaultPos.x + _loc_4, _loc_7.targetPos.x);
                }
                if (_loc_2 < 0 && _loc_1.length >= 3)
                {
                    _loc_7.targetPos.x = Math.max(_loc_7.defaultPos.x + _loc_4, _loc_7.targetPos.x);
                }
                if (_loc_3 > 0 && _loc_1.length >= 3)
                {
                    _loc_7.targetPos.y = Math.min(_loc_7.defaultPos.y + _loc_5, _loc_7.targetPos.y);
                }
                if (_loc_3 < 0 && _loc_1.length >= 3)
                {
                    _loc_7.targetPos.y = Math.max(_loc_7.defaultPos.y + _loc_5, _loc_7.targetPos.y);
                }
                _loc_7.currentPos = _loc_7.targetPos;
                _loc_7.updatePosition();
            }
            return;
        }// end function

        public function togglePosition() : void
        {
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_1:* = this.getValue().split("/");
            var _loc_2:* = Number(_loc_1[0]);
            var _loc_3:* = Number(_loc_1[1]);
            var _loc_4:* = this.getTargetObjects();
            var _loc_5:* = false;
            if (_loc_4.length > 0)
            {
                _loc_5 = !_loc_4[0].activeState;
            }
            if (isNaN(_loc_2))
            {
                _loc_7 = this.findObject(this.value);
                if (_loc_7 != null)
                {
                    _loc_2 = _loc_7.currentPos.x;
                    _loc_3 = _loc_7.currentPos.y;
                }
            }
            for each (_loc_6 in _loc_4)
            {
                
                _loc_6.activeState = _loc_5;
                if (_loc_6.activeState)
                {
                    _loc_6.targetPos = _loc_6.defaultPos.add(new Point(_loc_2, _loc_3));
                    continue;
                }
                _loc_6.targetPos = _loc_6.defaultPos;
            }
            return;
        }// end function

        public function setRotation() : void
        {
            var _loc_3:* = null;
            var _loc_1:* = this.getTargetObjects();
            var _loc_2:* = this.s2n(this.getValue());
            for each (_loc_3 in _loc_1)
            {
                
                _loc_3.targetRot = _loc_2;
                _loc_3.currentRot = _loc_3.targetRot;
            }
            return;
        }// end function

        public function changeRotation() : void
        {
            var _loc_3:* = null;
            var _loc_1:* = this.getTargetObjects();
            var _loc_2:* = this.s2n(this.getValue());
            for each (_loc_3 in _loc_1)
            {
                
                _loc_3.targetRot = _loc_2;
            }
            return;
        }// end function

        public function toggleRotation() : void
        {
            var _loc_4:* = null;
            var _loc_1:* = this.getTargetObjects();
            var _loc_2:* = false;
            var _loc_3:* = this.s2n(this.getValue());
            if (_loc_1.length > 0)
            {
                _loc_2 = !_loc_1[0].activeStateRot;
            }
            for each (_loc_4 in _loc_1)
            {
                
                _loc_4.activeStateRot = _loc_2;
                if (_loc_4.activeStateRot)
                {
                    _loc_4.targetRot = _loc_3;
                    continue;
                }
                _loc_4.targetRot = _loc_4.defaultRot;
            }
            return;
        }// end function

        public function toggleVisible() : void
        {
            var _loc_3:* = null;
            var _loc_1:* = this.getTargetObjects();
            var _loc_2:* = false;
            if (_loc_1.length > 0)
            {
                _loc_2 = !_loc_1[0].currentVisible;
            }
            for each (_loc_3 in _loc_1)
            {
                
                _loc_3.currentVisible = _loc_2;
                _loc_3.visible = _loc_2 && _loc_3.currentAlpha > 0;
            }
            return;
        }// end function

        public function hideObject() : void
        {
            var _loc_2:* = null;
            var _loc_1:* = this.getTargetObjects();
            for each (_loc_2 in _loc_1)
            {
                
                _loc_2.visible = false;
                _loc_2.currentVisible = false;
            }
            return;
        }// end function

        public function showObject() : void
        {
            var _loc_2:* = null;
            var _loc_1:* = this.getTargetObjects();
            for each (_loc_2 in _loc_1)
            {
                
                _loc_2.currentVisible = true;
                _loc_2.visible = _loc_2.currentAlpha > 0;
            }
            return;
        }// end function

        public function toggleAutorotate() : void
        {
            this.obj.skin.pano.toggleAutorotate();
            return;
        }// end function

        public function startAutorotate() : void
        {
            var _loc_1:* = this.getValue().split("/");
            if (_loc_1.length == 0)
            {
                this.obj.skin.pano.startAutorotate();
            }
            if (_loc_1.length == 1)
            {
                this.obj.skin.pano.startAutorotate(this.s2n(_loc_1[0]));
            }
            if (_loc_1.length == 2)
            {
                this.obj.skin.pano.startAutorotate(this.s2n(_loc_1[0]), this.s2n(_loc_1[1]));
            }
            if (_loc_1.length >= 3)
            {
                this.obj.skin.pano.startAutorotate(this.s2n(_loc_1[0]), this.s2n(_loc_1[1]), this.s2n(_loc_1[2]));
            }
            return;
        }// end function

        public function stopAutorotate() : void
        {
            this.obj.skin.pano.stopAutorotate();
            return;
        }// end function

        public function triggerClick() : void
        {
            var _loc_2:* = null;
            var _loc_1:* = this.getTargetObjects();
            for each (_loc_2 in _loc_1)
            {
                
                _loc_2.doClick(null);
            }
            return;
        }// end function

        public function setText() : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = this.getTargetObjects();
            for each (_loc_2 in _loc_1)
            {
                
                _loc_3 = this.value.replace("$$", "{(%#%)}");
                _loc_3 = this.obj.replaceStringVariables(_loc_3).replace("{(%#%)}", "$");
                _loc_2.textString = _loc_3;
                _loc_2.dynamicText = this.value.indexOf("$") >= 0;
                if (_loc_2.childSwf)
                {
                    _loc_2.childSwf.setText(_loc_3);
                }
            }
            return;
        }// end function

        public function videoPlay() : void
        {
            this.obj.skin.pano.videoPlay();
            return;
        }// end function

        public function videoStop() : void
        {
            this.obj.skin.pano.videoStop();
            return;
        }// end function

        public function videoPause() : void
        {
            this.obj.skin.pano.videoPause();
            return;
        }// end function

        public function videoForward() : void
        {
            this.obj.skin.pano.videoForward();
            return;
        }// end function

        public function videoRewind() : void
        {
            this.obj.skin.pano.videoRewind();
            return;
        }// end function

        public function videoStepForward() : void
        {
            this.obj.skin.pano.videoStepForward();
            return;
        }// end function

        public function videoStepBackward() : void
        {
            this.obj.skin.pano.videoStepBackward();
            return;
        }// end function

        public function soundPlay() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (this.obj.skin.pano && this.obj.skin.pano.sounds)
            {
                _loc_1 = this.s2n(this.getValue());
                _loc_3 = this.obj.skin.pano.sounds.findSounds(this.getTarget());
                for each (_loc_2 in _loc_3)
                {
                    
                    if (this.value != "")
                    {
                        if (_loc_2 != null)
                        {
                            _loc_2.loop = _loc_1;
                        }
                    }
                    if (this.obj.skin.pano.debugText)
                    {
                        this.obj.skin.pano.debugText.htmlText = this.obj.skin.pano.debugText.htmlText + (_loc_2.id + ",");
                    }
                    this.obj.skin.pano.sounds.trigger(_loc_2.id);
                }
            }
            return;
        }// end function

        public function soundPlayPause() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (this.obj.skin.pano && this.obj.skin.pano.sounds)
            {
                _loc_1 = this.s2n(this.getValue());
                _loc_3 = this.obj.skin.pano.sounds.findSounds(this.getTarget());
                if (_loc_3.length > 0)
                {
                    _loc_2 = _loc_3[0];
                    _loc_2.playPause();
                }
            }
            return;
        }// end function

        public function soundStop() : void
        {
            this.obj.skin.pano.sounds.stop(this.getTarget());
            return;
        }// end function

        public function soundPause() : void
        {
            this.obj.skin.pano.sounds.pause(this.getTarget());
            return;
        }// end function

        public function toggleVolume() : void
        {
            return;
        }// end function

        public function changeVolume() : void
        {
            this.obj.skin.pano.sounds.changeVolume(this.getTarget(), this.s2n(this.getValue()));
            return;
        }// end function

        public function setVolume() : void
        {
            this.obj.skin.pano.sounds.setVolume(this.getTarget(), this.s2n(this.getValue()));
            return;
        }// end function

        public function changeViewstate() : void
        {
            this.obj.skin.pano.changeViewState(int(this.getValue()), this.s2n(this.getValue2()));
            return;
        }// end function

        public function changeViewerMode() : void
        {
            this.obj.skin.pano.changeViewerMode(int(this.getValue()));
            return;
        }// end function

        public function changePolygonMode() : void
        {
            var _loc_1:* = this.getValue().split("/");
            if (_loc_1.length == 2 && this.s2n(_loc_1[1]) == 1)
            {
                if (this.obj.skin.pano.polygonMode() == 0)
                {
                    this.obj.skin.pano.changePolygonMode(this.s2n(_loc_1[0]));
                }
                else
                {
                    this.obj.skin.pano.changePolygonMode(0);
                }
            }
            else if (_loc_1.length >= 1)
            {
                this.obj.skin.pano.changePolygonMode(this.s2n(_loc_1[0]));
            }
            this.obj.skin.pano.update2();
            return;
        }// end function

        public function setup() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = this.s2n(this.getValue());
            if (_loc_2 > 0 && !isNaN(_loc_2))
            {
                this.speed = _loc_2;
            }
            else
            {
                this.speed = this.obj.skin.defaultSpeed;
            }
            if (this.type == "panleft")
            {
                _loc_1 = this.panLeft;
            }
            if (this.type == "panright")
            {
                _loc_1 = this.panRight;
            }
            if (this.type == "tiltup")
            {
                _loc_1 = this.tiltUp;
            }
            if (this.type == "tiltdown")
            {
                _loc_1 = this.tiltDown;
            }
            if (this.type == "zoomin")
            {
                _loc_1 = this.zoomIn;
            }
            if (this.type == "zoomout")
            {
                _loc_1 = this.zoomOut;
            }
            if (this.type == "home")
            {
                _loc_1 = this.gotoHome;
            }
            if (this.type == "movehome")
            {
                _loc_1 = this.moveToHome;
            }
            if (this.type == "moveto")
            {
                _loc_1 = this.moveTo;
            }
            if (this.type == "gotourl")
            {
                _loc_1 = this.gotoUrl;
            }
            if (this.type == "gotonext")
            {
                _loc_1 = this.gotoNext;
            }
            if (this.type == "changeviewstate")
            {
                _loc_1 = this.changeViewstate;
            }
            if (this.type == "changeviewermode")
            {
                _loc_1 = this.changeViewerMode;
            }
            if (this.type == "changepolygonmode")
            {
                _loc_1 = this.changePolygonMode;
            }
            if (this.type == "tooglefullscreen")
            {
                _loc_1 = this.toggleFullscreen;
            }
            if (this.type == "togglefullscreen")
            {
                _loc_1 = this.toggleFullscreen;
            }
            if (this.type == "enterfullscreen")
            {
                _loc_1 = this.enterFullscreen;
            }
            if (this.type == "exitfullscreen")
            {
                _loc_1 = this.exitFullscreen;
            }
            if (this.type == "toogleautorotate")
            {
                _loc_1 = this.toggleAutorotate;
            }
            if (this.type == "toggleautorotate")
            {
                _loc_1 = this.toggleAutorotate;
            }
            if (this.type == "startautorotate")
            {
                _loc_1 = this.startAutorotate;
            }
            if (this.type == "stopautorotate")
            {
                _loc_1 = this.stopAutorotate;
            }
            if (this.type == "setposition")
            {
                _loc_1 = this.setPosition;
            }
            if (this.type == "changeposition")
            {
                _loc_1 = this.changePosition;
            }
            if (this.type == "setrelativeposition")
            {
                _loc_1 = this.setRelativePosition;
            }
            if (this.type == "changerelativeposition")
            {
                _loc_1 = this.changeRelativePosition;
            }
            if (this.type == "toogleposition")
            {
                _loc_1 = this.togglePosition;
            }
            if (this.type == "toggleposition")
            {
                _loc_1 = this.togglePosition;
            }
            if (this.type == "setrotation")
            {
                _loc_1 = this.setRotation;
            }
            if (this.type == "changerotation")
            {
                _loc_1 = this.changeRotation;
            }
            if (this.type == "togglerotation")
            {
                _loc_1 = this.toggleRotation;
            }
            if (this.type == "setscale")
            {
                _loc_1 = this.setScale;
            }
            if (this.type == "changescale")
            {
                _loc_1 = this.changeScale;
            }
            if (this.type == "togglescale")
            {
                _loc_1 = this.toggleScale;
            }
            if (this.type == "setalpha")
            {
                _loc_1 = this.setAlpha;
            }
            if (this.type == "changealpha")
            {
                _loc_1 = this.changeAlpha;
            }
            if (this.type == "togglealpha")
            {
                _loc_1 = this.toggleAlpha;
            }
            if (this.type == "tooglevisible")
            {
                _loc_1 = this.toggleVisible;
            }
            if (this.type == "togglevisible")
            {
                _loc_1 = this.toggleVisible;
            }
            if (this.type == "hide")
            {
                _loc_1 = this.hideObject;
            }
            if (this.type == "show")
            {
                _loc_1 = this.showObject;
            }
            if (this.type == "settext")
            {
                _loc_1 = this.setText;
            }
            if (this.type == "triggerclick")
            {
                _loc_1 = this.triggerClick;
            }
            if (this.type == "play")
            {
                _loc_1 = this.videoPlay;
            }
            if (this.type == "stop")
            {
                _loc_1 = this.videoStop;
            }
            if (this.type == "pause")
            {
                _loc_1 = this.videoPause;
            }
            if (this.type == "forward")
            {
                _loc_1 = this.videoForward;
            }
            if (this.type == "rewind")
            {
                _loc_1 = this.videoRewind;
            }
            if (this.type == "stepforward")
            {
                _loc_1 = this.videoStepForward;
            }
            if (this.type == "stepbackward")
            {
                _loc_1 = this.videoStepBackward;
            }
            if (this.type == "playsound")
            {
                _loc_1 = this.soundPlay;
            }
            if (this.type == "playpausesound")
            {
                _loc_1 = this.soundPlayPause;
            }
            if (this.type == "stopsound")
            {
                _loc_1 = this.soundStop;
            }
            if (this.type == "pausesound")
            {
                _loc_1 = this.soundPause;
            }
            if (this.type == "togglevolume")
            {
                _loc_1 = this.toggleVolume;
            }
            if (this.type == "changevolume")
            {
                _loc_1 = this.changeVolume;
            }
            if (this.type == "setvolume")
            {
                _loc_1 = this.setVolume;
            }
            if (_loc_1 == null)
            {
            }
            if (this.src == "click")
            {
                this.onMouseClick = _loc_1;
            }
            if (this.src == "doubleclick")
            {
                this.onMouseDoubleClick = _loc_1;
            }
            if (this.src == "pressed")
            {
                this.onPressed = _loc_1;
            }
            if (this.src == "mousedown")
            {
                this.onMouseDown = _loc_1;
            }
            if (this.src == "mouseup")
            {
                this.onMouseUp = _loc_1;
            }
            if (this.src == "enter")
            {
                this.onMouseEnter = _loc_1;
            }
            if (this.src == "leave")
            {
                this.onMouseLeave = _loc_1;
            }
            if (this.src == "over")
            {
                this.onMouseOver = _loc_1;
            }
            if (this.src == "loaded")
            {
                this.onLoaded = _loc_1;
            }
            if (this.src == "reload")
            {
                this.onReload = _loc_1;
            }
            if (this.src == "loadedlevels")
            {
                this.onLoadedLevels = _loc_1;
            }
            if (this.src == "reloadlevels")
            {
                this.onReloadLevels = _loc_1;
            }
            if (this.src == "activate")
            {
                this.onActivate = _loc_1;
            }
            if (this.src == "deactivate")
            {
                this.onDeactivate = _loc_1;
            }
            if (this.src == "init")
            {
                this.onInit = _loc_1;
            }
            if (this.src == "viewerinit")
            {
                this.onViewerInit = _loc_1;
            }
            if (this.src == "enterfullscreen")
            {
                this.onEnterFullscreen = _loc_1;
            }
            if (this.src == "exitfullscreen")
            {
                this.onExitFullscreen = _loc_1;
            }
            return;
        }// end function

    }
}
