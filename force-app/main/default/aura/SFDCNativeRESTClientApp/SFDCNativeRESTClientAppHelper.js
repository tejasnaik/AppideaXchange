/**
* @Helper : SFDCNativeRESTClientAppHelper
* @author Original:Narayana Bondigala(573339)
* @date Original: 8/15/2017
* @description :Integration call invoke from this helper.
* @Change History : 
**/
({
    fireRequest : function(component, event, helper) {
        try {           
            var inputReqData = component.get("v.inputReqData");        
            var headerDataList = component.get("v.headerList");             
            if(event.getSource().get("v.name") == 'Send') {
                var action = component.get("c.invokeHTTPReqtResMethod");   
                action.setParams({            
                    "inputInfo" :JSON.stringify(inputReqData),
                    "headers" :JSON.stringify(headerDataList)
                }); 
                action.setCallback(this, function(a) {                   
                    var state = a.getState();
                    if(component.isValid() && state === 'SUCCESS') { 
                        
                        component.set("v.responseBody",a.getReturnValue());
                        $A.util.removeClass(component.find("responseId"), "slds-hide");
                    }                
                });
            }
            if(event.getSource().get("v.name") == 'Save') {
                var action = component.get("c.save");   
                action.setParams({            
                    "inputInfo" :JSON.stringify(inputReqData),
                    "headers" :JSON.stringify(headerDataList)
                }); 
                action.setCallback(this, function(a) {  
                    var state = a.getState();
                    if(component.isValid() && state === 'SUCCESS') {                       
                        component.set("v.inputReqDataList",a.getReturnValue());
                         component.set("v.responseBody",'Saved Successfully.');
                         $A.util.removeClass(component.find("responseId"), "slds-hide");
                    }                
                });
            }
            
            $A.enqueueAction(action);
        } catch (e) {
            throw new Error("Exception is"+e);
        }  
    },    
    helperGetOAuthToken : function(component, event, helper, tokenRequest) {
        try {
            var action = component.get("c.oauthLogin");   
            action.setParams({            
                "loginURL" : component.find("urlIDValue").get("v.value"),
                "clientId" : tokenRequest.ClientId,
                "clientSecret" : tokenRequest.ClientSecret,
                "username" : tokenRequest.username,
                "password" : tokenRequest.password,
                "Securitytoken" : tokenRequest.Securitytoken,
                "method" : component.find("MethodId").get("v.value")
            }); 
            action.setCallback(this, function(a) {  
                var state = a.getState();
                if(component.isValid() && state === 'SUCCESS') {                    
                    component.set("v.responseBody",a.getReturnValue());
                    $A.util.removeClass(component.find("responseId"), "slds-hide");
                }                
            });
            $A.enqueueAction(action);
        } catch (e) {
            throw new Error("Exception is"+e);
        }  
    }
    
})