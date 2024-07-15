import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class WatchFaceView extends WatchUi.WatchFace {
    private var _font_32 as FontResource?;
    private var _font_56 as FontResource?;
    private var _font_96 as FontResource?;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
        _font_32 = WatchUi.loadResource($.Rez.Fonts.id_font_roboto_regular_32) as FontResource;
        _font_56 = WatchUi.loadResource($.Rez.Fonts.id_font_roboto_regular_56) as FontResource;
        _font_96 = WatchUi.loadResource($.Rez.Fonts.id_font_roboto_regular_96) as FontResource;
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var font_32 = _font_32;
        var font_56 = _font_56;
        var font_96 = _font_96;

        var width = dc.getWidth();
        var height = dc.getHeight();

        // Fill the entire background with Black.
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_WHITE);
        dc.fillRectangle(0, 0, width, height);

        // Set the text and background colors
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_DK_GRAY);

        // Get and show the current date
        var date = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var date_string = date.day_of_week + ", " + date.day.format("%u") + " " + date.month;

        dc.drawText(width / 2, 12 * height / 100, font_32, date_string, Graphics.TEXT_JUSTIFY_CENTER);

        // Get and show the current time
        var clockTime = System.getClockTime();
        var hour = clockTime.hour % 12;
        if (hour == 0) {
            hour = 12;
        }
        var timeString = Lang.format("$1$:$2$", [hour, clockTime.min.format("%02d")]);
        dc.drawText(width / 2, 27 * height / 100, font_96, timeString, Graphics.TEXT_JUSTIFY_CENTER);

        var meridian = clockTime.hour <= 12 ? "AM" : "PM";
        var color = clockTime.hour <= 12 ? Graphics.COLOR_YELLOW : Graphics.COLOR_BLUE;
        dc.setColor(color, Graphics.COLOR_DK_GRAY);
        dc.drawText(80 * width / 100, 65 * height / 100, Graphics.FONT_MEDIUM, meridian, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_DK_GRAY);

        // Get and show the current heart rate
        var heartRate = Activity.getActivityInfo().currentHeartRate;
        var heartRateText = "";
        if (heartRate) {
            heartRateText = heartRate.format("%u");
        } else {
            heartRateText = "--";
        }
        dc.drawText(width / 2, 70 * height / 100, font_56, heartRateText, Graphics.TEXT_JUSTIFY_CENTER);
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
