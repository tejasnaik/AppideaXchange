({
    fetchIdeaList : function(component, event, helper) {
        var action = component.get('c.getIdeaList');
        action.setParams({
            searchKeyword : component.get('v.searchKeyword'),
            filterType : component.get('v.filterType'),
            iLimit : component.get('v.limit')
        });
        
        component.set('v.isLoading', true);
        //$A.util.removeClass(component.find('Spinner'), 'slds-hide');
        action.setCallback(this, function(response){
            component.set('v.isLoading', false);
            //$A.util.addClass(component.find('Spinner'), 'slds-hide');
            $A.util.addClass(component.find('LoadinMoreText'), 'slds-hide');
            var state = response.getState();
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                console.log(result);
                component.set('v.ideas', result.IdeaList);
                component.set('v.ideaCount', result.IdeaCount);
            } else {
                console.log(response.getError());
            }
        });
        
        $A.enqueueAction(action);
    },
    likeOrUnlikeIdea : function (component, ideaId, voteType) {
        var action = component.get('c.submitIdeaVote');
        action.setParams({
            'ideaId' : ideaId,
            'voteType' : voteType
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var result = response.getReturnValue();
                if(result.success) {
                    if(result.response) {
                        var ideaObj = JSON.parse(result.response);
                        var ideas = component.get('v.ideas');
                        for(var iIndex = 0; iIndex < ideas.length; iIndex++) {
                            if(ideas[iIndex].Id === ideaObj.Id) {
                                ideas[iIndex].CogniAppEx__Like_Count__c = ideaObj.CogniAppEx__Like_Count__c;
                                ideas[iIndex].CogniAppEx__Dislike_Count__c = ideaObj.CogniAppEx__Dislike_Count__c;
                            }
                        }
                        
                        component.set('v.ideas', ideas);
                    } else {
                        var toastEvent = $A.get('e.force:showToast');
                        toastEvent.setParams({
                            'type' : 'info',
                            'message': result.message
                        });
                        toastEvent.fire();
                    }
                } else {
                    console.log(result);
                    var toastEvent = $A.get('e.force:showToast');
                    toastEvent.setParams({
                        'type' : 'error',
                        'message': result.message
                    });
                    toastEvent.fire();
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
    resetFilterAttributes : function (component) {
    	component.set('v.limit', 5);
        component.set('v.ideaCount', 0);
    }
})