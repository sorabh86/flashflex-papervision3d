package 
{
    import GgLock.*;
    import flash.display.*;
    import flash.text.*;

    public class GgLock extends Sprite
    {
        private var text:TextField;

        public function GgLock()
        {
            this.text = new TextField();
            addChild(this.text);
            this.text.htmlText = "";
            this.text.autoSize = TextFieldAutoSize.LEFT;
            this.text.x = 10;
            this.text.y = 10;
            var _loc_1:* = new TextFormat();
            _loc_1.font = "Verdana";
            _loc_1.size = 12;
            _loc_1.color = 16711680;
            _loc_1.align = TextFormatAlign.CENTER;
            this.text.defaultTextFormat = _loc_1;
            this.text.selectable = false;
            this.text.borderColor = 0;
            this.text.backgroundColor = 16777215;
            this.text.background = true;
            this.text.border = true;
            this.text.multiline = true;
            return;
        }// end function

        protected function checkLockElement(param1:XML) : Boolean
        {
            var _loc_3:* = null;
            var _loc_4:* = false;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = false;
            var _loc_11:* = 0;
            var _loc_12:* = null;
            var _loc_13:* = NaN;
            var _loc_14:* = NaN;
            var _loc_2:* = new String();
            _loc_2 = param1.@message;
            if (root)
            {
                _loc_2 = _loc_2.replace("$ref", root.loaderInfo.url);
            }
            if (param1.@type == "domain")
            {
                if (root)
                {
                    _loc_4 = false;
                    _loc_3 = root.loaderInfo.url;
                    if (_loc_3 == null)
                    {
                        _loc_3 = "local";
                    }
                    if (_loc_3.indexOf("http://") == 0)
                    {
                        _loc_3 = _loc_3.replace("http://", "");
                        _loc_4 = true;
                    }
                    if (_loc_3.indexOf("https://") == 0)
                    {
                        _loc_3 = _loc_3.replace("https://", "");
                        _loc_4 = true;
                    }
                    if (_loc_4)
                    {
                        _loc_5 = _loc_3.indexOf("/");
                        _loc_6 = _loc_3.indexOf(":");
                        if (_loc_6 > 0 && _loc_6 < _loc_5)
                        {
                            _loc_5 = _loc_6;
                        }
                        _loc_3 = _loc_3.substr(0, _loc_5);
                        _loc_7 = param1.@domain;
                        this.text.htmlText = _loc_2;
                        _loc_9 = /,/gi;
                        _loc_7 = _loc_7.replace(_loc_9, " ");
                        _loc_9 = /;/gi;
                        _loc_7 = _loc_7.replace(_loc_9, " ");
                        _loc_9 = /:/gi;
                        _loc_7 = _loc_7.replace(_loc_9, " ");
                        _loc_8 = _loc_7.split(" ");
                        _loc_10 = false;
                        _loc_11 = 0;
                        while (_loc_11 < _loc_8.length)
                        {
                            
                            _loc_7 = _loc_8[_loc_11];
                            if (_loc_3.length >= _loc_7.length)
                            {
                                if (_loc_3.substr(_loc_3.length - _loc_7.length) == _loc_7)
                                {
                                    _loc_10 = true;
                                }
                            }
                            _loc_11++;
                        }
                        return _loc_10;
                    }
                    else
                    {
                        this.text.htmlText = _loc_3;
                        return true;
                    }
                }
            }
            if (param1.@type == "date")
            {
                _loc_12 = new Date();
                _loc_13 = Number(param1.@day);
                _loc_14 = _loc_12.getTime() / (1000 * 24 * 3600);
                if (_loc_14 > _loc_13)
                {
                    this.text.htmlText = _loc_2;
                    return false;
                }
            }
            return true;
        }// end function

        public function checkLock(param1:XML) : Boolean
        {
            var _loc_3:* = null;
            var _loc_2:* = true;
            for each (_loc_3 in param1.lock)
            {
                
                _loc_2 = _loc_2 && this.checkLockElement(_loc_3);
            }
            return _loc_2;
        }// end function

    }
}
