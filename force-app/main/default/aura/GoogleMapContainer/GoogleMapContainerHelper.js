({
    getAccountList: function(component, helper){
        
        var action = component.get('c.getAccounts');
        
        action.setCallback(this, function(response){
            var state = response.getState();
            
            console.log('state:', state);
            if (state == "SUCCESS") {
                var ret = response.getReturnValue();
                
                if(ret.length > 0){
                    
                    var mapOptionsCenter = {"lat":parseFloat(ret[0].BillingLatitude), "lng":parseFloat(ret[0].BillingLongitude)};
                    var mapData = Array();
                    //cmp.set("v.opportunities", response.getReturnValue());
                    for(var i=0; i<ret.length; i++){
                        mapData.push({"lat":parseFloat(ret[i].BillingLatitude), "lng":parseFloat(ret[i].BillinggLongitude), "markerText":ret[i].Name})
                    }
                    
                    component.set('v.mapOptionsCenter', mapOptionsCenter);
                    component.set('v.mapData', mapData);
                    component.set('v.acc', ret);
                }
            }
            
        });
        $A.enqueueAction(action);
    },
    getContactList: function (component, helper) {
        
        var action = component.get('c.getContacts');
        
        action.setParams({AccountID: component.get('v.recordId')});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            
            console.log('state:', state);
            if (state == "SUCCESS") {
                var ret = response.getReturnValue();
                
                if(ret.length > 0){
                    console.log(parseFloat(ret[0].MailingLatitude));
                    console.log(parseFloat(ret[0].MailingLongitude));
                    var mapOptionsCenter = {"lat":parseFloat(ret[0].MailingLatitude), "lng":parseFloat(ret[0].MailingLongitude)};
                    var mapData = Array();
                    //cmp.set("v.opportunities", response.getReturnValue());
                    for(var i=0; i<ret.length; i++){
                        if(!$A.util.isEmpty(ret[i].MailingLatitude) && !($A.util.isEmpty(ret[i].MailingLongitude))) {
                            mapData.push({
                                "lat": parseFloat(ret[i].MailingLatitude),
                                "lng": parseFloat(ret[i].MailingLongitude),
                                "markerText": ret[i].Name
                            })
                        }
                    }
                    
                    component.set('v.mapOptionsCenter', mapOptionsCenter);
                    component.set('v.mapData', mapData);
                    component.set('v.con', ret);
                }
            }
            
        });
        $A.enqueueAction(action);
        /**/
    },
    getmapsData: function (component, helper) {
        var locData=component.get("v.searchString"); 
        var fields=component.get("v.fields"); 
        var sObjectAPIName=component.get("v.sObjectAPIName"); 
        var searchOn=component.get("v.searchOn"); 
        var locState=component.get("v.searchState"); 
        var locCity=component.get("v.searchCity"); 
        var searchString = '';
        var distance = component.get("v.selectedValueDistance");
        var distanceRange = component.get("v.selectedValueUnits");
        
        console.log('@@@@@@@@@@@@@@@@@' + distanceRange + '@#@#@#@' + distance);
        
        if($A.util.isEmpty(locState) && $A.util.isEmpty(locCity) && $A.util.isEmpty(locData)){
            component.set("v.modalMessage",'Either enter the State/City or Account Name fields');  
            var modalbox = component.find("modalbox");
            $A.util.removeClass(modalbox, 'slds-hide');
           	return;
        }else{
            if(!$A.util.isEmpty(locState)){
                searchString = locState+'*';
            }
            if(!$A.util.isEmpty(locCity)){
                if(!$A.util.isEmpty(searchString)){
                    searchString += ' AND ' + locCity +'*';
                }else{
                    searchString += locCity+'*';
                }          
            }
            if(!$A.util.isEmpty(locData)){
                if(!$A.util.isEmpty(searchString)){
                    searchString += ' AND ' + locData+'*';
                }else{
                    searchString += locData+'*';
                }           
            }
            if(!($A.util.isEmpty(locState)) || !($A.util.isEmpty(locCity))){
                searchOn = "ALL";
            }else{
                searchOn = "NAME";
            }
            /*var GoogleMap=component.find("GoogleMap");
     GoogleMap.populateValue(locData);*/
            var action = component.get('c.getAccounts');
            action.setParams({"searchString": searchString/*locData*/,
                              "fields":fields,
                              "sanitizedSObjectAPIName": sObjectAPIName,
                              "searchOn":searchOn,
                              "distance" : distance,
                              "distanceRange": distanceRange}); 
            action.setCallback(this, function(response){
                var value = response.getReturnValue();
                if(value.length>0){
                    component.set("v.searchData",value);
                    //alert(JSON.stringify(value));
                    var GoogleMap=component.find("GoogleMap");
                    GoogleMap.populateValue('',value);
                }
                else{
                    component.set("v.modalMessage",'No Results Found');  
                    var modalbox = component.find("modalbox");
                    $A.util.removeClass(modalbox, 'slds-hide');
                }
            })
            $A.enqueueAction(action);
        }
        
    }
})