package 
{
    import GgVector3d.*;

    public class GgVector3dCyl extends GgVector3dEqui
    {

        public function GgVector3dCyl(param1:Number = 1, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0)
        {
            super(param1, param2, param3, param4, param5);
            return;
        }// end function

        override public function clone() : GgVector3d
        {
            var _loc_1:* = null;
            _loc_1 = new GgVector3dCyl(r, theta, phi, u, v);
            _loc_1.x = x;
            _loc_1.y = y;
            _loc_1.z = z;
            _loc_1.px = px;
            _loc_1.py = py;
            _loc_1.pz = pz;
            return _loc_1;
        }// end function

        override public function type() : int
        {
            return 2;
        }// end function

        override public function toXYZ() : void
        {
            x = r * Math.sin(theta);
            y = phi;
            z = r * Math.cos(theta);
            rotx_xyz(aphi);
            return;
        }// end function

        override public function toString() : String
        {
            return "Cyl (" + r + "," + theta * 180 / Math.PI + "," + phi * 180 / Math.PI + ") - (" + px + "," + py + ") , (u:" + u + ",v:" + v + ")";
        }// end function

    }
}
