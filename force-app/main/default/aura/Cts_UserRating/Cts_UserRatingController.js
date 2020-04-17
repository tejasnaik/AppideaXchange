({
    doInit : function(component, event, helper){
    	var val = component.get("v.executer");
        /*if(val==1){
            //helper.executer(component);
        }else{
            component.set("v.executer",1);
        }*/
    },
    
    
    
    scriptsLoaded : function(component, event, helper){
		    helper.executer(component);
            //component.set("v.executer",1);
    },
   
    hoverdiv : function(component, event, helper) {
        if(component.get("v.popoverPositionEnable"))
        {
            if(component.get("v.CurrentRating") >0)
            {
		        var item = component.find("popoverPanelId").getElement();
                item.scrollIntoView();
                document.getElementById( 'popoverPanelId' ).scrollIntoView();
    		    $A.util.removeClass(item, 'slds-hide');
        		$A.util.addClass(item, 'slds-show');
            }
        }
    },
    
    hideDiv:function(component, event, helper){
        if(component.get("v.popoverPositionEnable"))
        {
	        var item = component.find("popoverPanelId").getElement();
    	    $A.util.removeClass(item, 'slds-show');
        	$A.util.addClass(item, 'slds-hide');
        }
    },
    
    getRatedValue :function (component, event, helper){
         	var ele = component.find("StarInputfieldId").getElement();
        	component.set("v.AfterRating",ele.value);
	}
 

})