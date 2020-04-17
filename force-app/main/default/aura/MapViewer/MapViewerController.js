({
	doInit : function(component, event, helper) {
		helper.mapCreater(component, event);
	},
    externalScriptsLoaded:function(component, event, helper) {
        helper.fireScriptsLoadCompleteEvent(component);
    }
    
})