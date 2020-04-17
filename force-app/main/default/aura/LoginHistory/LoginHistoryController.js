({
    doInit : function(component, event, helper) 
    {
        var no_of_rows = component.get("v.number_of_rows");
        console.log('no_of_rows : '+no_of_rows);
        var action = component.get("c.searchAll");
        action.setParams({"number_of_rows" : no_of_rows});
        action.setCallback(this, function(a) {
            var result = a.getReturnValue();
            component.set("v.LoginHistory", result);
            console.log(result);            
        });
        $A.enqueueAction(action);		
    },
    
    
    filter : function(component, event, helper) 
    {
        var no_of_rows = component.get("v.number_of_rows");
        //var target = event.getSource();
        var value = event.getParam("value");
        if(value=='Success')
        {
            var action = component.get("c.searchSuccess");
            action.setParams({"number_of_rows" : no_of_rows});
            action.setCallback(this, function(a) {
                var result = a.getReturnValue();
                component.set("v.LoginHistory", result);
                console.log(result);            
            });
            $A.enqueueAction(action);
        }
        else if(value=='Failure')
        {
            var action = component.get("c.searchFailure");
            action.setParams({"number_of_rows" : no_of_rows});
            action.setCallback(this, function(a) {
                var result = a.getReturnValue();
                component.set("v.LoginHistory", result);
                console.log(result);            
            });
            $A.enqueueAction(action); 
        }
            else if(value=="All")
            {
                var action = component.get("c.searchAll");
                action.setParams({"number_of_rows" : no_of_rows});
                action.setCallback(this, function(a) {
                    var result = a.getReturnValue();
                    component.set("v.LoginHistory", result);
                    console.log(result);            
                });
                $A.enqueueAction(action);	 
            }
    }
    
    
    
})