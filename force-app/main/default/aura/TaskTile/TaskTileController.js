({
    doInit : function (component, event, helper){
        helper.setUpData(component, event, helper);
    },
    openPatientDetails : function(component, event, helper) {
		//Get user context
		var userContextIs = component.get('v.userContext');
        if(userContextIs.userContext=='Theme3'){
            //Open in Portal
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": 'patient360?cid='+event.target.id
            });
            urlEvent.fire(); 
        }else{
            //Open in LEX
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": event.target.id,
            });
            navEvt.fire();
        }
	},
    handleOnChange : function(component, event, helper){
        $A.util.toggleClass(component.find("mySpinner"), "slds-hide");
        helper.getTileDetails(component, event, helper);
    }
})