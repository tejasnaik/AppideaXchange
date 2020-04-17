({
    loadOptions: function (component, event, helper) {
        
        //getting URL of org
        var action = component.get("c.getBaseURL");
         action.setCallback(this, function(response){
                        if(response.getState() === 'SUCCESS'){
                            console.log('base URL '+response.getReturnValue());
                            component.set("v.baseURL", response.getReturnValue());
                        }
                    });
                    $A.enqueueAction(action); 
        component.set("v.ready", true);
       
        
        //create chart
        
    },
   
    hideSpinner :function (component, event, helper)
    {
        
        component.set("v.Spinner",false);
        helper.createChart(component);
    }
})