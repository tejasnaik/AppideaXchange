({
	setUpData : function(component, event, helper) {
		//Get server action
        var sa_getUserContext = component.get('c.getUserContext');
        //Set Params - No need 
        //define callback
        sa_getUserContext.setCallback(this, function(response){
            //Check response state
            var state = response.getState();
            var responseIs = response.getReturnValue();
            if(state==='SUCCESS'){
                component.set('v.userContext',responseIs);
                //Set range options
                var opts = [
                    {value:"Today",label:"Today"},
                    {value:"Tomorrow",label:"Tomorrow"},
                    {value:"Overdue",label:"Overdue"},
                    {value:"ThisWeek",label:"Later this Week"},
                    {value:"NextWeek",label:"Next Week"}
                ];
               component.set('v.rangeOptions',opts);
                //Get tasks details
                this.getTileDetails(component, event, helper);
            }else{
                console.log('***Response returned from server: Error>'+JSON.stringify(responseIs));
            }
        });
        //Invoke server action
        $A.enqueueAction(sa_getUserContext);
	},
    getTileDetails: function(component, event, helper){
        //Get server action
        var sa_getTileDetails = component.get('c.getTileDetails');
        var rangeSelectVar, rangeSelectLabel;
        if(component.get('v.showRange')){
            rangeSelectVar = component.find('rangeSelect').get('v.value');
        }
        if(!rangeSelectVar){
            //Pick the default one
            rangeSelectVar = component.get('v.defaultTaskRange');
        }
        //Get the title
        var rangeOptionsVar = component.get('v.rangeOptions');
        rangeOptionsVar.forEach(function(option){
            if(rangeSelectVar==option.value){
                rangeSelectLabel=option.label;
            }
        });
        component.set('v.title',rangeSelectLabel+'\'s Tasks:');
        console.log('****rangeSelectVar:'+rangeSelectVar);
        //Set Params
        sa_getTileDetails.setParams({
            'fields':component.get('v.fields').split(','),
            'objName':component.get('v.objName'),
            'imageField':component.get('v.imageField'),
            'taskRange':rangeSelectVar,
            'fieldsLabelMap':component.get('v.fieldsLabelMap').split(','),
        });
        //define callback
        sa_getTileDetails.setCallback(this, function(response){
            //Check response state
            var state = response.getState();
            var responseIs = response.getReturnValue();
            if(state==='SUCCESS'){
                console.log('***Response returned from server: Success>'+JSON.stringify(responseIs));
                component.set('v.patientList',responseIs);
				$A.util.toggleClass(component.find("mySpinner"), "slds-hide");
                //Check the task range
                var taskCount=0;
                responseIs.forEach(function(rec){
                    taskCount+=rec.taskCount;
                });
                var tr = rangeSelectVar;
                if(tr=='Today'){
                    component.set('v.todaySize',taskCount);
                }else if(tr=='Tomorrow') {
                    component.set('v.tomorrowSize',taskCount);
                }else if(tr=='Overdue') {
                    component.set('v.overdueSize',taskCount);
                }else if(tr=='ThisWeek') {
                    component.set('v.thisWeekSize',taskCount);
                }else if(tr=='NextWeek') {
                    component.set('v.nextWeekSize',taskCount);
                }
            }else{
                console.log('***Response returned from server: Error>'+JSON.stringify(responseIs));
            }
        });
        //Invoke server action
        $A.enqueueAction(sa_getTileDetails);
    }
})