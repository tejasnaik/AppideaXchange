({
	//Function to fetch link information from controller 
	//and bind the value to Link attribute
    doInit : function(component, event, helper) {
        var action = component.get("c.getLinks");
        action.setCallback(this, function(data) {
            component.set("v.Links", data.getReturnValue());
        });
        $A.enqueueAction(action);
	}
})