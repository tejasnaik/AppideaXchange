({
	init : function(component, event, helper) {
	},
    onLookupControlFocus : function(component, event, helper) {
        var lookupControl = component.find('LookupControl');
		$A.util.addClass(lookupControl, 'slds-is-open');

        helper.lookupSearch(component, event, helper);
	},
    onLookupControlBlur : function(component, event, helper) {
        window.setTimeout(function() {
            $A.getCallback(function(){
                var lookupControl = component.find('LookupControl');
                $A.util.removeClass(lookupControl, 'slds-is-open');     
            });
        }, 500);
	},
    onLookupControlKeyup : function(component, event, helper) {
        var lookupControl = component.find('LookupControl');
        if(event.getParams().keyCode == 27){
            $A.util.removeClass(lookupControl, 'slds-is-open');
        } else {
            $A.util.addClass(lookupControl, 'slds-is-open');
            helper.lookupSearch(component, event, helper);   
        }
	},
    onLookupItemClick : function(component, event, helper) {
        var selectedId = event.currentTarget.getAttribute('data-id');
        var selectedValue = event.currentTarget.getAttribute('data-value');
        component.set('v.value', selectedId);
        component.set('v.displayValue', selectedValue);
		$A.util.removeClass(component.find('LookupControl'), 'slds-is-open');
	},
    onLookupCloseClick : function(component, event, helper) {
        component.set('v.value', '');
        component.set('v.value', null);
        
		$A.util.addClass(component.find('LookupControl'), 'slds-is-open');
	}
})