package 
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class GgTextField extends Sprite
    {
        private var _radius:int = 0;
        private var _borderColor:uint = 0;
        private var _backgroundColor:uint = 16711935;
        private var _borderWidth:int = 1;
        private var _borderAlpha:Number = 0.5;
        private var _backgroundAlpha:Number = 0.5;
        private var _textWidth:int = 100;
        private var _textHeight:int = 50;
        private var _hasScrollBar:Boolean = false;
        private var bg:Sprite;
        private var _background:Boolean;
        public var default_width:int = 0;
        public var tf:TextField;
        public var scrollerArea:Shape;
        public var scrollerEnabled:Boolean = true;
        public var scrollerWidth:int = 10;
        public var scrollerPadding:int = 1;
        private var scrollerThumbTop:int = 0;
        private var scrollerThumbHeight:int = 50;
        private var scrollerMoveDownY:int = 0;
        private var scrollerMoveDownTY:int = 0;
        private var scrollerMove:Boolean = false;

        public function GgTextField()
        {
            this.bg = new Sprite();
            this.tf = new TextField();
            addChild(this.bg);
            addChild(this.tf);
            tabEnabled = false;
            tabChildren = false;
            tabIndex = -1;
            this.tf.text = "";
            this.tf.border = false;
            this.tf.backgroundColor = 16711935;
            this.tf.alpha = 1;
            this.tf.antiAliasType = AntiAliasType.ADVANCED;
            this.tf.tabEnabled = false;
            this.tf.tabIndex = -1;
            this.tf.selectable = false;
            this.scrollerArea = new Shape();
            this.scrollerArea.graphics.clear();
            this.scrollerArea.graphics.beginFill(0, 0.5);
            this.scrollerArea.graphics.drawRect(0, 0, this.scrollerWidth, this.tf.height);
            this.scrollerArea.graphics.endFill();
            addChild(this.scrollerArea);
            this.scrollerEnabled = this._hasScrollBar;
            this.tf.addEventListener(Event.SCROLL, this.scrollHandler);
            addEventListener(MouseEvent.MOUSE_DOWN, this.doMouseDown, false, 0, true);
            addEventListener(MouseEvent.MOUSE_UP, this.doMouseUp, false, 0, true);
            addEventListener(MouseEvent.MOUSE_MOVE, this.doMouseMove, false, 0, true);
            addEventListener(MouseEvent.MOUSE_OUT, this.doMouseOut, false, 0, true);
            addEventListener(MouseEvent.CLICK, this.doMouseClick, false, 0, true);
            return;
        }// end function

        private function scrollHandler(event:Event) : void
        {
            this.displayScrollBar();
            return;
        }// end function

        public function doMouseDown(event:MouseEvent) : void
        {
            this.scrollerMove = false;
            if (event.localX > this.tf.x + this.tf.width && this.scrollerEnabled)
            {
                if (event.localY > this.tf.y + this.scrollerThumbTop && event.localY < this.tf.y + this.scrollerThumbTop + this.scrollerThumbHeight)
                {
                    this.scrollerMoveDownY = event.localY;
                    this.scrollerMoveDownTY = this.tf.scrollV;
                    this.scrollerMove = true;
                }
            }
            return;
        }// end function

        public function doMouseMove(event:MouseEvent) : void
        {
            var _loc_2:* = 0;
            if (this.scrollerMove)
            {
                _loc_2 = (event.localY - this.scrollerMoveDownY) * this.tf.maxScrollV / (this.tf.height - this.scrollerThumbHeight);
                this.tf.scrollV = _loc_2 + this.scrollerMoveDownTY;
            }
            return;
        }// end function

        public function doMouseUp(event:MouseEvent) : void
        {
            this.scrollerMove = false;
            return;
        }// end function

        public function doMouseOut(event:MouseEvent) : void
        {
            this.scrollerMove = false;
            return;
        }// end function

        public function doMouseClick(event:MouseEvent) : void
        {
            if (event.localX > this.tf.x + this.tf.width && this.scrollerEnabled)
            {
                if (event.localY < this.tf.y + this.scrollerThumbTop)
                {
                    var _loc_2:* = this.tf;
                    var _loc_3:* = _loc_2.scrollV - 1;
                    _loc_2.scrollV = _loc_3;
                }
                else if (event.localY > _loc_2.y + this.scrollerThumbTop + this.scrollerThumbHeight)
                {
                    var _loc_2:* = this.tf;
                    var _loc_3:* = _loc_2.scrollV + 1;
                    _loc_2.scrollV = _loc_3;
                }
            }
            return;
        }// end function

        public function set radius(param1:int) : void
        {
            if (param1 < 0)
            {
                param1 = 0;
            }
            this._radius = param1;
            this.display();
            return;
        }// end function

        public function get radius() : int
        {
            return this._radius;
        }// end function

        public function set textWidth(param1:int) : void
        {
            this._textWidth = param1;
            this.display();
            return;
        }// end function

        public function get textWidth() : int
        {
            return this._textWidth;
        }// end function

        public function set textHeight(param1:int) : void
        {
            this._textHeight = param1;
            this.display();
            return;
        }// end function

        public function get textHeight() : int
        {
            return this._textHeight;
        }// end function

        public function set borderColor(param1:uint) : void
        {
            this._borderColor = param1;
            this.display();
            return;
        }// end function

        public function get borderColor() : uint
        {
            return this._borderColor;
        }// end function

        public function set background(param1:Boolean) : void
        {
            this._background = param1;
            this.display();
            return;
        }// end function

        public function set hasScrollBar(param1:Boolean) : void
        {
            this._hasScrollBar = param1;
            this.display();
            return;
        }// end function

        public function get background() : Boolean
        {
            return this._background;
        }// end function

        public function set backgroundColor(param1:uint) : void
        {
            this._backgroundColor = param1;
            this.display();
            return;
        }// end function

        public function get backgroundColor() : uint
        {
            return this._backgroundColor;
        }// end function

        public function set borderAlpha(param1:Number) : void
        {
            this._borderAlpha = param1;
            this.display();
            return;
        }// end function

        public function get borderAlpha() : Number
        {
            return this._borderAlpha;
        }// end function

        public function set borderWidth(param1:Number) : void
        {
            this._borderWidth = param1;
            this.display();
            return;
        }// end function

        public function get borderWidth() : Number
        {
            return this._borderWidth;
        }// end function

        public function set backgroundAlpha(param1:Number) : void
        {
            this._backgroundAlpha = param1;
            this.display();
            return;
        }// end function

        public function get backgroundAlpha() : Number
        {
            return this._backgroundAlpha;
        }// end function

        public function set text(param1:String) : void
        {
            this.tf.text = param1;
            this.display();
            return;
        }// end function

        public function get text() : String
        {
            return this.tf.text;
        }// end function

        public function set htmlText(param1:String) : void
        {
            this.tf.htmlText = param1;
            this.display();
            return;
        }// end function

        public function get htmlText() : String
        {
            return this.tf.htmlText;
        }// end function

        public function updateFieldSize() : void
        {
            var _loc_1:* = this._radius / 2;
            if (_loc_1 < this._borderWidth)
            {
                _loc_1 = this._borderWidth;
            }
            this.tf.height = this._textHeight - _loc_1;
            if (this._hasScrollBar && this.tf.textHeight > this.tf.height)
            {
                this.scrollerEnabled = true;
            }
            else
            {
                this.scrollerEnabled = false;
            }
            if (this.scrollerEnabled == false)
            {
                this.tf.width = this._textWidth - _loc_1;
                this.scrollerArea.visible = false;
            }
            else
            {
                this.tf.width = this._textWidth - this.scrollerWidth - _loc_1 - this.scrollerPadding;
                this.scrollerArea.visible = true;
            }
            return;
        }// end function

        private function updateScrollBar() : void
        {
            var _loc_1:* = this._radius / 2;
            if (_loc_1 < this._borderWidth)
            {
                _loc_1 = this._borderWidth;
            }
            var _loc_2:* = this.scrollerEnabled;
            this.updateFieldSize();
            this.scrollerArea.x = this._textWidth - this.scrollerWidth - (_loc_1 - 1) / 2;
            this.scrollerArea.y = this.tf.y;
            if (this.scrollerEnabled != _loc_2)
            {
                this.updateFieldSize();
            }
            return;
        }// end function

        public function display() : void
        {
            var _loc_3:* = 0;
            if (this._hasScrollBar)
            {
                this.updateScrollBar();
                this.displayScrollBar();
            }
            else
            {
                this.updateFieldSize();
                if (this.scrollerEnabled)
                {
                    this.scrollerEnabled = false;
                    this.updateFieldSize();
                }
            }
            var _loc_1:* = this._radius / 2;
            if (_loc_1 < this._borderWidth)
            {
                _loc_1 = this._borderWidth;
            }
            this.tf.backgroundColor = this._backgroundColor;
            this.tf.border = false;
            this.tf.background = false;
            if (this.tf.autoSize == TextFieldAutoSize.CENTER)
            {
                this.tf.x = _loc_1 / 2 + (this._textWidth - _loc_1 - this.tf.width) / 2;
                this.tf.y = _loc_1 / 2;
            }
            else if (this.tf.autoSize == TextFieldAutoSize.RIGHT)
            {
                this.tf.x = _loc_1 / 2 + (this._textWidth - _loc_1 - this.tf.width);
                this.tf.y = _loc_1 / 2;
            }
            else
            {
                this.tf.x = _loc_1 / 2;
                this.tf.y = _loc_1 / 2;
            }
            var _loc_2:* = this.bg.graphics;
            _loc_2.clear();
            if (this._borderWidth > 0)
            {
                _loc_2.lineStyle(this._borderWidth, this._borderColor, this._borderAlpha);
            }
            else
            {
                _loc_2.lineStyle(NaN);
            }
            if (this._background)
            {
                _loc_2.beginFill(this._backgroundColor, this._backgroundAlpha);
            }
            _loc_3 = this.tf.width + _loc_1;
            if (this.scrollerEnabled)
            {
                _loc_3 = _loc_3 + (this.scrollerWidth + this.scrollerPadding);
            }
            if (this._radius <= 0)
            {
                _loc_2.drawRect(this.tf.x - this._borderWidth / 2, this.tf.y - this._borderWidth / 2, _loc_3, this._borderWidth + this.tf.height);
            }
            else
            {
                _loc_2.drawRoundRect(this.tf.x - _loc_1 / 2, this.tf.y - _loc_1 / 2, _loc_3, _loc_1 + this.tf.height, 2 * _loc_1);
            }
            if (this._background)
            {
                _loc_2.endFill();
            }
            return;
        }// end function

        private function displayScrollBar() : void
        {
            if (this.scrollerEnabled)
            {
                this.scrollerThumbHeight = this.tf.height * this.tf.height / this.tf.textHeight;
                if (this.tf.maxScrollV > 1)
                {
                    this.scrollerThumbTop = (this.tf.height - this.scrollerThumbHeight) * (this.tf.scrollV - 1) / (this.tf.maxScrollV - 1);
                }
                else
                {
                    this.scrollerThumbTop = 0;
                }
            }
            else
            {
                this.scrollerThumbHeight = this.tf.height;
                this.scrollerThumbTop = 0;
            }
            if (this.scrollerArea.visible)
            {
                this.scrollerArea.graphics.clear();
                this.scrollerArea.graphics.beginFill(0, 0.5);
                this.scrollerArea.graphics.drawRect(0, 0, this.scrollerWidth, this.tf.height);
                this.scrollerArea.graphics.endFill();
                this.scrollerArea.graphics.beginFill(16777215, 0.5);
                this.scrollerArea.graphics.drawRect(0, this.scrollerThumbTop, this.scrollerWidth, this.scrollerThumbHeight);
                this.scrollerArea.graphics.endFill();
            }
            return;
        }// end function

    }
}
