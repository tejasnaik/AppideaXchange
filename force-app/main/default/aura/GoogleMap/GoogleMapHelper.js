({
    eventListener : function(component, helper) { 
        window.addEventListener("message", function(event) {
            //Can enable origin control for more security
            //if (event.origin != vfOrigin) {
                // Not the expected origin: Reject the message!
                //return;
            //}
            // Handle the message
            if(event.data.state == 'LOADED'){
                //Set vfHost which will be used later to send message
                component.set('v.vfHost', event.data.vfHost);

                //Send data to VF page to draw map
                helper.sendToVF(component, helper);
            }
        }, false);
    },
    sendToVF : function(component, helper) {
        var message ={
			            "loadGoogleMap" : true,
            			"mapData":component.get('v.mapData'), 
            			"mapOptions": component.get('v.mapOptions'),  
                       	"mapOptionsCenter":component.get('v.mapOptionsCenter'),
            			"city":component.get('v.searchString'),
            			"dropdownValue":component.get('v.dropdownValue')
        		} ;

        
        //Send message to VF
        helper.sendMessage(component, helper, message);
    },
    sendMessage: function(component, helper, message){
        //Send message to VF
        message.origin = window.location.hostname;
        var vfWindow = component.find("vfFrame").getElement().contentWindow;
        vfWindow.postMessage(message, component.get("v.vfHost"));
    }
})