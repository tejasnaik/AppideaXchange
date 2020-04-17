({
    // Initialize to generate printable view web page
    init : function(component, event, helper) {
        var action = component.get("c.getURL"); 
        action.setParams({
            recordId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
            var result = response.getReturnValue();
            component.set("v.viewURL", result);
            helper.getViewURL(component, event);
        });
        $A.enqueueAction(action);
    }    
})