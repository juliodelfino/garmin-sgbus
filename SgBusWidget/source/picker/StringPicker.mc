using Toybox.Graphics;
using Toybox.WatchUi;

class StringPicker extends WatchUi.Picker {
    public const ALPHANUM = 0;
    public const NUM = 1;
    const mNumberSet = "0123456789";
    const mCharacterSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ " + mNumberSet;
    hidden var mTitleText;
    hidden var mFactory;
    hidden var mInitialTitleText;
    protected var _onAcceptedCallback;

    function initialize(initialTitleText, mode, onAcceptedCallback) {
    	_onAcceptedCallback = onAcceptedCallback;
    	var charset = mode == NUM ? mNumberSet : mCharacterSet;
        mFactory = new CharacterFactory(charset, {:addOk=>true});
        mTitleText = "";

        var defaults = null;
        mInitialTitleText = initialTitleText;

        mTitle = new WatchUi.Text({:text=>mInitialTitleText, :font => Graphics.FONT_TINY, :locX =>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, :color=>Graphics.COLOR_WHITE});

        Picker.initialize({:title=>mTitle, :pattern=>[mFactory], :defaults=>defaults});
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }

    function addCharacter(character) {
        mTitleText += character;
        mTitle.setText(mTitleText);
    }

    function removeCharacter() {
        mTitleText = mTitleText.substring(0, mTitleText.length() - 1);

        if(0 == mTitleText.length()) {
            mTitle.setText(mInitialTitleText);
        }
        else {
            mTitle.setText(mTitleText);
        }
    }

    function getTitle() {
        return mTitleText.toString();
    }

    function getTitleLength() {
        return mTitleText.length();
    }

    function isDone(value) {
        return mFactory.isDone(value);
    }
    
    function onAccepted(text) {
    	if (_onAcceptedCallback != null) {
    		_onAcceptedCallback.invoke(text);
    	}
    }
}

class StringPickerDelegate extends WatchUi.PickerDelegate {
    hidden var mPicker;

    function initialize(picker) {
        PickerDelegate.initialize();
        mPicker = picker;
    }

    function onCancel() {
        if(0 == mPicker.getTitleLength()) {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }
        else {
            mPicker.removeCharacter();
        }
    }

    function onAccept(values) {
        if(!mPicker.isDone(values[0])) {
            mPicker.addCharacter(values[0]);
        }
        else {
            WatchUi.popView(WatchUi.SLIDE_LEFT);
            if(mPicker.getTitle().length() > 0) {
            	mPicker.onAccepted(mPicker.getTitle());
            }
        }
    }

}
