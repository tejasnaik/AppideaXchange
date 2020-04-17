({
    doInit : function(component, event, helper) {
        console.log('Inside doInit function');
        var toast = component.get("v.toastType"); 
        var mode = component.get("v.mode"); 
        console.log(toast);
        // apply toast css and display icon according to toast type
        if(toast == 'error'){
            component.set("v.toastIcon",'error');
            component.set("v.toastcss",'slds-notify slds-notify_toast slds-theme_error');
        }
        else if(toast == 'success'){
            component.set("v.toastIcon",'success');
            component.set("v.toastcss",'slds-notify slds-notify_toast slds-theme_success');
        }
        else if(toast == 'warning'){
            component.set("v.toastIcon",'warning');
        	component.set("v.toastcss",'slds-notify slds-notify_toast slds-theme_warning');
        }
        else if(toast == 'info'){
            component.set("v.toastIcon",'info');
        	component.set("v.toastcss",'slds-notify slds-notify_toast slds-theme_info');
        }
            else{}
          
        if(mode=='dismissible' || mode =='pester')
        {
            //display the toast for 5 seconds
            window.setTimeout(function(){
            if(document.getElementById("toastCmp"))
            	document.getElementById("toastCmp").style.display = "none";},5000); 
        }
            
    },
    closeIcon : function(component, event, helper) {
        console.log('inside closeIcon function ');
        if(document.getElementById("toastCmp"))
            document.getElementById("toastCmp").style.display = "none";
    }
})