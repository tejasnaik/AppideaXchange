({
    
    getOptions : function(cmp,event) 
    {
        try
        {
            var debugFlag = cmp.get("v.debugOn");
            var action = cmp.get("c.getfieldOptions");
            action.setCallback(this,function(res){
                cmp.set("v.spinner",false);
                
                if(debugFlag) console.log(res.getState());
                
                if(res.getState()==='SUCCESS'){
                    if(!debugFlag) console.log(res.getReturnValue());
                    cmp.set("v.resultFilter",res.getReturnValue());
                    if (cmp.isValid()) {
                        if(debugFlag) console.log(' [Calling APPS]');
                        this.getApps(cmp);
                    }
                }else if(res.getState()=='ERROR'){
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
        }catch(err){
            console.log(" getOptions - try catch error "+err);
        }	
    },
    
    getApps :function(cmp)
    {
        var debugFlag = cmp.get("v.debugOn");
        cmp.set("v.totalComponents",0);
        cmp.set("v.currentMsg","Please wait, Genius is patience.");
        try
        {
            if(debugFlag)
                console.log('coming');
            var action = cmp.get("c.getAppList");
            action.setAbortable();
            var filers = cmp.get("v.searchOptionAttributes");
            if(debugFlag ){
                console.log(filers);
                console.log('Search-->>'+cmp.get("v.SearchInput"));
                console.log('offset-->>'+cmp.get("v.offSet"))
            }
            action.setParams({
                "category" : filers.sCategories,
                "types" : filers.sType,
                "sortOrder" : filers.sSorting,
                "offSet":cmp.get("v.offSet"),
                "limitNo":cmp.get("v.limitNo"),
                "searchKeyWord":cmp.get("v.SearchInput"),
                "ComponentStatus":cmp.get("v.ComponentStatus")
            });
            
            action.setCallback(this,function(res)
                               {
                                   cmp.set("v.spinner",false);
                                   if(debugFlag) 
                                       console.log(res.getState());
                                   
                                   if(res.getState()==='SUCCESS')
								   {
                                       var result = res.getReturnValue();
                                       
                                       if(debugFlag )
                                           console.log(result);
                                       
                                       if(result != null && result != undefined && result !='')
                                       {
                                           var resultParse = JSON.parse(result);
                                           cmp.set("v.totalComponents",resultParse.totalRecords);
                                           cmp.set("v.appsList",resultParse.awReturn);
                                           //console.log(JSON.parse(result));
                                           if (cmp.isValid()) {
                                               this.FillDiv_ToshowAll_CtsLtngComponent(cmp);
                                               if(resultParse.awReturn != null && resultParse.awReturn != undefined)
                                                   cmp.set("v.componentListSize",resultParse.awReturn.length);
                                               
                                           }
                                       }else{
                                           cmp.set("v.totalComponents",0);
                                           cmp.set("v.componentListSize",0);
                                           cmp.set("v.appsList",null);
                                           cmp.set("v.currentMsg","No component found.");
                                           if (cmp.isValid()) {
                                               this.FillDiv_ToshowAll_CtsLtngComponent(cmp);
                                           }
                                       }
                                   }
								   else if(res.getState()=='ERROR')
								   {
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
        }
        catch(err)
        {
            console.log(" getApps - try catch error "+err);
        }
    },
    //component.get("v.SearchInput")
    
    /* This function will create child component to show all Cognizant Component Package */
    FillDiv_ToshowAll_CtsLtngComponent :function(component)
    {
        console.log(component.get("v.appsList"));
        try
        {
            $A.createComponent("c:Cts_pvtAppsList",
                               {
                                   "sCategories": '',
                                   "sType"	:'',
                                   "AppsList" : component.get("v.appsList"),
                                   "sortOrder":'',
                                   "SearchInput" : component.get("v.SearchInput")
                               },
                               function(cmp, status, errorMessage){
                                   component.set("v.spinner",false);
                                   var divComponent = component.find("componentcontainerId");
                                   if (divComponent != null && divComponent.isValid()) {
                                       var body = divComponent.get("v.body");
                                       body =[];
                                       body.push(cmp);
                                       divComponent.set("v.body",body);
                                   }
                               });
        }catch(err)
        {
            console.log(" FillDiv_ToshowAll_CtsLtngComponent - try catch error "+err);
        } 
    },
	
	
    
    recordInstallHits:function(cmp)
    {
        try
        {
            var action = cmp.get("c.recordInstallActivity");
            var detialRec = cmp.get("v.DetailRecord");
            action.setParams({
                "AppId" : detialRec.app.res.Id,
                "ListingId" :detialRec.lsting[0].Id
            });
            
            action.setCallback(this,function(res)
                               {
                                   if(res.getState()==='SUCCESS'){
                                       var result = res.getReturnValue();
                                   }else{
                                       
                                   }
                               });
            $A.enqueueAction(action);
        }catch(err){
            console.log(" recordInstallHits - try catch error "+err);
        }
    },
    
    getListing: function(listingId,cmp)
    {
        
        try
        {
			var debugFlag = cmp.get("v.debugOn");
            var action = cmp.get("c.getListing");
            action.setAbortable();
            action.setParams({
                "AppId" : listingId.res.Id,
                "ListingId" : listingId.res.CogniAppEx__DefaultListing__c
            });
            action.setCallback(this,function(res){
                cmp.set("v.spinner",false);
                
				if(debugFlag)
						 console.log(res.getState());
                    
				if(res.getState()==='SUCCESS'){
                    var result = res.getReturnValue();
                    
					if(debugFlag)
						 console.log(result);
                    
					if (cmp.isValid()) {
                        var newJson = {
                            "app":listingId,
                            "lsting": JSON.parse(result)
                        };
                        
                        if(newJson.lsting !=null && newJson.lsting.length>0 && newJson.lsting[0].CogniAppEx__asb_App__r.CogniAppEx__Hours_Saved__c != undefined && newJson.lsting[0].CogniAppEx__asb_App__r.CogniAppEx__Hours_Saved__c != null){
                            var t = parseInt(newJson.lsting[0].CogniAppEx__asb_App__r.CogniAppEx__Hours_Saved__c);
                            var h ='';
                            if( parseInt(t/60)>0){
                                h = ''+ parseInt(t/60)+' Hour(s)';
                            }
                            var m ='';
                            if(t%60>0)
                                m = ' '+ t%60 + ' min(s).'  
                                newJson.lsting[0].CogniAppEx__asb_App__r.CogniAppEx__Hours_Saved__c = h +((parseInt(t/60)>0 && t%60>0)?' and ':'' )+ m;
                        }else{
                            newJson.lsting[0].CogniAppEx__asb_App__r.CogniAppEx__Hours_Saved__c = 'N/A';
                        }
                        
                        
                        if(listingId != null && (listingId.res.CogniAppEx__InstallUrl__c =='http://' || listingId.res.CogniAppEx__InstallUrl__c=='https://' ))
                          listingId.res.CogniAppEx__InstallUrl__c = '';
                           
                        cmp.set("v.DetailRecord",newJson);
                        cmp.set("v.showDetail",true);
                        if(debugFlag) 
                            console.log(newJson);
                        var expression = listingId.res.CogniAppEx__AppType__c;
                        var icontype;
                        switch(expression) {
                            case 'Components':
                                icontype = 'utility:package';        
                                break;
                            case 'Applications':
                                icontype = 'utility:text_background_color';   
                                break;
                            case 'Frameworks':
                                icontype = 'utility:setup';
                                break;
                            default:
                                icontype = 'utility:custom_apps';
                        }
                        //console.log('icontype>>>>>'+icontype);
                        cmp.set("v.ComponentTypeIcon",icontype);
						cmp.set("v.ratingData",null);
						if(cmp.get("v.EnableStarRating"))
						{
							this.starRatingFunctionality(cmp,newJson);
						} 
                    }
                }else if(res.getState()=='ERROR'){
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
        }catch(err)
        {
            console.log(" getListing - try catch error "+err);
        }
    },
    
    
	starRatingFunctionality: function(component,JsonValue){
		
		var rting = 0;
		if(JsonValue != null && JsonValue.lsting !=null && JsonValue.lsting.length>0 && 
									JsonValue.lsting[0].CogniAppEx__App_Ratings__r != null &&
									JsonValue.lsting[0].CogniAppEx__App_Ratings__r.records !=null &&
									JsonValue.lsting[0].CogniAppEx__App_Ratings__r.records !=undefined )
		{
			var ratingInstance = JsonValue.lsting[0].CogniAppEx__App_Ratings__r;
			component.set("v.ratingData",ratingInstance);
			console.log(ratingInstance);
		
		}
		this.createStarRatingComponent(component);
	},
	
    createStarRatingComponent : function(component)
    {
        var ratingValue = 0;
        var ratingInstanceData = component.get("v.ratingData");
        var ratingInstance ;
        //console.log(ratingInstance);
        component.set("v.isUserRated",false);
        component.set("v.UserRatedValue",0);
        var totalUserRated = 0;
        var loggedINUser = component.get("v.resultFilter").userId;
        if(ratingInstanceData !=null && ratingInstanceData != undefined && ratingInstanceData.records != null )
        {
            	ratingInstance = ratingInstanceData.records;
            	totalUserRated = ratingInstance.length;
            	for (var x=0; x<ratingInstance.length;x++)
				{
                    if(ratingInstance[x].CogniAppEx__User_Rating__c !=null && ratingInstance[x].CogniAppEx__User_Rating__c != undefined)
						ratingValue +=ratingInstance[x].CogniAppEx__User_Rating__c;   
                    
                    if(loggedINUser != undefined && loggedINUser !='' && ratingInstance[x].CogniAppEx__User__c == loggedINUser){
                        component.set("v.isUserRated",true);
                        //console.log('>>>>>'+component.get("v.isUserRated"));
                        component.set("v.UserRatedValue",ratingInstance[x].CogniAppEx__User_Rating__c);
                    }
                }
				ratingValue = (ratingValue/totalUserRated);
            	if(ratingValue !=null && ratingValue !=undefined && (ratingValue-Math.floor(ratingValue))*10>1)
                    ratingValue = ratingValue.toFixed(2);
            	
        }
		//component.set("v.ratingData",null);
        try
        {
            $A.createComponent("c:Cts_UserRating",
                               {
                                   "HeaderTitle":"Rating Description",
                                   "CurrentRating": ratingValue,
                                   "totalRatedBy":totalUserRated,
                                   "showCaption":true,
                                   "popoverPositionEnable":true,
                                   "RatingUserField":"CogniAppEx__User__c",
                                   "RatingNumberField":"CogniAppEx__User_Rating__c",
                                   "records":ratingInstance
                               },
                               function(cmp, status, errorMessage){
                                   component.set("v.spinner",false);
                                   var divComponent = component.find("starRatingPannelId");
                                   if (divComponent !=null && divComponent.isValid()) {
                                       var body = divComponent.get("v.body");
                                       body =[];
                                       body.push(cmp);
                                       divComponent.set("v.body",body);
                                   }
                               });
        }catch(err)
        {
            console.log(" FillDiv_ToshowAll_CtsLtngComponent - try catch error "+err);
        } 
        
    },
    
    SubmitRating : function(cmp,ratingValue)
    {
        var debugFlag = cmp.get("v.debugOn");
        var detialRec = cmp.get("v.DetailRecord");
        var ListingId = detialRec.lsting[0].Id;
        var UserId;
        if(debugFlag) 
            console.log('ListingId>>>>>>'+ListingId+'------'+ratingValue);
        var action = cmp.get("c.submitRating");
        action.setParams({
            	"ratingValue":ratingValue,
                "listingId":ListingId,
                "UserId":null,
	            "comingFrom":'COMPONENT'
            });
        action.setCallback(this,function(res){
           if(debugFlag)  
               console.log(res.getState());
            if(res.getState() == 'SUCCESS'){
                if(debugFlag) 
                   console.log(res.getReturnValue());
                if(res.getReturnValue()=='SUCCESS'){
                    this.showToast("success", "Success!","Thanks for your Rating.");
                    var toastEvent = $A.get("e.force:showToast");
                    cmp.set("v.showRatingPanel",false);
                }
            }else if(res.getState()=='ERROR'){
                 	
                	if(debugFlag)  console.log(JSON.stringify(res.getReturnValue()));
                 	if(debugFlag)  console.log(res.getError());
                    var errors = res.getError();
                	
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                	this.showToast("info", "Failed!","Cut off time.");
                }
        });
        
        $A.enqueueAction(action);
    },
    
    
    showToast : function(type,title,message)
    {
	    var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":type,
                            "title": title,
                            "message": message
                        });
                        toastEvent.fire();
    }
    
})