package 
{
    import flash.display.*;
    import flash.media.*;
    import flash.utils.*;

    public class ImageRepository extends Object
    {

        public function ImageRepository()
        {
            return;
        }// end function

        public function getSound(param1:String) : Sound
        {
            return new Sound();
        }// end function

        public function getByteArray(param1:String) : ByteArray
        {
            return new ByteArray();
        }// end function

        public function getImage(param1:String) : BitmapData
        {
            return new BitmapData(16, 16);
        }// end function

    }
}
