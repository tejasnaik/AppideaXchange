({
    selectHelperObject : function(component) {
        var action = component.get("c.newList");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state == "SUCCESS") {
                component.set("v.ObjectList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    selectHelperCountry : function(component) {
        var selectedObject = component.find("objectPickListField").get("v.value");
        var action = component.get("c.showFields");
        action.setParams({
            selectedObject : selectedObject
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.FieldCountryList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    selectHelperState : function(component) {
        var selectedObject = component.find("objectPickListField").get("v.value");
        var action = component.get("c.showFieldState");
        action.setParams({
            selectedObject : selectedObject
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.FieldStateList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    showMap: function(component,event) {
        var selectedObject = component.find("objectPickListField").get("v.value");
        var selectedCountry = component.find("FieldCountryList").get("v.value");
      //  var selectedState = component.find("FieldStateList").get("v.value");
        if(selectedObject == undefined){
            alert('No Object selected');
            return;
        }
        if(selectedCountry == undefined){
            alert('No Country selected');
            return;
        }
      /*  if(selectedState == undefined){
            alert('No State selected');
            return;
        }*/
        var action = component.get("c.findAll");
        action.setParams({
            selectedObjectA : selectedObject,
            selectedCountryA : selectedCountry,
           // selectedStateA : selectedState
        });
        action.setCallback(this, function(a) {
            var componentEvent = component.getEvent("recordsLoaded");
            componentEvent.setParams({
                "sObjectEvent": a.getReturnValue(),
                "selObjectEvent" : selectedObject
            });
            componentEvent.fire();
        });
        $A.enqueueAction(action);
    }
})