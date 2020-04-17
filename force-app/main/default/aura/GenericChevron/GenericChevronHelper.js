({
	setChevron : function(component, event, currentValue) {
		//Show spinner
        $A.util.removeClass(component.find('chevronSpinner'),'slds-hide');
        
        //Get controller function
        var sa_getPicklistValues = component.get('c.getPicklistValues');
  		//Set Parameters
        sa_getPicklistValues.setParams({
            'recordId' : component.get('v.recordId'),
            'fieldName' : component.get('v.picklistField')
        }); 
        //Set call back
        console.log('**suc'+component.get('v.recordId'));
        sa_getPicklistValues.setCallback(this, function(response){
            var state = response.getState();
            if(state==='SUCCESS'){
                console.log('**suc'+response.getReturnValue());
                var tarray = [], count=0, isFound=false;
                response.getReturnValue().forEach(function(record){
                    tarray.push(record);
                    if(currentValue!=record && !isFound){
                        count++;
                    }else{
                        isFound=true;
                    }
                });
                var chevronObj = new Object();
                chevronObj.currentStage = currentValue;
                chevronObj.currentStageIndex = count;
                chevronObj.stages = tarray;
                console.log('***cv'+JSON.stringify(chevronObj));
                component.set("v.cList",chevronObj);
                //Hide spinner
                $A.util.addClass(component.find('chevronSpinner'),'slds-hide');
            }
        });
        //Call function
        $A.enqueueAction(sa_getPicklistValues);
	}
})