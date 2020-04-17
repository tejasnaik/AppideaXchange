({
	doInit : function(component, event, helper) {
		helper.getRelatedComments(component);
	},
    
    showMoreComments : function(component, event, helper) {
        var curr = component.get("v.offSet");
        component.set("v.offSet", curr+5);
        helper.getRelatedComments(component);
    }
})