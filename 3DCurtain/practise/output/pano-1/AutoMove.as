package 
{

    public class AutoMove extends Object
    {
        public var rotate_active:Boolean;
        public var rotate_timeout:Number;
        public var rotate_pan:Number;
        public var rotate_tilt_force:Number;
        public var rotate_onlyinfocus:Boolean;
        public var rotate_onlyloaded:Boolean;
        public var rotate_enabled:Boolean;
        public var moveTo:Boolean;
        public var moveSpeed:Number;
        public var currentSpeed:Number;
        public var forcedMove:Boolean;
        public var easeIn:Boolean;
        public var easeOut:Boolean;
        public var node_timeout:Number;
        public var rotate_start:Number;

        public function AutoMove()
        {
            this.rotate_pan = 0.5;
            this.rotate_tilt_force = 0.5;
            this.rotate_timeout = 5;
            this.rotate_enabled = true;
            this.rotate_onlyinfocus = false;
            this.moveTo = false;
            this.currentSpeed = 0;
            this.forcedMove = false;
            this.easeIn = false;
            this.easeOut = true;
            this.node_timeout = 0;
            return;
        }// end function

        public function start(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Boolean = false, param5:Boolean = false) : void
        {
            this.activate();
            if (!isNaN(param1) && param1 != 0)
            {
                this.rotate_pan = param1;
            }
            if (!isNaN(param2) && param2 != 0)
            {
                this.rotate_timeout = param2;
            }
            if (!isNaN(param3) && param3 >= 0)
            {
                this.rotate_tilt_force = param3;
            }
            if (param4)
            {
                this.rotate_onlyinfocus = param4;
            }
            else
            {
                this.rotate_onlyinfocus = false;
            }
            this.easeIn = param5;
            return;
        }// end function

        public function stop() : void
        {
            if (!this.forcedMove)
            {
                this.rotate_active = false;
                this.rotate_enabled = false;
                this.moveTo = false;
            }
            return;
        }// end function

        public function pause() : void
        {
            if (!this.forcedMove)
            {
                this.rotate_active = false;
                this.moveTo = false;
            }
            return;
        }// end function

        public function toggle() : void
        {
            if (!this.forcedMove)
            {
                if (this.rotate_onlyinfocus)
                {
                    this.rotate_enabled = !this.rotate_enabled;
                    this.rotate_active = this.rotate_enabled;
                }
                else
                {
                    this.rotate_active = !this.rotate_active;
                    this.rotate_enabled = this.rotate_active;
                }
            }
            return;
        }// end function

        public function activate() : void
        {
            this.rotate_active = true;
            this.rotate_enabled = true;
            var _loc_1:* = new Date();
            this.rotate_start = _loc_1.getTime();
            return;
        }// end function

        public function readConfig(param1:XML) : void
        {
            if (param1.hasOwnProperty("autorotate"))
            {
                this.rotate_enabled = true;
                if (param1.autorotate.hasOwnProperty("@delay"))
                {
                    this.rotate_timeout = param1.autorotate.@delay;
                }
                if (param1.autorotate.hasOwnProperty("@nodedelay"))
                {
                    this.node_timeout = param1.autorotate.@nodedelay;
                }
                if (param1.autorotate.hasOwnProperty("@speed"))
                {
                    this.rotate_enabled = param1.autorotate.@speed != 0;
                    this.rotate_pan = param1.autorotate.@speed;
                }
                if (param1.autorotate.hasOwnProperty("@returntohorizon"))
                {
                    this.rotate_tilt_force = param1.autorotate.@returntohorizon;
                }
                if (param1.autorotate.hasOwnProperty("@onlyinfocus"))
                {
                    this.rotate_onlyinfocus = param1.autorotate.@onlyinfocus == 1;
                }
                if (param1.autorotate.hasOwnProperty("@startloaded"))
                {
                    this.rotate_onlyloaded = param1.autorotate.@startloaded == 1;
                }
            }
            else
            {
                this.rotate_enabled = false;
            }
            return;
        }// end function

    }
}
