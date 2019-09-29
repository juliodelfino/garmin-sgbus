using Toybox.Application;
using Toybox.Position;

class SgBusWidgetApp extends Application.AppBase {

	hidden var _delegate;
    
    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    
    	if (_delegate != null) {
	    	_delegate.dispose();
	    	_delegate = null;
    	}
    }

    // Return the initial view of your application here
    function getInitialView() {
    	var model = new SgBusModel();
    	_delegate = new SgBusWidgetDelegate(model);
		var view = new FavoritesView(_delegate);
		return [ view, _delegate ];
    }

}