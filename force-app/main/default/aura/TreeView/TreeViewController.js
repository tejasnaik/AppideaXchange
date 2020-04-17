({
	doInit : function(component, event, helper) {
        
        var treeConfigMap = ({'labelProperties': ['Name'], 
                              'expandProperties': [component.get("v.childObj")], 
                              'isSelectable': true, 
                              'isNodeSelectionEnabled': true, 
                              'expandLevel': 1});
        
        component.set("v.treeConfig",treeConfigMap);
        
        var action = component.get("c.getData");
        
        action.setParams({ parent : component.get("v.parentObj"),
                           child : component.get("v.childObj"),
                        });
        
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS")
                component.set("v.treeItems", response.getReturnValue());
            else
                console.log(response);
        });
        $A.enqueueAction(action);
    },
    
    handleTreeSelection : function(component, event, helper) {
        var selection = event.getParam("selection");
        var data = JSON.stringify(selection);
        window.open('/'+JSON.parse(data).Id);
    }
})