({
   displayOptionsLocation: function (cmp, searchKey) {
      
       // Get the API Name
        var sObjectAPIName = cmp.get('v.sObjectAPIName');
        
        // Get the fields Name
        var fields = cmp.get('v.fields');
        
        // Get the searchOn 
        var searchOn = cmp.get('v.searchOn');
       //alert('searchKey.length===='+searchKey.length);
       if(searchKey.length>1){
           // Create an Apex action
           var action = cmp.get('c.lookup');
           
           // Mark the action as abortable, this is to prevent multiple events from the keyup executing
           action.setAbortable();
           
           // Set the parameters
           action.setParams({ "searchString" : searchKey, 
                             "sObjectAPIName" : sObjectAPIName,
                             "fields":fields,
                             "searchOn":searchOn,
                            });
           
           // Define the callback
           action.setCallback(this, function(response) {
               var state = response.getState();
               
               // Callback succeeded
               if (cmp.isValid() && state === "SUCCESS")
               {
                   // Get the search matches
                   var matches = response.getReturnValue();
                   
                   // If we have no matches, return nothing
                   if (matches.length == 0)
                   {
                       cmp.set('v.filteredOptions', null);
                       return;
                   }
                   
                   // Store the results
                   cmp.set('v.filteredOptions', matches);
               }
               else if (state === "ERROR") // Handle any error by reporting it
               {
                   var errors = response.getError();
                   
                   if (errors) 
                   {
                       if (errors[0] && errors[0].message) 
                       {
                           this.displayToast('Error', errors[0].message);
                       }
                   }
                   else
                   {
                       this.displayToast('Error', 'Unknown error.');
                   }
               }
           });
           
           // Enqueue the action                  
           $A.enqueueAction(action); 
       }
    },
	openListbox: function (component, searchKey) {
        var searchLookup = component.find("searchLookup");

        if (typeof searchKey === 'undefined' || searchKey.length < 3)
        {
            $A.util.addClass(searchLookup, 'slds-combobox-lookup');
            $A.util.removeClass(searchLookup, 'slds-is-open');
            return;
        }

        $A.util.addClass(searchLookup, 'slds-is-open');
        $A.util.removeClass(searchLookup, 'slds-combobox-lookup');
    },

    clearComponentConfig: function (component) {
        var searchLookup = component.find("searchLookup");
        $A.util.addClass(searchLookup, 'slds-combobox-lookup');

        component.set("v.selectedOption", null);
        component.set("v.searchString", null);

        var iconDirection = component.find("iconDirection");
        $A.util.removeClass(iconDirection, 'slds-input-has-icon_right');
        $A.util.addClass(iconDirection, 'slds-input-has-icon_left');
    }
 
})