({
    navigateToShowMap : function(component, event, helper) {
        helper.showMap(component,event);
    },
    selectObject : function(component, event, helper) {
        helper.selectHelperObject(component);
    },
    onSelectChange : function(component, event, helper) {
        var selectedObject = component.find("objectPickListField").get("v.value");
        helper.selectHelperCountry(component);
       // helper.selectHelperState(component);
    }
})