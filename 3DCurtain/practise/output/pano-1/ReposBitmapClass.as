package 
{
    import flash.display.*;
    import flash.events.*;

    public class ReposBitmapClass extends Bitmap
    {
        private var reposId:String;
        private static var imageRepos:ImageRepository = new ImageRepository();

        public function ReposBitmapClass(param1:String)
        {
            this.reposId = param1;
            addEventListener(Event.ENTER_FRAME, this.checkLoaded, false, 0, true);
            return;
        }// end function

        private function checkLoaded(event:Event) : void
        {
            var _loc_2:* = null;
            try
            {
                _loc_2 = imageRepos.getImage(this.reposId);
                bitmapData = _loc_2;
                removeEventListener(Event.ENTER_FRAME, this.checkLoaded);
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

    }
}
