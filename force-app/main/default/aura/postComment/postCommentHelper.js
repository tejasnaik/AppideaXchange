({
	getIdeaComments : function(component, event, helper) {
		var action = component.get('c.getIdeaCommentsFor');
        if(!component.get('v.ideaId')) return;
        
        action.setParams({
            ideaId : component.get('v.ideaId')
        });
        
        $A.util.removeClass(component.find('Spinner'), 'slds-hide');
        action.setCallback(this, function(response) {
            $A.util.addClass(component.find('Spinner'), 'slds-hide');
            var state = response.getState();
            if(state === 'SUCCESS') {
                var comments = response.getReturnValue();
                component.set('v.comments', comments);
            } else {
                console.log(response.getError());
            }
        });
        
        $A.enqueueAction(action);
	},
    submitIdeaComment : function(component, event, helper) {
        var action = component.get('c.submitIdeaComment');
        action.setParams({
            ideaId : component.get('v.ideaId'),
            description : component.get('v.description')
        });
        
        $A.util.removeClass(component.find('Spinner'), 'slds-hide');
        action.setCallback(this, function(response) {
            $A.util.addClass(component.find('Spinner'), 'slds-hide');
            var state = response.getState();
            if(state === 'SUCCESS') {
                var result = response.getReturnValue();
                if(result.success) {
                    var commentNew = JSON.parse(result.response);
                    var comments = component.get('v.comments');
                    commentNew.CogniAppEx__User__r.SmallPhotoUrl = commentNew.CogniAppEx__User__r.SmallPhotoUrl.replace('/marketplace/', '/');
                    comments.unshift(commentNew);
                    component.set('v.comments', comments);
                    helper.reset(component, event, helper);
                    
                    var ideaCreationEvent = component.getEvent('ideaCreationEvent');
                    ideaCreationEvent.setParam('data', { type : 'IDEA_COMMENT', ideaId : component.get('v.ideaId'), comments : comments });
                    ideaCreationEvent.fire();
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
        
        $A.enqueueAction(action);
    },
    reset : function(component, event, helper) {
        component.set('v.description', '');
    }
})