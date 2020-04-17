({
	Test : function(component, event, helper) {
		var action = component.get("c.testMe");
        action.setCallback(this,function(response){
            console.log(response.getState());
            console.log(response.getReturnValue());
        });
        
        $A.enqueueAction(action);
	}
})