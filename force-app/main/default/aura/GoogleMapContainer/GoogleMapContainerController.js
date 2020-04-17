({
    doInit: function(component, event, helper) {
        //To show accounts on map
        //helper.getAccountList(component, helper);
        //To show contacts on map
        
        //helper.getContactList(component, helper);
    },
    submit: function(component, event, helper) {
        helper.getmapsData(component, helper);
	},
    dropDownAction: function(component, event, helper) {
        var distance=component.get("v.selectedValueDistance");
        var unit=component.get("v.selectedValueUnits");
        
        var value=0;
        if(unit=='km' || unit=='choose one...'){
            value= distance*1000; 
        }else{
           value= distance*1609; 
        }
        var GoogleMap=component.find("GoogleMap");
        GoogleMap.populateDropdownValue(value);
    },
     closeModal: function(cmp, event, helper) {
        var modalbox = cmp.find("modalbox");
        $A.util.addClass(modalbox, 'slds-hide');
    },
    selectOption: function (component, event, helper) {
        var selectedItem = event.currentTarget.dataset.value;
        var searchDataLen=component.get("v.searchData");
        var value=''
        for(var i=0;i<searchDataLen.length;++i){
            if(searchDataLen[i].objRecords.Id==selectedItem){
                value=searchDataLen[i];
            }
        }
        var GoogleMap=component.find("GoogleMap");
        GoogleMap.populateValue('',value);
    },
     setAttributeValue: function(component, event, helper)
    {
        
        var eventValue= event.getParam("attributeValue");
        component.set("v.isDisplayDistance", eventValue);
        
        if(eventValue == 'no') {
            component.set("v.selectedValueDistance", 'choose one...');
            component.set("v.selectedValueUnits", 'choose one...');
        }
        console.log('@@@@@@' + eventValue);
		}    
   })