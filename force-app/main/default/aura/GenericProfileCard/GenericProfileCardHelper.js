({
    setup : function(component, event, helper) {
        //Code to get Query parameters
        var QueryString = function () {
            // This function is anonymous, is executed immediately and 
            // the return value is assigned to QueryString!
            var query_string = {};
            var query = window.location.search.substring(1);
            var vars = query.split("&");
            for (var i=0;i<vars.length;i++) {
                var pair = vars[i].split("=");
                // If first entry with this name
                if (typeof query_string[pair[0]] === "undefined") {
                    query_string[pair[0]] = pair[1];
                    // If second entry with this name
                } else if (typeof query_string[pair[0]] === "string") {
                    var arr = [ query_string[pair[0]], pair[1] ];
                    query_string[pair[0]] = arr;
                    // If third or later entry with this name
                } else {
                    query_string[pair[0]].push(pair[1]);
                }
            } 
            return query_string;
        } ();
        //QueryString.cid='0034100000qKdFY';
        if(!QueryString.cid){
           QueryString.cid=component.get('v.recordId'); 
        }
        if(QueryString.cid){            
            //Get server action 
            var sa_getPatientDetails = component.get('c.getPatientDetails');
            //Set params
            sa_getPatientDetails.setParams({
                'fields':component.get('v.queryFields'),
                'contactRecId':QueryString.cid.trim(),
            });
            //Set callback
            sa_getPatientDetails.setCallback(this, function(response){
                var state = response.getState();
                if(state=='SUCCESS'){
                    var responseIs = response.getReturnValue();
                    
                    //Get Header & Detail mapping details
                    var headerMappingVar = JSON.parse(component.get('v.headerFieldMapping'));
                    var detailMappingVar = JSON.parse(component.get('v.detailFieldMapping'));
                    
                    var headerFields = component.get('v.headerFields');
                    var detailFields = component.get('v.detailFields');
                    var headerObj = [];
                    var detailObj = [];
                    for(var key in responseIs.contactRecord){
                        //Set header informations
                        if(headerFields.indexOf(key)!=-1){
                            var tempObj = new Object();
                            tempObj['name']=key;
                            tempObj['label']=headerMappingVar[key];
                            var valueIs=responseIs.contactRecord[key];
                            var dateFormat = "YYYY-MM-DD";
                            if(moment(valueIs, dateFormat, true).isValid()){
                                valueIs = moment(valueIs).format('DD-MMM-YYYY');
                            }
                            tempObj['value']=valueIs;
                            headerObj.push(tempObj);	
                        }
                        //Set detail informations
                        if(detailFields.indexOf(key)!=-1){
                            var tempObj = new Object();
                            tempObj['name']=key;
                            tempObj['label']=detailMappingVar[key];
                            var valueIs=responseIs.contactRecord[key];
                            var dateFormat = "YYYY-MM-DD";
                            if(moment(valueIs, dateFormat, true).isValid()){
                                valueIs = moment(valueIs).format('DD-MMM-YYYY');
                            }
                            tempObj['value']=valueIs;
                            detailObj.push(tempObj);	
                        }
                    }
                    component.set('v.headerInfos',headerObj);
                    component.set('v.detailInfos',detailObj);
                    component.set('v.imageURL',responseIs.imageURL);
                    //Toggle the spinner
                    $A.util.toggleClass(component.find('spinner'),'slds-hide');
                }
            });
            //Invoke action
            $A.enqueueAction(sa_getPatientDetails);
        }else{
            //Toggle the spinner
            $A.util.toggleClass(component.find('spinner'),'slds-hide');
        }
    }
})