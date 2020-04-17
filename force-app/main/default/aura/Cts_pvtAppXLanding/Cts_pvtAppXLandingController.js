({
   /* hideSpinner :function (component, event,helper){}, showSpinner :function (component, event,helper){},*/
    
    /* On load fuction for this lighting component*/
    doInt : function(component, event, helper) 
	{
		try {
				var sopt = { "sCategories":'', "sType" :'',	"sSorting":'DESC#createddate',	"searchKeyWord":'',	"filterAppied":false};
				component.set("v.searchOptionAttributes",sopt);
            	component.set("v.spinner",true);
				helper.getOptions(component, event);
		}catch(err){
            component.set("v.spinner",false);
			console.log(err);
		}
    },
	
	//Apply filers 
    applyFilters:function (component, event,helper)
	{
		
		try {
			var localOp = component.get("v.searchOptionAttributes");
			var sopt = {
				"sCategories":component.get("v.sCategories"),
				"sType" :component.get("v.sType"),
				"sSorting":component.get("v.sSorting"),
				"searchKeyWord" :localOp.searchKeyWord,
				"filterAppied":false
			};
			component.set("v.SearchInput",localOp.searchKeyWord);
			component.set("v.searchOptionAttributes",sopt);
			component.set("v.offSet",0);
			component.set("v.spinner",true);
            helper.getApps(component);
		}catch(err) {
			console.log(err);
		}
	},
    
   
    
	
	//When user try to search component.
	searchComponent:function(component, event, helper) 
	{
		try
		{
			var optionJson = component.get("v.searchOptionAttributes");
			component.set("v.SearchInput",optionJson.searchKeyWord);
			optionJson.sCategories = null;
			optionJson.sType = null;
			optionJson.sSorting = null;
			optionJson.filterAppied = false;
			component.set("v.searchOptionAttributes",optionJson);
			component.set("v.sCategories",'');
			component.set("v.sType",'');
			component.set("v.sSorting",'');
			component.set("v.offSet",0);
            component.set("v.spinner",true);
			helper.getApps(component);
		}catch(err){
			console.log(err);
		}
	},
	
     
		/*@Deprecated
		When filter get changed this action will perform own actions 
		*/
        onSelectChange :function(component, event, helper) {
		try
		{	
            console.log('TEst');
			//helper.FillDiv_ToshowAll_CtsLtngComponent(component);
			var localOp = component.get("v.searchOptionAttributes");
			localOp.filterAppied = true;
			component.set("v.searchOptionAttributes",localOp);
			
		}catch(err){
			console.log(err);
		}
    },
    
    /* When user click on "More" button in child component and fire an event,
     * then parent component (this) capture the event and execute this method to show detail in PopUp */ 
    showdetailEventAction : function(component, event, helper) {
		try
		{
			var recordId = event.getParam("recordId");
			//console.log(recordId);
			var listofRecords = component.get("v.appsList");
			var fullDetailRecord; 
			var listingDetailRecord;
			if(listofRecords !=null && listofRecords != undefined)
			{
				for(var i=0;i<listofRecords.length;i++){
					if(listofRecords[i].res.Id == recordId){
						fullDetailRecord = listofRecords[i] ;  
						listingDetailRecord =  listofRecords[i].res.CogniAppEx__DefaultListing__c;   
						break;
					}
				}
			}
			//Need to set below attributes to null as old detail records might be exist.
			component.set("v.ratingData",null);
			component.set("v.DetailRecord",null);
			if(fullDetailRecord != null && fullDetailRecord != undefined){
                component.set("v.spinner",true);
				helper.getListing(fullDetailRecord,component);
			}
		}catch(err){
			console.log(err);
		}
    },
    
    /* Pop-Up close button will invoke to hide the Pop-Up*/
    close:function(component, event, helper) {
        component.set("v.showDetail",false);
        component.set("v.DetailRecord",null);
    },
    
    
    componentInstallRedirection :function(component, event, helper) {
        //var ele = component.find("showDetailID").getElement();
        //$A.util.addClass(ele,'slds-hide');
        component.set("v.showDetail",false);
        component.set("v.showRedirection",true);
    },
    
    closecomponentInstall :function(component, event, helper) {
        //var ele = component.find("showDetailID").getElement();
        //$A.util.removeClass(ele,'slds-hide');
        component.set("v.showDetail",true);
        helper.starRatingFunctionality(component,component.get("v.DetailRecord"));
        component.set("v.showRedirection",false);
    },
    
	/* when user click on Install button, user will be redirect to install url of package*/
    componentInstall:function(component, event, helper) {
		try
		{
			console.log(event.currentTarget.id);
            var urlPrefix = event.currentTarget.id == 'ProductionURl'?'login':'test';
            
			//var urlStart = event.currentTarget.id == 'ProductionURl'?'https://login.salesforce.com/?startURL=/packaging/installPackage.apexp?p0=':'https://test.salesforce.com/?startURL=/packaging/installPackage.apexp?p0=';
			var urlStart = 'https://'+urlPrefix+'.salesforce.com/?startURL=/packaging/installPackage.apexp?p0=';			
            
            var re = component.get("v.DetailRecord");
			helper.recordInstallHits(component);
			var url = re.app.res.CogniAppEx__InstallUrl__c;
			//console.log('>>url>>>>'+url)
			if(url !=undefined){
				var s = url.split('p0=');
					//window.location.href = urlStart+s[1]+'&newUI=1&src=u';
				window.open( urlStart+s[1]+'&newUI=1&src=u');
                component.set("v.showDetail",false);
		        component.set("v.showRedirection",false);
				if(component.get("v.EnableStarRating"))
	                component.set("v.showRatingPanel",true);	
                	
			}
		}catch(err){
			console.log(err);
		}
    },
    
    closeRatingBlock :function(component, event, helper){
        component.set("v.showRatingPanel",false);	
    },
    
    fileDownload : function(component, event, helper){

		try{	var re = component.get("v.DetailRecord");
			//console.log(event.currentTarget.id);
			//console.log(re);
			var sId = event.currentTarget.id;
			var selectedUrl;
			var urls = re.lsting[0].CogniAppEx__ListingAssets__r.records;
			//console.log(urls);
			
			for(var i =0; i<urls.length ;i++){
				if(urls[i].Id == sId){
					selectedUrl = urls[i].CogniAppEx__Location__c;    
				}
			}
			if(selectedUrl !='')
				window.location.href = selectedUrl;
        
        }catch(err){
			console.log(err);
		}
		//console.log(selectedUrl);
    },
	
	paginationCaller:function(component, event, helper) {
        var actionTpe = event.currentTarget.getAttribute("data-type");
        if(actionTpe == 'next'){
            var currentOffSet = component.get("v.offSet");
            var currentLimit = component.get("v.limitNo");
            component.set("v.offSet",currentOffSet+currentLimit);
            helper.getApps(component);
        }else if(actionTpe == 'previous'){
            var currentOffSet = component.get("v.offSet");
            var currentLimit = component.get("v.limitNo");
            component.set("v.offSet",currentOffSet-currentLimit);
            helper.getApps(component);
        }     
    },
    
    openCommentBlock : function(component, event, helper) {
        component.set("v.showCommnetBlock",true);
        //console.log('------')
        //console.log(component.get("v.ratingData"));
        //component.set("v.showDetail",true);
        var cmpTarget = component.find('showDetailID');
		$A.util.addClass(cmpTarget, 'detailSecionHide');
    },

    closeCommentBlock : function(component, event, helper) {
       // component.set("v.showDetail",true);
       var cmpTarget = component.find('showDetailID');
        $A.util.removeClass(cmpTarget, 'detailSecionHide');
        helper.createStarRatingComponent(component);
        component.set("v.showCommnetBlock",false);
    },
    
     getRatingValue : function(component, event, helper) {
        var ele = component.find("UserRatingDefinedID");
        ele.getRatedValueMethod();
        //console.log(ele.get("v.AfterRating"));
        if(ele.get("v.AfterRating") != null && ele.get("v.AfterRating") !=undefined &&  ele.get("v.AfterRating") >0 )
	        helper.SubmitRating(component,ele.get("v.AfterRating"));
         else
             helper.showToast('warning','Info','Please provide your rating.');
    },
    
})