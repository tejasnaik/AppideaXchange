({
    setSimpleAddress : function(cmp) {
        var simpleAddres = {
            "AddressLine1": cmp.get("v.AddressLine1"),
            "AddressLine2": cmp.get("v.AddressLine2"),
            "City": cmp.get("v.City"),
            "State": cmp.get("v.State"),
            "CountryCode": cmp.get("v.CountryCode"),
            "PostalCode": cmp.get("v.PostalCode"),
            "latitude":cmp.get("v.latitude"),
            "longitude":cmp.get("v.longitude")
        };
        cmp.set("v.SimpleAddress",simpleAddres);
    },
    
    setSandardAddress : function(cmp,address) {
        var simpleAddres = {
            "AddressLine1": address!=null?address.AddressLine1:'',
            "AddressLine2": address!=null?address.AddressLine2:'',
            "City": address!=null?address.City:'',
            "State": address!=null?address.State:'',
            "CountryCode": address!=null?address.CountryCode:'',
            "PostalCode": address!=null?address.PostalCode:'',
            "latitude":address!=null?address.latitude:'',
            "longitude":address!=null?address.longitude:''
        };
        cmp.set("v.StandardAddress",simpleAddres);
    },
    
    populateMap:function(component,event){
        var d =  component.get("v.StandardAddress");
        if( d.latitude == null ||  d.longitude ==null )
        {
            alert("We are not able to find the ");
            return;
        }
        var add = d.AddressLine1 +', '+d.AddressLine2+', '+d.City+', '+d.State+', '+d.CountryCode+', '+d.PostalCode;
        $A.createComponent("c:MapViewer",  
                           {"latitude": d.latitude ,"longitude":d.longitude,
                            "zoomControl":true,
                            "description":add}, 
                           function(cmp, status, errorMessage){
                               var divComponent = component.find("placeid");
                               if (divComponent != null && divComponent.isValid()) {
                                   var body = divComponent.get("v.body");
                                   body =[];
                                   body.push(cmp);
                                   divComponent.set("v.body",body);
                               }else{
                                   console.log("Not found div");
                                   //alert("not found div");
                               }
                           }); 
    },
    
    findCoordination:function(cmp){
        var add =  cmp.get("v.StandardAddress");
        // console.log(add);
        var action = cmp.get("c.initMe");
        action.setParams({"AddressJSON" : JSON.stringify(add)});
        action.setCallback(this,function(response){
            var status = response.getState();
            if(status =='SUCCESS'){
                var returnValue = response.getReturnValue();
                // console.log('returnValue>>>>>>'+returnValue);
                var returnValueJSON = JSON.parse(returnValue);
                
                // console.log('returnValue>>>>>>'+returnValueJSON);
                cmp.set("v.StandardAddress",returnValueJSON);
                cmp.set("v.isShowingMap",true);
                this.populateMap(cmp,null);
            }else{
                //console.log(response);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        
    }
})