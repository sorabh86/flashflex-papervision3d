package 
{
    import flash.display.*;
    import flash.errors.*;
    import flash.events.*;
    import flash.external.*;

    public class MouseWheelTrap extends Object
    {
        private const INSTANTIATION_ERROR:String = "Don\'t instantiate com.spikything.utils.MouseWheelTrap directly. Just call MouseWheelTrap.setup(stage);";
        private static const JAVASCRIPT:String = "var ggBrowserScrolling;function ggAllowBrowserScroll(value) { ggBrowserScrolling = value;}function ggMouseWheel(event) { if (!event) { event = window.event; } if (!ggBrowserScrolling) { if (event.preventDefault) { event.preventDefault(); } event.returnValue = false; }}if (window.addEventListener) { window.addEventListener(\'DOMMouseScroll\', ggMouseWheel, false); window.addEventListener(\'mousewheel\', ggMouseWheel, false);} else if (window.attachEvent) {\twindow.attachEvent(\'onmousewheel\', ggMouseWheel);} else {\twindow.onmousewheel = document.onmousewheel = ggMouseWheel;}ggAllowBrowserScroll(true);";
        private static const JS_METHOD:String = "ggAllowBrowserScroll";
        private static var _browserScrollEnabled:Boolean = true;
        private static var _mouseWheelTrapped:Boolean = false;

        public function MouseWheelTrap()
        {
            throw new IllegalOperationError(this.INSTANTIATION_ERROR);
        }// end function

        public static function setup(param1:Stage) : void
        {
            var stage:* = param1;
            stage.addEventListener(MouseEvent.MOUSE_MOVE, function (param1 = null) : void
            {
                allowBrowserScroll(false);
                return;
            }// end function
            );
            stage.addEventListener(Event.MOUSE_LEAVE, function (param1 = null) : void
            {
                allowBrowserScroll(true);
                return;
            }// end function
            );
            return;
        }// end function

        private static function allowBrowserScroll(param1:Boolean) : void
        {
            createMouseWheelTrap();
            if (param1 == _browserScrollEnabled)
            {
                return;
            }
            _browserScrollEnabled = param1;
            if (ExternalInterface.available)
            {
                ExternalInterface.call(JS_METHOD, _browserScrollEnabled);
                return;
            }
            return;
        }// end function

        private static function createMouseWheelTrap() : void
        {
            if (_mouseWheelTrapped)
            {
                return;
            }
            _mouseWheelTrapped = true;
            if (ExternalInterface.available)
            {
                ExternalInterface.call("eval", JAVASCRIPT);
                return;
            }
            return;
        }// end function

    }
}
