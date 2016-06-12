using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Math as Math;
using Toybox.Position as Position;


class TestView extends Ui.WatchFace {

	function onHold(key){
		Sys.println("onHold");
		Ui.pushView(
			new Rez.Menus.MainMenu(),
			new GoldDistanceMenuDelegate(),
			Ui.SLIDE_UP);
			return true;
	}
	
	function distance(lat1, lon1, lat2, lon2){
		var x = deg2rad((lon2 - lon1)) * Math.cos(deg2rad((lat1 + lat2) / 2));
		var y = deg2rad(lat2 - lat1);
		var distance = Math.sqrt(x * x + y * y) * R;
		return distance.format("%d");
	}


  /*  function initialize() {
        WatchFace.initialize();
    }*/

    //! Load your resources here
    function onLayout(dc) {
       
    }

    //! Update the view
    function onUpdate(dc) {
        // Get and show the current time
        
    }

    function onShow() {
    }
    
    function onHide() {
    }
    

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
