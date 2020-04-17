({
	doInit : function(component, event, helper) {
        helper.getField(component);
    },
    scriptLoaded : function(component, event, helper) {
        helper.getDetails(component);
    },
})