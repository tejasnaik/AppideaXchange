({
    keyPressController: function (component, event, helper) {
		var searchKey = component.get("v.searchKey");
        if(searchKey.length==0){
            helper.clearComponentConfig(component);
        }
        helper.openListbox(component, searchKey);
        helper.displayOptionsLocation(component, searchKey);
    },

    selectOption: function (component, event, helper) {
        var selectedItem = event.currentTarget.dataset.record;
        console.log(selectedItem);
        var selectedValue = event.currentTarget.dataset.value;
        console.log(selectedValue);

        component.set("v.selectedOption", selectedItem);

        var searchLookup = component.find("searchLookup");
        $A.util.removeClass(searchLookup, 'slds-is-open');

        var iconDirection = component.find("iconDirection");
        $A.util.removeClass(iconDirection, 'slds-input-has-icon_left');
        $A.util.addClass(iconDirection, 'slds-input-has-icon_right');
        
        var str_array = selectedItem.split(',');
        if(str_array.length>0 || str_array.length==0 ){
            for(var i = 0; i < str_array.length; i++) {
                // Trim the excess whitespace.
                str_array[i] = str_array[i].replace(/^\s*/, "").replace(/\s*$/, "");
                // Add additional code here, such as:
            }
        }
        component.set("v.searchKey", str_array[0]);
        if(str_array.length>1){
            component.set("v.searchKeyState", str_array[1]);
        }
        if(str_array.length>2){
            component.set("v.searchKeyCountry", str_array[2]);
        }
        var setEvent = component.getEvent("setAttribute");
        setEvent.setParams({"attributeValue": 'yes'});
        setEvent.fire();
    },

    clear: function (component, event, helper) {
        helper.clearComponentConfig(component);
    }

})