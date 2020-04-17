({
    handleComponentEvent: function(component, event, helper){
        var selObjectEventHan = event.getParam("sObjectEvent");
        var selectedObject = event.getParam("selObjectEvent");
        var sObjMapLoop = new Array();
        var mapData = new Array();
        for (var i=0; i<selObjectEventHan.length; i++) {
            sObjMapLoop.push(selObjectEventHan[i]);
        }
        component.set("v.counter",sObjMapLoop.length);
        component.set("v.sObjMap",sObjMapLoop);
        if(sObjMapLoop.length > 0){
            for(var i=0; i<sObjMapLoop.length; i++){
                if(selectedObject === "Account") {
                    var mapOptionsCenter = {"lat":parseFloat(sObjMapLoop[0].BillingLatitude), "lng":parseFloat(sObjMapLoop[0].BillingLongitude)};
                    mapData.push({"lat":parseFloat(sObjMapLoop[i].BillingLatitude), "lng":parseFloat(sObjMapLoop[i].BillingLongitude), "markerText":"Account Name :: "+sObjMapLoop[i].Name +" , Number of Employees :: "+String(sObjMapLoop[i].NumberOfEmployees) +" , Billing State :: "+String(sObjMapLoop[i].BillingState)})
                }
                else if(selectedObject === "Contact") {
                    var mapOptionsCenter = {"lat":parseFloat(sObjMapLoop[0].MailingLatitude), "lng":parseFloat(sObjMapLoop[0].MailingLongitude)};
                    mapData.push({"lat":parseFloat(sObjMapLoop[i].MailingLatitude), "lng":parseFloat(sObjMapLoop[i].MailingLongitude), "markerText":"Contact Name :: "+sObjMapLoop[i].Name +" , Mailing State :: "+String(sObjMapLoop[i].MailingState)})
                }
                    else if(selectedObject === "Lead") {
                        var mapOptionsCenter = {"lat":parseFloat(sObjMapLoop[0].Latitude), "lng":parseFloat(sObjMapLoop[0].Longitude)};
                        mapData.push({"lat":parseFloat(sObjMapLoop[i].Latitude), "lng":parseFloat(sObjMapLoop[i].Longitude), "markerText":"Lead Name :: "+sObjMapLoop[i].Name +" , Number of Employees :: "+String(sObjMapLoop[i].NumberOfEmployees) +" , State :: "+String(sObjMapLoop[i].State)})
                    }
            }
        }
        component.set("v.mapOptionsCenter", mapOptionsCenter);
        component.set("v.mapData", mapData);
    }
})