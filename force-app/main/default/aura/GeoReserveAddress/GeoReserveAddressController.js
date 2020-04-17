({
	handleClick : function(component, event, helper){
			
        	var isAlreadyInProgres = component.get("v.inProgress");
        	if(isAlreadyInProgres == true){
            	return;
        	}
        	var errorCause;
            if (navigator.geolocation) {
                //console.log('Getting Location')
                navigator.geolocation.getCurrentPosition(showPosition);
            } else {
                x.innerHTML = "Geolocation is not supported by this browser.";
            }
        
            function showPosition(position) {
                component.set("v.latitude",position.coords.latitude);
                component.set("v.longitude",position.coords.longitude);
                component.set("v.inProgress",true);
                helper.getAddress(component);
            }
			
			function showError(error) {
                switch(error.code) {
                    case error.PERMISSION_DENIED:
                        errorCause = "User denied the request for Geolocation."
                        break;
                    case error.POSITION_UNAVAILABLE:
                        errorCause = "Location information is unavailable."
                        break;
                    case error.TIMEOUT:
                        errorCause = "The request to get user location timed out."
                        break;
                    case error.UNKNOWN_ERROR:
                        errorCause = "An unknown error occurred."
                        break;
                }
                console.log(errorCause);
		}        
	}
})