({
	showPastComments: function(component, event, helper) {
		component.set("v.showPastComment",true);
        helper.refreshPastCommentsPannel(component);
	},
    
    countCharRem: function(component, event, helper) {
		var comm = event.currentTarget.value;
        if(comm !=null && comm !=''){
            component.set("v.charRemain",240-comm.length);
        }else{
             component.set("v.charRemain",240);
        }
	},
    
    shareComment: function(component, event, helper) {
		var commentBody = component.find("comment-text-input2").getElement().value;
        if(commentBody ==null || commentBody =='' || commentBody ==undefined || commentBody.trim() ==''){
            alert('Please enter your comment first.');
        }else{
            var r = helper.shareComment(component,commentBody);
            if(r == 'SHARED'){
                
            }
        }
    }
    
})