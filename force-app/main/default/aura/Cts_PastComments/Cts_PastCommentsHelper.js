({
	getRelatedComments : function(cmp) {
        cmp.set("v.spinner",true);
		var action = cmp.get("c.getAllRelatedComments");
        action.setParams({
            "itemId":cmp.get("v.ItemId"),
            "limitNo":5,
            "offsetNo":cmp.get("v.offSet")
        });
        action.setCallback(this,function(response){
            console.log(response.getState());
            cmp.set("v.spinner",false);
            if(response.getState()=='SUCCESS'){
                var returnValue = JSON.parse(response.getReturnValue());
                console.log(returnValue);
                if(returnValue.isSuccess){
                    var presentList = cmp.get("v.pastComments");
                    //var pListLength = presentList.length;
                    //cmp.set("v.pastComments",returnValue.recordList);
                    if(returnValue.recordList != null)
                    {
	                    for(var t =0 ;t<returnValue.recordList.length;t++){
                            var item = returnValue.recordList[t];
                            item.customDays = 'Yesterday';
                            if(item.CogniAppEx__Days_Difference__c == 0){
                            	item.customDays = 'Today';    
                            }else if(item.CogniAppEx__Days_Difference__c > 1){
                                item.customDays = ' '+item.CogniAppEx__Days_Difference__c+' days ago';
                                if(item.CogniAppEx__Days_Difference__c > 30 && item.CogniAppEx__Days_Difference__c < 60){
                                    item.customDays = 'Last Month';
                                }
                            }
                            console.log(item);
    	                	presentList.push(returnValue.recordList[t])  ;  
        	            }
                	 cmp.set("v.pastComments",presentList);
               		 cmp.set("v.totalComments",returnValue.totalRecords);
                    }
                }else{
                    
                }
            }else if(response.getState()=='ERROR'){
                
            }          
        });
        $A.enqueueAction(action);
  	}
})