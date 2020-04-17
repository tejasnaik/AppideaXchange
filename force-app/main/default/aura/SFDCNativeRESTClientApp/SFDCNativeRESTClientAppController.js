/**
* @Helper : SFDCNativeRESTClientAppController
* @author Original:Narayana Bondigala(573339)
* @date Original: 8/15/2017
* @description : on Page Loading Add one empty header in header section and also have fire request when click on submit button.
* @Change History : 
**/
({
    doInit : function(component, event, helper) {        
        var inputReqData = component.get("v.inputReqData");       
        var emptyList = component.get("v.headerList"); 
        
        var headetData = new Object();
        headetData.key ='';
        headetData.value = '';
        emptyList.push(headetData);        
        component.set("v.headerList", emptyList); 
        
        var action = component.get("c.fetchData");          
        action.setCallback(this, function(a) {  
            var state = a.getState();
            if(component.isValid() && state === 'SUCCESS') { 
               
                component.set("v.inputReqDataList",a.getReturnValue());               
            }                
        });        
        $A.enqueueAction(action);
    },
    fireRequest : function(component, event, helper) { 
        component.set("v.responseBody", null);
        var inputReqData = component.get("v.inputReqData");
        var inputReq = new Object();
        var type = component.find("TypeId").get("v.value");               
        if(component.find("MethodId").get("v.value") != 'Method') {
            component.find("MethodId").set("v.errors", null);
            inputReq.methodType = component.find("MethodId").get("v.value");
        } else {
            component.find("MethodId").set("v.errors", [{message:"Please select Method"}]);
        }
        if(!$A.util.isEmpty(component.find("urlIDValue").get("v.value")) && !$A.util.isUndefined(component.find("urlIDValue").get("v.value"))) {
            component.find("urlIDValue").set("v.errors", null);
            inputReq.URL = component.find("urlIDValue").get("v.value");
        } else {
            component.find("urlIDValue").set("v.errors", [{message:"Please provide URL"}]);
        }
        if(!$A.util.isEmpty(type) && !$A.util.isUndefined(type)) {
            inputReq.type = type;
        }
        if(type == 'BasicAuth') {
            if(!$A.util.isEmpty(component.find("UsernameId").get("v.value")) && !$A.util.isUndefined(component.find("UsernameId").get("v.value"))) {
                inputReq.userName = component.find("UsernameId").get("v.value");
                component.find("UsernameId").set("v.errors", null);
            } else {
                component.find("UsernameId").set("v.errors", [{message:"Please provide Username"}]);
            }
            if(!$A.util.isEmpty(component.find("PasswordId").get("v.value")) && !$A.util.isUndefined(component.find("PasswordId").get("v.value"))) {
                inputReq.password = component.find("PasswordId").get("v.value");
                component.find("PasswordId").set("v.errors", null);
            } else {
                component.find("PasswordId").set("v.errors", [{message:"Please provide Password"}]); 
            }
        }if(type == 'OAuth2') {
            if(!$A.util.isEmpty(component.find("usernameId").get("v.value")) && !$A.util.isUndefined(component.find("usernameId").get("v.value"))) {
                inputReq.userName = component.find("usernameId").get("v.value");
                component.find("usernameId").set("v.errors", null);
            } else {
                component.find("usernameId").set("v.errors", [{message:"Please provide UserName"}]);            
            }
            if(!$A.util.isEmpty(component.find("passwordId").get("v.value")) && !$A.util.isUndefined(component.find("passwordId").get("v.value"))) {
                inputReq.password = component.find("passwordId").get("v.value");
                component.find("passwordId").set("v.errors", null);
            } else {
                component.find("passwordId").set("v.errors", [{message:"Please provide Password"}]);           
            }
            if(!$A.util.isEmpty(component.find("ClientId").get("v.value")) && !$A.util.isUndefined(component.find("ClientId").get("v.value"))) {
                inputReq.clientId = component.find("ClientId").get("v.value");
                component.find("ClientId").set("v.errors", null);
            } else {
                component.find("ClientId").set("v.errors", [{message:"Please provide Client Id"}]);
            }
            if(!$A.util.isEmpty(component.find("ClientSecretId").get("v.value")) && !$A.util.isUndefined(component.find("ClientSecretId").get("v.value"))) {
                inputReq.clientSecret = component.find("ClientSecretId").get("v.value");
                component.find("ClientSecretId").set("v.errors", null);
            } else {
                component.find("ClientSecretId").set("v.errors", [{message:"Please provide Client Secret "}]);
                
            }
            if(!$A.util.isEmpty(component.find("SecuritytokenId").get("v.value")) && !$A.util.isUndefined(component.find("SecuritytokenId").get("v.value"))) {
                inputReq.Securitytoken = component.find("SecuritytokenId").get("v.value");
                component.find("SecuritytokenId").set("v.errors", null);
            }
        }    
        if(component.find("MethodId").get("v.value") != 'Method' && component.find("MethodId").get("v.value") != 'GET') {
            if(!$A.util.isEmpty(component.find("reqBodyId").get("v.value")) && !$A.util.isUndefined(component.find("reqBodyId").get("v.value"))) {
                inputReq.body = component.find("reqBodyId").get("v.value");
                component.find("reqBodyId").set("v.errors", null);
            } else {
                component.find("reqBodyId").set("v.errors", [{message:"Please provide Body"}]);
            }
        }
        component.set("v.inputReqData", inputReq);      
        helper.fireRequest(component, event, helper);
    },
    addRow : function(component, event, helper)  {
        var headerDataList = component.get("v.headerList");        
        var headetData = new Object();
        headetData.key ='';
        headetData.value = '';
        headerDataList.push(headetData);        
        component.set("v.headerList", headerDataList); 
    },
    removeRow :function(component, event, helper)  {
        var headerDataList = component.get("v.headerList");
        var idx = event.currentTarget.dataset.record; 
        headerDataList.splice(idx,1); 
        var updatedDataList = component.get("v.headerList");
        component.set("v.headerList", updatedDataList); 
    },
    invokeAuthorization : function(component, event, helper) { 
        component.set("v.selectedType",'Authorization');        
    },
    invokeHeaders : function(component, event, helper) { 
        component.set("v.selectedType",'Headers');
    },
    invokeBody : function(component, event, helper) { 
        component.set("v.selectedType",'Body');
    },
    onTypeChange : function(component, event, helper) { 
        if(component.find("TypeId").get("v.value") == 'BasicAuth') {
            component.set("v.enableBasicauth",'BasicAuth');
        }
        if(component.find("TypeId").get("v.value") == 'OAuth2') {
            component.set("v.enableBasicauth",'OAuth2');
        }
        if(component.find("TypeId").get("v.value") == 'NoAuth') {
            component.set("v.enableBasicauth",'NoAuth');
        }
    },    
    onGrandTypeChange : function(component, event, helper) {
        if(component.find("GrandTypeId").get("v.value") == 'AuthorizationCode') {
            component.set("v.grandType",'AuthorizationCode');
        } else if(component.find("GrandTypeId").get("v.value") == 'ClientCredentials') {
            component.set("v.grandType",'ClientCredentials');
        }
    },
    
    getOAuthToken :  function(component, event, helper) {
        var tokenRequest = new Object();
        var isValid = true;        
        if(!$A.util.isEmpty(component.find("usernameId").get("v.value")) && !$A.util.isUndefined(component.find("usernameId").get("v.value"))) {
            tokenRequest.username = component.find("usernameId").get("v.value");
            component.find("usernameId").set("v.errors", null);
        } else {
            component.find("usernameId").set("v.errors", [{message:"Please provide UserName"}]);
            isValid = false;
        }
        if(!$A.util.isEmpty(component.find("passwordId").get("v.value")) && !$A.util.isUndefined(component.find("passwordId").get("v.value"))) {
            tokenRequest.password = component.find("passwordId").get("v.value");
            component.find("passwordId").set("v.errors", null);
        } else {
            component.find("passwordId").set("v.errors", [{message:"Please provide Password"}]);
            isValid = false;
        }
        if(!$A.util.isEmpty(component.find("ClientId").get("v.value")) && !$A.util.isUndefined(component.find("ClientId").get("v.value"))) {
            tokenRequest.ClientId = component.find("ClientId").get("v.value");
            component.find("ClientId").set("v.errors", null);
        } else {
            component.find("ClientId").set("v.errors", [{message:"Please provide Client Id"}]);
            isValid = false;
        }
        if(!$A.util.isEmpty(component.find("ClientSecretId").get("v.value")) && !$A.util.isUndefined(component.find("ClientSecretId").get("v.value"))) {
            tokenRequest.ClientSecret = component.find("ClientSecretId").get("v.value");
            component.find("ClientSecretId").set("v.errors", null);
        } else {
            component.find("ClientSecretId").set("v.errors", [{message:"Please provide Client Secret "}]);
            isValid = false;
        }
        if(!$A.util.isEmpty(component.find("SecuritytokenId").get("v.value")) && !$A.util.isUndefined(component.find("SecuritytokenId").get("v.value"))) {
            tokenRequest.Securitytoken = component.find("SecuritytokenId").get("v.value");
            component.find("SecuritytokenId").set("v.errors", null);
        } else {
            component.find("SecuritytokenId").set("v.errors", [{message:"Please provide Security token"}]);
            isValid = false;
        }
        if(isValid) {
            helper.helperGetOAuthToken(component, event, helper, tokenRequest);
        }
    },     
    CancelOAuth : function(component, event, helper) {        
        component.find("passwordId").set("v.value","");
        component.find("passwordId").set("v.errors", null);
        component.find("SecuritytokenId").set("v.value","");
        component.find("SecuritytokenId").set("v.errors", null);
        component.find("usernameId").set("v.value","");
        component.find("usernameId").set("v.errors", null);
        component.find("ClientSecretId").set("v.value","");
        component.find("ClientSecretId").set("v.errors", null);
        component.find("ClientId").set("v.value","");
        component.find("ClientId").set("v.errors", null);        
    },
    showSpinner : function (component, event, helper) {
        $A.util.removeClass(component.find("spinnerID"), "slds-hide");
        window.setTimeout(
            $A.getCallback(function() {
                $A.util.addClass(component.find("spinnerID"), "slds-hide");   
            }), 12000
        );		
    },
    hideSpinner : function (component, event, helper) {
        $A.util.addClass(component.find("spinnerID"), "slds-hide");   
    },
    showReqDetail : function(component, event, helper) {
        var emptyList = [];
        var reqDataList = component.get("v.inputReqDataList");
        var reqDataEmptyList = component.get("v.inputReqDataEmptyList");
        component.set("v.inputReqDataEmptyList",emptyList);
        for(var i= 0; i<= reqDataList.length - 1; i++) {
            if(reqDataList[i].id == event.currentTarget.dataset.record) {
                reqDataList[i].isSelected = true;
                component.find("MethodId").set("v.value",reqDataList[i].methodType);
                component.find("urlIDValue").set("v.value",reqDataList[i].URL);
                component.find("TypeId").set("v.value",reqDataList[i].type);               
                component.find("reqBodyId").set("v.value",JSON.stringify(reqDataList[i].body));
                if(reqDataList[i].type == 'BasicAuth') {
                    component.find("UsernameId").set("v.value",reqDataList[i].userName);
                    component.find("PasswordId").set("v.value",reqDataList[i].password);
                }
                if(reqDataList[i].type == 'OAuth2') {
                    component.find("usernameId").set("v.value",reqDataList[i].userName);
                    component.find("passwordId").set("v.value",reqDataList[i].password);
                    component.find("ClientId").set("v.value",reqDataList[i].clientId);
                    component.find("ClientSecretId").set("v.value",reqDataList[i].clientSecret);
                    component.find("SecuritytokenId").set("v.value",reqDataList[i].Securitytoken);
                    
                }
                component.set("v.headerList",emptyList);
                var headersDataList = component.get("v.headerList");
                for(var j=0; j<=reqDataList[i].headerList.length -1 ;j++ ) {
                    var headetData = new Object();
                    headetData.key =reqDataList[i].headerList[j].key;
                    headetData.value = reqDataList[i].headerList[j].value;
                    headersDataList.push(headetData);
                }
                component.set("v.headerList",headersDataList); 
                
            }else {
                reqDataList[i].isSelected = false;
            }
            reqDataEmptyList.push(reqDataList[i]);
        } 
         if(component.find("TypeId").get("v.value") == 'BasicAuth') {
            component.set("v.enableBasicauth",'BasicAuth');
        }
        if(component.find("TypeId").get("v.value") == 'OAuth2') {
            component.set("v.enableBasicauth",'OAuth2');
        }
        if(component.find("TypeId").get("v.value") == 'NoAuth') {
            component.set("v.enableBasicauth",'NoAuth');
        }
        component.set("v.inputReqDataList",emptyList);
        component.set("v.inputReqDataList",reqDataEmptyList);
        
    }    
})