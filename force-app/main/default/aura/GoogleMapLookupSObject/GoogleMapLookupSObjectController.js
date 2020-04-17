({
    keyPressController: function (component, event, helper) {

        var searchKey = component.get("v.searchString");
		if(searchKey.length==0){
            helper.clearComponentConfig(component);
        }
        helper.openListbox(component, searchKey);
        helper.displayOptionsLocation(component, searchKey);
    },

    selectOption: function (component, event, helper) {
        var selectedItem = event.currentTarget.dataset.record;
        var selectedValue = event.currentTarget.dataset.value;
        
        component.set("v.selectedOption", selectedItem);

        var searchLookup = component.find("searchLookup");
        $A.util.removeClass(searchLookup, 'slds-is-open');

        var iconDirection = component.find("iconDirection");
        $A.util.removeClass(iconDirection, 'slds-input-has-icon_left');
        $A.util.addClass(iconDirection, 'slds-input-has-icon_right');
        
        component.set("v.searchString", selectedItem);
    },

    clear: function (component, event, helper) {
        helper.clearComponentConfig(component);
    },
	
 
})