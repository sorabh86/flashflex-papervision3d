package 
{

    public class Matrix4d extends Object
    {
        private var n11:Number;
        private var n12:Number;
        private var n13:Number;
        private var n14:Number;
        private var n21:Number;
        private var n22:Number;
        private var n23:Number;
        private var n24:Number;
        private var n31:Number;
        private var n32:Number;
        private var n33:Number;
        private var n34:Number;
        private var n41:Number;
        private var n42:Number;
        private var n43:Number;
        private var n44:Number;

        public function Matrix4d()
        {
            this.setIdent();
            return;
        }// end function

        public function setIdent() : void
        {
            this.n11 = 1;
            this.n12 = 0;
            this.n13 = 0;
            this.n14 = 0;
            this.n21 = 0;
            this.n22 = 1;
            this.n23 = 0;
            this.n24 = 0;
            this.n31 = 0;
            this.n32 = 0;
            this.n33 = 1;
            this.n34 = 0;
            this.n41 = 0;
            this.n42 = 0;
            this.n43 = 0;
            this.n44 = 1;
            return;
        }// end function

        public function setRotX(param1:Number) : void
        {
            var _loc_2:* = Math.cos(param1);
            var _loc_3:* = Math.sin(param1);
            this.n11 = 1;
            this.n12 = 0;
            this.n13 = 0;
            this.n14 = 0;
            this.n21 = 0;
            this.n22 = _loc_2;
            this.n23 = _loc_3;
            this.n24 = 0;
            this.n31 = 0;
            this.n32 = -_loc_3;
            this.n33 = _loc_2;
            this.n34 = 0;
            this.n41 = 0;
            this.n42 = 0;
            this.n43 = 0;
            this.n44 = 1;
            return;
        }// end function

        public function setRotY(param1:Number) : void
        {
            var _loc_2:* = Math.cos(param1);
            var _loc_3:* = Math.sin(param1);
            this.n11 = _loc_2;
            this.n12 = 0;
            this.n13 = -_loc_3;
            this.n14 = 0;
            this.n21 = 0;
            this.n22 = 1;
            this.n23 = 0;
            this.n24 = 0;
            this.n31 = _loc_3;
            this.n32 = 0;
            this.n33 = _loc_2;
            this.n34 = 0;
            this.n41 = 0;
            this.n42 = 0;
            this.n43 = 0;
            this.n44 = 1;
            return;
        }// end function

        public function setRotZ(param1:Number) : void
        {
            var _loc_2:* = Math.cos(param1);
            var _loc_3:* = Math.sin(param1);
            this.n11 = _loc_2;
            this.n12 = _loc_3;
            this.n13 = 0;
            this.n14 = 0;
            this.n21 = -_loc_3;
            this.n22 = _loc_2;
            this.n23 = 0;
            this.n24 = 0;
            this.n31 = 0;
            this.n32 = 0;
            this.n33 = 1;
            this.n34 = 0;
            this.n41 = 0;
            this.n42 = 0;
            this.n43 = 0;
            this.n44 = 1;
            return;
        }// end function

        public function setScale(param1:Number) : void
        {
            this.n11 = param1;
            this.n12 = 0;
            this.n13 = 0;
            this.n14 = 0;
            this.n21 = 0;
            this.n22 = param1;
            this.n23 = 0;
            this.n24 = 0;
            this.n31 = 0;
            this.n32 = 0;
            this.n33 = param1;
            this.n34 = 0;
            this.n41 = 0;
            this.n42 = 0;
            this.n43 = 0;
            this.n44 = 1;
            return;
        }// end function

        public function mulVector(param1:GgVector3d, param2:GgVector3d) : void
        {
            param2.init(param1.cx * this.n11 + param1.cy * this.n12 + param1.cz * this.n13, param1.cx * this.n21 + param1.cy * this.n22 + param1.cz * this.n23, param1.cx * this.n31 + param1.cy * this.n32 + param1.cz * this.n33);
            return;
        }// end function

        public function toString() : String
        {
            var _loc_1:* = new String("Matrix(\n");
            _loc_1 = _loc_1 + (this.n11 + "\t" + this.n12 + "\t" + this.n13 + "\t" + this.n14 + "\n");
            _loc_1 = _loc_1 + (this.n21 + "\t" + this.n22 + "\t" + this.n23 + "\t" + this.n24 + "\n");
            _loc_1 = _loc_1 + (this.n31 + "\t" + this.n32 + "\t" + this.n33 + "\t" + this.n34 + "\n");
            _loc_1 = _loc_1 + (this.n41 + "\t" + this.n42 + "\t" + this.n43 + "\t" + this.n44 + ")\n");
            return _loc_1;
        }// end function

        public static function multiply(param1:Matrix4d, param2:Matrix4d) : Matrix4d
        {
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            var _loc_7:* = NaN;
            var _loc_8:* = NaN;
            var _loc_9:* = NaN;
            var _loc_10:* = NaN;
            var _loc_11:* = NaN;
            var _loc_12:* = NaN;
            var _loc_13:* = NaN;
            var _loc_14:* = NaN;
            var _loc_15:* = NaN;
            var _loc_16:* = NaN;
            var _loc_17:* = NaN;
            var _loc_18:* = NaN;
            var _loc_19:* = NaN;
            var _loc_20:* = NaN;
            var _loc_21:* = NaN;
            var _loc_22:* = NaN;
            var _loc_23:* = NaN;
            var _loc_24:* = NaN;
            var _loc_25:* = NaN;
            var _loc_26:* = NaN;
            var _loc_27:* = NaN;
            var _loc_28:* = NaN;
            var _loc_29:* = NaN;
            var _loc_30:* = NaN;
            var _loc_31:* = NaN;
            var _loc_32:* = NaN;
            var _loc_33:* = NaN;
            var _loc_34:* = NaN;
            var _loc_35:* = NaN;
            var _loc_3:* = new Matrix4d;
            var _loc_36:* = param1.n11;
            _loc_4 = param1.n11;
            var _loc_36:* = param2.n11;
            _loc_5 = param2.n11;
            var _loc_36:* = param1.n12;
            _loc_12 = param1.n12;
            var _loc_36:* = param2.n21;
            _loc_7 = param2.n21;
            var _loc_36:* = param1.n13;
            _loc_20 = param1.n13;
            var _loc_36:* = param2.n31;
            _loc_9 = param2.n31;
            var _loc_36:* = param1.n14;
            _loc_28 = param1.n14;
            var _loc_36:* = param2.n41;
            _loc_11 = param2.n41;
            _loc_3.n11 = _loc_36 * _loc_36 + _loc_36 * _loc_36 + _loc_36 * _loc_36 + _loc_36 * _loc_36;
            var _loc_36:* = param2.n12;
            _loc_13 = param2.n12;
            var _loc_36:* = param2.n22;
            _loc_15 = param2.n22;
            var _loc_36:* = param2.n32;
            _loc_17 = param2.n32;
            var _loc_36:* = param2.n42;
            _loc_19 = param2.n42;
            _loc_3.n12 = _loc_4 * _loc_36 + _loc_12 * _loc_36 + _loc_20 * _loc_36 + _loc_28 * _loc_36;
            var _loc_36:* = param2.n13;
            _loc_21 = param2.n13;
            var _loc_36:* = param2.n23;
            _loc_23 = param2.n23;
            var _loc_36:* = param2.n33;
            _loc_25 = param2.n33;
            var _loc_36:* = param2.n43;
            _loc_27 = param2.n43;
            _loc_3.n13 = _loc_4 * _loc_36 + _loc_12 * _loc_36 + _loc_20 * _loc_36 + _loc_28 * _loc_36;
            var _loc_36:* = param2.n14;
            _loc_29 = param2.n14;
            var _loc_36:* = param2.n24;
            _loc_31 = param2.n24;
            var _loc_36:* = param2.n34;
            _loc_33 = param2.n34;
            var _loc_36:* = param2.n44;
            _loc_35 = param2.n44;
            _loc_3.n14 = _loc_4 * _loc_36 + _loc_12 * _loc_36 + _loc_20 * _loc_36 + _loc_28 * _loc_36;
            var _loc_36:* = param1.n21;
            _loc_6 = param1.n21;
            var _loc_36:* = param1.n22;
            _loc_14 = param1.n22;
            var _loc_36:* = param1.n23;
            _loc_22 = param1.n23;
            var _loc_36:* = param1.n24;
            _loc_30 = param1.n24;
            _loc_3.n21 = _loc_36 * _loc_5 + _loc_36 * _loc_7 + _loc_36 * _loc_9 + _loc_36 * _loc_11;
            _loc_3.n22 = _loc_6 * _loc_13 + _loc_14 * _loc_15 + _loc_22 * _loc_17 + _loc_30 * _loc_19;
            _loc_3.n23 = _loc_6 * _loc_21 + _loc_14 * _loc_23 + _loc_22 * _loc_25 + _loc_30 * _loc_27;
            _loc_3.n24 = _loc_6 * _loc_29 + _loc_14 * _loc_31 + _loc_22 * _loc_33 + _loc_30 * _loc_35;
            var _loc_36:* = param1.n31;
            _loc_8 = param1.n31;
            var _loc_36:* = param1.n32;
            _loc_16 = param1.n32;
            var _loc_36:* = param1.n33;
            _loc_24 = param1.n33;
            var _loc_36:* = param1.n34;
            _loc_32 = param1.n34;
            _loc_3.n31 = _loc_36 * _loc_5 + _loc_36 * _loc_7 + _loc_36 * _loc_9 + _loc_36 * _loc_11;
            _loc_3.n32 = _loc_8 * _loc_13 + _loc_16 * _loc_15 + _loc_24 * _loc_17 + _loc_32 * _loc_19;
            _loc_3.n33 = _loc_8 * _loc_21 + _loc_16 * _loc_23 + _loc_24 * _loc_25 + _loc_32 * _loc_27;
            _loc_3.n34 = _loc_8 * _loc_29 + _loc_16 * _loc_31 + _loc_24 * _loc_33 + _loc_32 * _loc_35;
            var _loc_36:* = param1.n41;
            _loc_10 = param1.n41;
            var _loc_36:* = param1.n42;
            _loc_18 = param1.n42;
            var _loc_36:* = param1.n43;
            _loc_26 = param1.n43;
            var _loc_36:* = param1.n44;
            _loc_34 = param1.n44;
            _loc_3.n41 = _loc_36 * _loc_5 + _loc_36 * _loc_7 + _loc_36 * _loc_9 + _loc_36 * _loc_11;
            _loc_3.n42 = _loc_10 * _loc_13 + _loc_18 * _loc_15 + _loc_26 * _loc_17 + _loc_34 * _loc_19;
            _loc_3.n43 = _loc_10 * _loc_21 + _loc_18 * _loc_23 + _loc_26 * _loc_25 + _loc_34 * _loc_27;
            _loc_3.n44 = _loc_10 * _loc_29 + _loc_18 * _loc_31 + _loc_26 * _loc_33 + _loc_34 * _loc_35;
            return _loc_3;
        }// end function

    }
}
