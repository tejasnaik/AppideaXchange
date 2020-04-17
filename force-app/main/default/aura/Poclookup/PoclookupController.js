({
	init : function(component, event, helper) {
	},
    onLookupControlFocus : function(component, event, helper) {
        console.log('focus');
        var lookupControl = component.find('LookupControl');
		$A.util.addClass(lookupControl, 'slds-is-open');
        component.set('v.isOpen',true);
        
        	
        helper.lookupSearch(component, event, helper);
	},
    onLookupControlBlur : function(component, event, helper) {
         window.setTimeout(function() {
           		console.log('blur@@@');
            helper.close(component);
        }, 200);
	},
    onLookupControlKeyup : function(component, event, helper) {
        var lookupControl = component.find('LookupControl');
        if(event.getParams().keyCode == 27){
            console.log('keyup');
           $A.util.removeClass(component.find('LookupControl'), 'slds-is-open');
        } else {
            $A.util.addClass(lookupControl, 'slds-is-open');
            helper.lookupSearch(component, event, helper);   
        }
	},
   
    onLookupItemClick : function(component, event, helper) {
        var selectedValue = event.currentTarget.getAttribute('data-value');
        var selectedId=event.currentTarget.getAttribute('data-label');
        component.set('v.value', selectedValue);
        component.set('v.id',selectedId);
        console.log('click'+component.get('v.keyword'));
        	
		$A.util.removeClass(component.find('LookupControl'), 'slds-is-open');
	},
    onLookupCloseClick : function(component, event, helper) {
        component.set('v.id', '');
        component.set('v.value', null);
        console.log('closeCLick');
		//$A.util.addClass(component.find('LookupControl'), 'slds-is-open');
	}
})