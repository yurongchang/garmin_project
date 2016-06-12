using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
//using Toybox.System as Sys;
//using Toybox.Lang as Lang;
using Toybox.UserProfile as User;
using Toybox.Math as Math;

class HRCirclesTestView extends Ui.DataField {

	const age = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT).year - User.getProfile().birthYear.toNumber();
	
	const maxHR = 220 - age;
	var hr = 0;
	const restingHR = User.getProfile().restingHeartRate.toNumber();
	const hrr = maxHR - restingHR;
	
	var timeInZone = new[5];
	var zones = [48,58,67,77,88];
	var timeInZone = [0,0,0,0,0];
	
	const BAR_THICKNESS = 7;
	const ARC_MAX_ITERS = 300;
	
	var numberColor = Gfx.COLOR_WHITE;
	
	const fullCircle = Math.PI *2 ;

    function initialize() {
       // WatchFace.initialize();
       for(var i = 0; i < zones.size(); i++){
       		zones[i] = ((zones[i] / 100f) * hrr).toNumber();
       }
    }
    
    function compute(info){
    	
    	if(info.currentHeartRate == null){
    		return;
    	}
    	
    	hr = info.currentHeartRate - restingHR;
    	
    	if(hr >zones[0] && hr <= zones[1]){
    		timeInZone[0] += 1;
    		numberColor = Gfx.COLOR_DK_GREEN;
    	}
    	else if(hr > zones[1] && hr <= zones[2]){
    		timeInZone[1] += 1;
    		numberColor = Gfx.COLOR_GREEN;
    	}
    	else if(hr > zones[2] && hr <= zones[3]){
    		timeInZone[2] += 1;
    		numberColor = Gfx.COLOR_YELLOW;
    	}
    	else if(hr > zones[3] && hr <= zones[4]){
    		timeInZone[3] += 1;
    		numberColor = Gfx.COLOR_ORANGE;
    	}
    	else if(hr > zones[4]){
    		timeInZone[4] += 1;
    		numberColor = Gfx.COLOR_RED;
    	}
    	
    	return info.currentHeartRate;
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        // Get and show the current time
        /*var clockTime = Sys.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        var view = View.findDrawableById("TimeLabel");
        view.setText(timeString);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);*/
        
        	if(hr <= 0.0)
    	{
    		return;
    	}
    	
    	// normalize zones with total time
		var sum = 0.0;
		for(var i = 0; i < timeInZone.size(); i++)
       	{
 			sum += timeInZone[i];
		}
		
		if(sum <= 0.0)
		{
			return;
		}
    		
    	dc.clear();
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_RED);
		dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
		dc.setColor(numberColor, Gfx.COLOR_TRANSPARENT);
		
		dc.drawText(dc.getWidth()/2, dc.getHeight()/2 - 48, Gfx.FONT_NUMBER_HOT, (hr + restingHR).toString(), Gfx.TEXT_JUSTIFY_CENTER);
  
		// width & height assumed equal to draw arc of a circle
		var c = dc.getWidth()/2; 
		//var cy = dc.getHeight()/2;
		
		// draw arc for each zone
		drawArc(dc, c, c, c-BAR_THICKNESS,     (fullCircle * timeInZone[0]) / sum, Gfx.COLOR_DK_GREEN);
		drawArc(dc, c, c, c-BAR_THICKNESS * 2, (fullCircle * timeInZone[1]) / sum, Gfx.COLOR_GREEN);
		drawArc(dc, c, c, c-BAR_THICKNESS * 4, (fullCircle * timeInZone[2]) / sum, Gfx.COLOR_YELLOW);
		drawArc(dc, c, c, c-BAR_THICKNESS * 6, (fullCircle * timeInZone[3]) / sum, Gfx.COLOR_ORANGE);
		drawArc(dc, c, c, c-BAR_THICKNESS * 8, (fullCircle * timeInZone[4]) / sum, Gfx.COLOR_RED);
    }
    
    function drawArc(dc, cx, cy, radius, theta, color) {
    
        dc.setColor(color, Gfx.COLOR_BLACK);

        var iters = ARC_MAX_ITERS * (theta / (2 * Math.PI));
        var dx = 0;
        var dy = -radius;
        var ctheta = Math.cos(theta/(iters - 1));
        var stheta = Math.sin(theta/(iters - 1));

        dc.fillCircle(cx + dx, cy + dy, BAR_THICKNESS);

        for(var i=1; i < iters; ++i) {
            var dxtemp = ctheta * dx - stheta * dy;
            dy = stheta * dx + ctheta * dy;
            dx = dxtemp;
            dc.fillCircle(cx + dx, cy + dy, BAR_THICKNESS);
        }
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
