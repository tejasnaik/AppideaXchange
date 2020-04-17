({
    doInit : function(component, event, helper) {
        
        //Send LC Host as parameter to VF page so VF page can send message to LC; make it all dynamic
        component.set('v.lcHost', window.location.hostname);
        helper.eventListener(component, helper);
        
    },
    populateValue : function(component, event, helper) {
        var params = event.getParam('arguments');
        component.set('v.mapData',params.searchData);
        helper.sendToVF(component, helper);
    },
    populateDropdownValue : function(component, event, helper) {
        var params = event.getParam('arguments');
        component.set('v.dropdownValue',params.dropdownValue);
        //helper.sendToVF(component, helper);
        
    }
     
})