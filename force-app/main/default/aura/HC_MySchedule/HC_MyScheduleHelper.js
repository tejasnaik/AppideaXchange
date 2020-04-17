({
	loadRecords : function(component, event, helper) {
        helper.showLoading(component, event, helper);
        var lstHeaderKey = Object.keys(component.get('v.dataFields')); 
        component.set('v.lstHeaderKey',lstHeaderKey);
        var lstTemp = [];
        for(var iIndex = 0; iIndex < lstHeaderKey.length; iIndex++){
            lstTemp.push(component.get('v.dataFields')[lstHeaderKey[iIndex]]);
        }
        component.set('v.lstHeader',lstTemp);
        var action = component.get("c.getScheduleList");
       	action.setParams({
            "lstFieldName": component.get('v.listFields'),
            "whatType" : component.get('v.relatedTo'),
            "addDay":component.get('v.conditionValue'),
       });
        
       action.setCallback(this, function(response){
           	var state = response.getState();
            if (state === "SUCCESS") {
                var result = JSON.parse(response.getReturnValue());
                if(result) {
                    component.set("v.Records", result);
                    component.set("v.isDataLoad",true);
                    helper.hideLoading(component, event, helper);
                }
            }else if (state === "ERROR") {
                helper.showError(response);
                helper.hideLoading(component, event, helper);
            }
          
        });
        $A.enqueueAction(action); 
    },
    showResultError: function(result){
        if( !result.success )
            $A.error(result.message); 
    },
    showError : function(response) {
        var errors = response.getError();
        if (errors) {
            if (errors[0] && errors[0].message) {
                $A.error("Error message: " + 
                         errors[0].message);
            }
        } else {
            $A.error("Unknown error");
        } 
    },
    showLoading : function(component,event,helper){
      	// display spinner when aura:waiting (server waiting)
        component.set("v.toggleSpinner", true);  
    },
    hideLoading : function(component,event,helper){
   		// hide when aura:downwaiting
        component.set("v.toggleSpinner", false); 
        
    }
})