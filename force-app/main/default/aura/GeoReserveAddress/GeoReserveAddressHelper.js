({
    getAddress : function(component) {
        var action = component.get('c.getAddressData'); 
        console.log(component.get("v.latitude"));
        action.setParams({
            latitude : ''+component.get("v.latitude"),
            longitude: ''+component.get("v.longitude"),
            recrodId :    component.get("v.recordId"),
            isShortName : component.get("v.isShortName"),
            FieldAPI : component.get("v.FieldAPI")
        });
        action.setCallback(this,function(response){
            component.set("v.inProgress",false);
            var state= response.getState();
            if(state =='SUCCESS'){
                var returnData =  JSON.parse(response.getReturnValue().body);
                //console.log(returnData);                
                component.set('v.StarndardAddress',response.getReturnValue().address);
                //console.log(response.getReturnValue().addressfull);
                //component.set('v.StarndardAddress',returnData.results[0].formatted_address);
                //this.showToast('Your address : '+returnData.results[0].formatted_address +', saved successfully on record','success','Address Info');
                this.showToast('Your address : '+response.getReturnValue().address +', saved successfully on record','success','Address Info');
                this.gotoURL(component.get("v.recordId"));
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction( action ); 
    },
    
    showToast : function(message, type, title) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type":type
        });
        toastEvent.fire();
    },
    
    gotoURL : function (recordId) {
        $A.get('e.force:refreshView').fire();
    }
    
    
})