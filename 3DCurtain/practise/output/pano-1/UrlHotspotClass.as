package 
{
    import flash.display.*;
    import flash.text.*;

    public class UrlHotspotClass extends MovieClip
    {
        public var HotspotRedDotImage:Class;
        public var hstext:GgTextField;

        public function UrlHotspotClass()
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            this.HotspotRedDotImage = UrlHotspotClass_HotspotRedDotImage;
            _loc_1 = new this.HotspotRedDotImage();
            _loc_1.x = (-_loc_1.width) / 2;
            _loc_1.y = (-_loc_1.height) / 2;
            addChild(_loc_1);
            this.hstext = new GgTextField();
            _loc_2 = new TextFormat();
            _loc_2.align = TextFormatAlign.CENTER;
            _loc_2.font = "Verdana";
            _loc_2.size = 12;
            this.hstext.tf.defaultTextFormat = _loc_2;
            this.hstext.tf.border = true;
            this.hstext.background = true;
            this.hstext.tf.type = TextFieldType.DYNAMIC;
            this.hstext.tf.autoSize = TextFieldAutoSize.NONE;
            this.hstext.htmlText = "<b>Text</b>";
            this.hstext.tf.multiline = true;
            this.hstext.tf.selectable = false;
            this.hstext.y = 20;
            this.hstext.textWidth = 150;
            this.hstext.textHeight = 19;
            this.hstext.x = (-this.hstext.width) / 2;
            addChild(this.hstext);
            useHandCursor = true;
            return;
        }// end function

    }
}
