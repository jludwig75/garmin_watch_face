import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class WatchFaceView extends WatchUi.WatchFace {
    private var _font_date as FontResource?;
    private var _font_heart_rate as FontResource?;
    private var _font_time as FontResource?;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
        _font_date = WatchUi.loadResource($.Rez.Fonts.id_font_date) as FontResource;
        _font_time = WatchUi.loadResource($.Rez.Fonts.id_font_time) as FontResource;
        _font_heart_rate = WatchUi.loadResource($.Rez.Fonts.id_font_heart_rate) as FontResource;
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var font_date = _font_date;
        var font_time = _font_time;
        var font_heart_rate = _font_heart_rate;

        var width = dc.getWidth();
        var height = dc.getHeight();

        var backgroundColor = Graphics.COLOR_DK_GRAY;
        var foregroundColor = Graphics.COLOR_WHITE;

        // Fill the entire background with Black.
        dc.setColor(backgroundColor, foregroundColor);
        dc.fillRectangle(0, 0, width, height);

        // Set the text and background colors
        dc.setColor(foregroundColor, backgroundColor);

        // Get and show the current date
        var date = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var date_string = date.day_of_week + ", " + date.day.format("%u") + " " + date.month;

        dc.drawText(width / 2, 11 * height / 100, font_date, date_string, Graphics.TEXT_JUSTIFY_CENTER);

        // Get and show the current time
        var clockTime = System.getClockTime();
        var hour = clockTime.hour % 12;
        if (hour == 0) {
            hour = 12;
        }
        var timeString = Lang.format("$1$:$2$", [hour, clockTime.min.format("%02d")]);
        dc.drawText(width / 2, 25 * height / 100, font_time, timeString, Graphics.TEXT_JUSTIFY_CENTER);

        // Get and show the current time merdian
        var meridian = clockTime.hour < 12 ? "AM" : "PM";
        var color = clockTime.hour < 12 ? Graphics.COLOR_YELLOW : Graphics.COLOR_BLUE;
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(77 * width / 100, 67 * height / 100, Graphics.FONT_MEDIUM, meridian, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(foregroundColor, backgroundColor);

        // Get and show the current heart rate
        var heartRate = Activity.getActivityInfo().currentHeartRate;
        var heartRateText = "";
        if (heartRate) {
            heartRateText = heartRate.format("%u");
        } else {
            heartRateText = "--";
        }
        dc.drawText(width / 2, 73 * height / 100, font_heart_rate, heartRateText, Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
