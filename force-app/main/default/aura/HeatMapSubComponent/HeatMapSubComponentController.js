({
    doInit : function(component, event, helper) {
        var action = component.get("c.fetchVfPageUrl");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state == "SUCCESS") {
                component.set("v.vfHost", response.getReturnValue());
                //Send LC Host as parameter to VF page so VF page can send message to LC; make it all dynamic
                component.set('v.lcHost', window.location.hostname);
                var vfOrigin = "https://" +  component.get("v.vfHost");
                //Add message listener
                window.addEventListener("message", function(event) {
                    //Can enable origin control for more security
                    if (event.origin != vfOrigin) {
                        // Not the expected origin: Reject the message!
                        return;
                    }
                    // Handle the message
                    if(event.data.state == 'LOADED'){
                        //Set vfHost which will be used later to send message
                        component.set('v.vfHost', event.data.vfHost);
                        //Send data to VF page to draw map
                        helper.sendToVF(component, helper);
                    }
                }, false);
            }
        });
        $A.enqueueAction(action);
    }
})