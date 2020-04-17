({
	submitIdea : function(component, event, helper) {
        var ideaNew = component.get('v.idea');
        var action = component.get('c.submitIdea');
        action.setParams({
            title : ideaNew.CogniAppEx__Title__c,
            category : ideaNew.CogniAppEx__Category__c,
            description : ideaNew.CogniAppEx__Description__c, 
            pocId : ideaNew.CogniAppEx__POC__c,
            Vertical : ideaNew.CogniAppEx__Vertical__c,
            Cloud : ideaNew.CogniAppEx__Cloud__c
        });
        
        $A.util.removeClass(component.find('Spinner'), 'slds-hide');
        action.setCallback(this, function(response) {
            $A.util.addClass(component.find('Spinner'), 'slds-hide');
            var state = response.getState();
            if(state === 'SUCCESS') {
                var result = response.getReturnValue();
                if(result.success) {
                    result.data = JSON.parse(result.response);
                    result.data.CogniAppEx__Idea_Comments__r = [];
                    helper.reset(component, event, helper);
                    
                    var ideaCreationEvent = component.getEvent('ideaCreationEvent');
                    ideaCreationEvent.setParam('data', { type : 'IDEA', record : result.data });
                    ideaCreationEvent.fire();
                    
                    component.set('v.isVisible', false);
                    
                    var toastEvent = $A.get('e.force:showToast');
                    toastEvent.setParams({
                        'type' : 'success',
                        'message': 'Thank You. Your idea has been submitted successfully.'
                    });
                    toastEvent.fire();
                } else {
                   
                    component.set('v.errorMessage', result.message);
                    console.log(result);
                }
            } else {
               
                component.set('v.errorMessage', result.message);
                
                var errors = response.getError();
                if (errors) {
                    console.log(response.getError());
                } else {
                    console.log("Unknown error");
                }
            }
        });
        helper.reset(component, event, helper);
        $A.enqueueAction(action);
	},
    reset : function(component, event, helper) {
        var ideaNew = {
            sobjectType : 'CogniAppEx__Idea__c',
            CogniAppEx__Title__c : '',
            CogniAppEx__Category__c : '',
            CogniAppEx__Description__c : '',
            CogniAppEx__Vertical__c:'',
            CogniAppEx__Cloud__c:'',
            CogniAppEx__POC__c:''
        };
        
        component.set('v.idea', ideaNew);
    },
    
    getcatagory  : function(component){
        var myaction=component.get('c.getpicklistvalues');
        myaction.setParams({objectname:'CogniAppEx__Idea__c',fieldname:'CogniAppEx__Category__c'});
         myaction.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var result = response.getReturnValue();
                component.set('v.categoryList',result);
               
            }
            });
        $A.enqueueAction(myaction);
    },
    
     getcloud  : function(component){
         var myaction=component.get('c.getpicklistvalues');
        myaction.setParams({objectname:'CogniAppEx__Idea__c',fieldname:'CogniAppEx__Cloud__c'});
          myaction.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var result = response.getReturnValue();
                component.set('v.cloudList',result);
                
            }
            });
        $A.enqueueAction(myaction);
        
    },
    
     getvertical  : function(component){
         var myaction=component.get('c.getpicklistvalues');
        myaction.setParams({objectname:'CogniAppEx__Idea__c',fieldname:'CogniAppEx__Vertical__c'});
          myaction.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var result = response.getReturnValue();
                component.set('v.verticalList',result);
                
            }
            });
        $A.enqueueAction(myaction);
        
    },
    
})