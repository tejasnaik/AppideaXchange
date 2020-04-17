({
	getOptionsServer: function(component) {
        var action = component.get("c.executer");
        action.setParams({
            "objectName":		component.get("v.ObjectName"),
            "controllingField":	component.get("v.ControlledField"),
            "dependentField":	component.get("v.DependedField"),
        });
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                /*console.log(response.getReturnValue());
                console.log(JSON.parse(response.getReturnValue()));*/
                if(response.getReturnValue() !=null && response.getReturnValue() != undefined){
                    var dataValue = JSON.parse(response.getReturnValue()); 
                    component.set('v.allInfoMap',dataValue);
                    if(dataValue.msg == 'Done'  && dataValue.isSuccess ){
                       console.log(dataValue.isSuccess);
                       if(dataValue.controllingInfo != null && dataValue.controllingInfo != undefined )	
                       {
                            var ControlFieldOptions = [];
                        	for(var key in dataValue.controllingInfo)
                                ControlFieldOptions.push(key);
                            component.set('v.controlFieldOptions',ControlFieldOptions);
                       }
                       component.set('v.isDependentFieldMultiPicklist',dataValue.isDependendFieldMultiPickList);
                       this.controledFieldValueChangerExecute(component, null ); 
                    }else{
                    }
                }
            }else if (response.getState() === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) console.log("Error message: " + errors[0].message);
                } else console.log("Unknown error");
            }
        });
        $A.enqueueAction(action);
    },
    
    
    controledFieldValueChangerExecute : function(component, event ) {
        var parentSelectedValue= component.get('v.SelectedControllingValue');
        var dependentFieldOptionsNew = [];
        component.set("v.dependentFieldOptions",dependentFieldOptionsNew);
        //component.set("v.SelectedDependendValue",'');
        if(parentSelectedValue != null && parentSelectedValue != undefined ){
            var allInfoObject = component.get("v.allInfoMap");
            for(var key in allInfoObject.controllingInfo){
                if(key == parentSelectedValue){
                  	dependentFieldOptionsNew = allInfoObject.controllingInfo[key];        
                }
            }
            component.set("v.dependentFieldOptions",dependentFieldOptionsNew);
        }
    },
    
})