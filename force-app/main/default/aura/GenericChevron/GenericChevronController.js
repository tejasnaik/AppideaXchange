({
    handleUpdatedRecord : function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            // record is loaded (render other component which needs record data value)
            helper.setChevron(component, event, component.get('v.simpleRecord')[component.get('v.picklistField')]);
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
            helper.setChevron(component, event, component.get('v.simpleRecord')[component.get('v.picklistField')]);
        } else if(eventParams.changeType === "ERROR") {
            console.log('Error');
        }
    }
})