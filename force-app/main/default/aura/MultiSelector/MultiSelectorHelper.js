({
    /*Split the string into list which user will provide for options*/
    GowithMyOption : function(cmp) {
        var adminOptions = cmp.get("v.MyOptions");
        if(adminOptions != null && adminOptions != undefined && adminOptions.trim() !='')
            cmp.set("v.OptionsValueList",adminOptions.split(';'));
    },
    
    
    /* Initilize function when user will provide recordid,object and picklist field to get option from server */
    onInit : function(cmp) {
        var action= cmp.get("c.onInit");
        action.setParams({ 
            "recordId": cmp.get("v.recordId"),
            "objectName" :cmp.get("v.ObjectName"),
            "fieldName":cmp.get("v.FieldName")
        });
        
        action.setCallback(this,function(response){
            if(response.getState() ==='SUCCESS'){
                var result = response.getReturnValue();
                console.debug(result);
                cmp.set("v.OptionsValueList",result.AvailablePicklist);
                cmp.set("v.SelectedValueList",result.SelectedPicklist);
                cmp.set("v.ObjectName",result.objectName);
                
                
            } else if (response.getState() === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    //console.log("Unknown error");
                }
            }
             //console.debug(response);
        });
        
        $A.enqueueAction(action);
        
    },
    
    /* This function will help to move value from one side to another side, 
     * means while user want to select any value or remove any value from seleted value
     * then this function will help to move from div
     */ 
    helperMethod : function(cmp,val,RemoverPicklist,AdderPicklist) {
        
        var valueSelected = val;//cmp.get("v.OptionsValueSelected");
        var RemoverBucket = cmp.get(RemoverPicklist);
        var AdderBucket = cmp.get(AdderPicklist);
        console.log(valueSelected);
        
        if(AdderBucket == null || AdderBucket == undefined )
            AdderBucket = [];
        
        if(valueSelected == null || valueSelected == undefined || valueSelected =='')
            return;
        
        if(RemoverBucket == null || RemoverBucket == undefined )
            return;
        
        var lrm =[];
        for(var i=0;i<RemoverBucket.length;i++){
            if(RemoverBucket[i] != valueSelected){
                lrm.push(RemoverBucket[i]);
            }
        }
        if(!this.checkValueAlreadyExist(AdderBucket,valueSelected)){
        	AdderBucket.push(valueSelected);
        	cmp.set(RemoverPicklist,lrm);
        	cmp.set(AdderPicklist,AdderBucket);
        }
    },
    
    /* This function will check if the value is already exit or not in selected/non-selected area*/
    checkValueAlreadyExist :function(AdderBucket,Value){
        if(AdderBucket.length>0){
            for(var i=0;i<AdderBucket.length;i++){
                if(AdderBucket[i]==Value)
                    return true;
            }
        }
        return false;
    },
    
    /* This will empty the string which hold the selected value in picklist*/
    reSetSelector:function(cmp){
        cmp.set("v.OptionsValueSelected",'');
        cmp.set("v.SelectedValueSelected",'');
    },
    
    /*
     * This function will help to save the record with selected picklist values if recordId, 
     * Object and Field Name is provide
     */
    savePicklist : function(cmp)
    {
        var recId = cmp.get("v.recordId");
        var ObjectName = cmp.get("v.ObjectName");
        var fieldName = cmp.get("v.FieldName");
        var val = cmp.get("v.SelectedValueList");
    
        var action = cmp.get("c.savePickList");
        action.setParams({
            "recordId" :recId,
            "fieldName":fieldName,
            "objectName":ObjectName,
            "vals":val
        });
        
         action.setCallback(this,function(response){
            if(response.getState() ==='SUCCESS'){
                var result = response.getReturnValue();
                //console.debug(result);
                if(result =='SUCCESS'){
                    console.debug(result); 
                   /* if(cmp.get("v.intenalBoolean")){
                        cmp.set("v.intenalBoolean",false);
                    	$A.get('e.force:refreshView').fire();
                    }*/
                }
            }else if (response.getState() === "ERROR") {
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
        $A.enqueueAction(action);
    }
    
    
})