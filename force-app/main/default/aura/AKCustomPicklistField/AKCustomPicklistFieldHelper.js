({
    getOptionsServer: function(component) {
        var action = component.get("c.executeInit");
        action.setParams({
            "objectName":component.get("v.ObjectName"),
            "fieldName":component.get("v.FieldName"),
            "extraValue":''
        });
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                if(response.getReturnValue() !=null && response.getReturnValue() != undefined){
                    var dataValue = JSON.parse(response.getReturnValue()); 
                    if(dataValue.message = 'SUCCESS'){
                        component.set("v.isMultiPicklist",dataValue.ismuliPickList);
                        if(component.get("v.FieldLabel") == undefined || component.get("v.FieldLabel") =='')
                            component.set("v.FieldLabel",dataValue.fieldLabel);
                        this.doIntilitze(component,dataValue);
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
    
    
    doIntilitze: function(component,dataValue) {
        var tempOptions = new Array() ;
        var isError = false;
        if(component.get("v.PicklistOptionType") == 'STANDARDFIELD'){
        	if(dataValue.picklistOptions == undefined || dataValue.picklistOptions == null || dataValue.picklistOptions.length==0){
            	isError = true;
            }    
            
            for(var key in dataValue.picklistOptions){
                tempOptions.push({'label':dataValue.picklistOptions[key],'value':key,'isSelected':false});
            }
            
        }else if(component.get("v.PicklistOptionType") == 'PARENTLIST'){
            
            if(dataValue.optionList == undefined || dataValue.optionList == null || dataValue.optionList.length==0){
            	isError = true;
            }
            
            for(var i=0;i<dataValue.optionList.length;i++){
                tempOptions.push({'label':dataValue.optionList[i],'value':dataValue.optionList[i],'isSelected':false});
            }
        }
        
        if(isError){
			component.set("v.isError",isError);
            component.set("v.errMsg",'Please provide options value correctly.');
        }
        //component.set("v.OrignalOptions",tempOptions);
        this.checkSelectedValueInit(component,tempOptions);
    },
    
    checkSelectedValueInit:function(component,tempOptions){
        if(tempOptions == null)
            tempOptions = component.get("v.OrignalOptions");
        var isMulti = component.get("v.isMultiPicklist");
        var selectedItems = new Array() ;
        /*if(isMulti)
        {
            selectedItems = component.get("v.selectedOptions");
        }else{
        */
        var t = component.get("v.selectedOption");
            if(t != undefined && t != null && t !='')
                selectedItems = t.split(';'); 
        //}
        
        if(selectedItems != undefined && selectedItems != null && selectedItems.length>0 ){
            tempOptions.forEach(function(element) {
                for(var i = 0;i<selectedItems.length;i++){
                    if(!element.isSelected){
                        console.log('--------');
                        console.log(selectedItems[i]);
                        console.log(element.value);
                        //element.isSelected =  (element.value.indexOf(selectedItems[i])>-1);
                        element.isSelected =  element.value == selectedItems[i];
                    }
                }
            });
        }
        tempOptions = this.setSorting(tempOptions);
        component.set("v.OrignalOptions",tempOptions);
        var values = this.getSelectedValues(component);
        var labels = this.getSelectedLabels(component);
        this.setInfoText(component,labels);
    },
    
    checkSelectedValue:function(component,tempOptions){
        if(tempOptions == null)
            tempOptions = component.get("v.OrignalOptions");
        //var selectedItems = component.get("v.selectedOption");
        tempOptions = this.setSorting(tempOptions);
        component.set("v.OrignalOptions",tempOptions);
        var values = this.getSelectedValues(component);
        var labels = this.getSelectedLabels(component);
        this.setInfoText(component,labels);
    },
    
    setSorting: function(options) {
      options.sort(function compare(a,b) {
            if (a.value == 'All'){
                return -1;
            }
            else if (a.value < b.value){
                return -1;
            }
            if (a.value > b.value){
                return 1;
            }
            return 0;
        });
     	return options;
	},
    
    setInfoText: function(component, values) {
        
        if (values.length == 0) {
            component.set("v.infoText", "Select an option...");
        }
        if (values.length == 1) {
            component.set("v.infoText", values[0]);
        }
        else if (values.length > 1) {
            var ediable = component.get("v.isEditable");
            if(ediable){
                component.set("v.infoText", values.length + " options selected");
            }else{
                var v = '';
                for(var i = 0;i<values.length;i++){
                    v += v!=''?','+values[i]:values[i];
                }
                component.set("v.infoText",v);
            }
            
        }
    },
    
    getSelectedValues: function(component){
        var options = component.get("v.OrignalOptions");
        var values = [];
        options.forEach(function(element) {
            if (element.isSelected) {
                values.push(element.value);
            }
        });
        return values;
    },
    
    getSelectedLabels: function(component){
        var options = component.get("v.OrignalOptions");
        var labels = [];
        options.forEach(function(element) {
            if (element.isSelected) {
                labels.push(element.label);
            }
        });
        return labels;
    }
    
    
    
    
})