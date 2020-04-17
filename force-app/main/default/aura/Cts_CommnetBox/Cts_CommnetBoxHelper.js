({
    shareComment : function(cmp,commentBody) {
        cmp.set("v.spinner",true);
        var action= cmp.get("c.commentShareCaller");
        console.log(cmp.get("v.ItemId"));
        action.setParams({
            "body" : commentBody,
            "CommentForID" : cmp.get("v.ItemId"),
            "commentById" :null
        });
        action.setCallback(this,function(response){
            console.log(response);
            cmp.set("v.spinner",false);
            if(response.getState() == 'SUCCESS'){
                console.log(response.getReturnValue());
                var returnValue = JSON.parse(response.getReturnValue());
                if(returnValue.isSuccess == true){
                    cmp.find("comment-text-input2").getElement().value = '';
                    cmp.set("v.charRemain",240);
                    this.showToast(returnValue.isSuccess,returnValue.message);
                    
                    if(cmp.get("v.showPastComment"))
                    	this.refreshPastCommentsPannel(cmp);
                    
                }else{
                    this.showToast(returnValue.isSuccess,'Getting some issue'+returnValue.message);
                }
                
            }else if(response.getState() == 'ERROR' ){
                var errors = res.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    showToast : function( isSccess, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":isSccess ?'success':'warning',
            "title":isSccess ?'Success':'Information',
            "message": message
        });
        toastEvent.fire();
    },
    
    refreshPastCommentsPannel : function( component) {
        $A.createComponent("c:Cts_PastComments",
                               {
                                    "ItemId" : component.get("v.ItemId"),
                               },
                               function(cmp, status, errorMessage){
                                   component.set("v.spinner",false);
                                   var divComponent = component.find("pastCommentsPannel");
                                   if (divComponent != null && divComponent != undefined && divComponent.isValid()) 
                                   {
                                       var body = divComponent.get("v.body");
                                       body =[];
                                       body.push(cmp);
                                       divComponent.set("v.body",body);
                                   }
                               });
    }
    
})