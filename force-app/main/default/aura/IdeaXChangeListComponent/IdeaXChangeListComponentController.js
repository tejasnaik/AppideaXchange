({
	doInit : function(component, event, helper){
        helper.fetchIdeaList(component, event, helper);
    },
    onFilterChange : function(component, event, helper){
        helper.resetFilterAttributes(component);
        helper.fetchIdeaList(component, event, helper);
    },
    onSearchIdeaClick : function(component, event, helper){
        helper.resetFilterAttributes(component);
        helper.fetchIdeaList(component, event, helper);
    },
    onSearchIdeaKeyup : function(component, event, helper){
        if(event.getParams().keyCode == 13){
            helper.resetFilterAttributes(component);
            helper.fetchIdeaList(component, event, helper);
        }
    },
    submitIdea : function(component, event, helper) {
        component.find('PostIdea').set('v.isVisible', true);
        component.find('PostIdea').set('v.errorMessage', '');
    },
    postComment : function(component, event, helper) {
        var ideaId = event.currentTarget.getAttribute('data-id');
        component.find('PostComment').set('v.ideaId', ideaId);
        component.find('PostComment').set('v.isVisible', true);
        component.find('PostComment').set('v.errorMessage', '');
    },
    likeOrUnlikeIdea : function(component, event, helper) {
        var ideaId = event.currentTarget.getAttribute('data-id');
        var voteType = event.currentTarget.getAttribute('data-vote-type');
        
        helper.likeOrUnlikeIdea(component, ideaId, voteType);
    },
    handlerIdeaCreationEvent : function(component, event, helper) {
    	var data = event.getParam('data');
        var ideas = component.get('v.ideas');
        console.log(data);
        if(data.type === 'IDEA') {
            ideas.unshift(data.record);
        } else if(data.type === 'IDEA_COMMENT') {
            for(var iIndex = 0; iIndex < ideas.length; iIndex++) {
                if(data.ideaId === ideas[iIndex].Id) {
                    ideas[iIndex].CogniAppEx__Idea_Comments__r = data.comments;
                }
            }
        }
        
        component.set('v.ideas', ideas);        
    }
})