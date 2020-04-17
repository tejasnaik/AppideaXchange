({
    //To fetch attachments for the group using group record ID
    setGroupApp : function(component, event, helper) {        
        var action = component.get('c.appDetail');
        action.setParams({
            recordID : component.get("v.recordId")
        });
        action.setCallback(this, function( response ){
            var result = response.getReturnValue();
            if(result!=null){
                component.set("v.appDetails", result);
            }
        });
        $A.enqueueAction(action);
    },
    
    //To provide 'more' functionality on page     
    toggleMore : function(component, event, helper){
        var id = event.target.getAttribute('id');
        var newMoreId = id[0]+'more';
        var cmptMore = document.getElementById(newMoreId);
        $A.util.removeClass(cmptMore, 'slds-is-expanded');
        $A.util.addClass(cmptMore, 'slds-is-collapsed');
        var newLessId = id[0]+'less';
        var cmptLess = document.getElementById(newLessId);
        $A.util.removeClass(cmptLess, 'slds-is-collapsed');
        $A.util.addClass(cmptLess, 'slds-is-expanded');
    },
    
    //To provide 'less' functionality on page    
    toggleLess : function(component, event, helper){
        var id = event.target.getAttribute('id');
        var newLessId = id[0]+'less';
        var cmptLess = document.getElementById(newLessId);
        $A.util.removeClass(cmptLess, 'slds-is-expanded');
        $A.util.addClass(cmptLess, 'slds-is-collapsed');
        var newMoreId = id[0]+'more';
        var cmptMore = document.getElementById(newMoreId);
        $A.util.removeClass(cmptMore, 'slds-is-collapsed');
        $A.util.addClass(cmptMore, 'slds-is-expanded');
    },
})