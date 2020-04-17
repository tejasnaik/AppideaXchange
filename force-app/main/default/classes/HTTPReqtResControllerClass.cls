/*
* @class : HTTPReqtResControllerClass
* @author Original : Narayana Bondigala(573339)
* @Description : Connector between UI and Server side. 
* @Change History :
*/
public class HTTPReqtResControllerClass {
    /*
* User story : 
* @httpRest : Integrate with web service to process HTTP Request
* @param InputDataClass : inputInfo.  
* @return : String
*/
    @AuraEnabled
    public static String invokeHTTPReqtResMethod(String inputInfo , String headers) {
        InputDataClass inputInfoData = new InputDataClass();
        List<InputDataClass.HeaderClass> headerList = new List<InputDataClass.HeaderClass>();
        inputInfoData  = (InputDataClass) System.JSON.deserialize(inputInfo, InputDataClass.class);
        if(headers !=''){
            headerList  = (List<InputDataClass.HeaderClass>) System.JSON.deserialize(headers, List<InputDataClass.HeaderClass>.class);
            
        }
        System.debug('headerList@@@'+headerList);
        if(headerList != null && headerList.size() > 0){
            if(headerList[0].key == '' && headerList[0].value == '') {
                headerList = null;
            } 
        }
        
        String responseStr;
        try {
            if(inputInfo != null) {
                HTTPResponse response = new HTTPResponse();               
                response = HTTPReqtResIntegrationClass.processHTTPRequest(inputInfoData,headerList);
                responseStr = GlobalIntegrationSettingClass.getResponse(response); 
            }
        } catch(Exception ex) {
            System.debug('Exception @ '+ ex.getMessage() + ':' + ex.getLineNumber());
            if(ex.getMessage() == 'Unexpected end of file from server') {
                return 'The receiving server had a firewall blocking the sf IP addresses';
            }else {
                return ex.getMessage();
            }
            
        }
        return responseStr;
    }    
    @AuraEnabled
    public static String oauthLogin(String loginURL, String clientId, String clientSecret, String username, String password, String Securitytoken, String method) {
        HTTPResponse res = new HTTPResponse();
        try {
            HttpRequest req = new HttpRequest(); 
            req.setMethod(method);
            req.setEndpoint(loginURL+'/services/oauth2/token?client_id=' + clientId +'&client_secret=' + clientSecret + '&grant_type=password&username=' + username + '&password=' + password + Securitytoken);
            Http http = new Http();
            res = http.send(req);
        } catch (Exception ex) {
            System.debug('Exception is ' +  ex.getMessage() + ex.getLineNumber());
        }
        System.debug('response Body is ' + res.getBody());
        return res.getBody();
    }
    @AuraEnabled
    public static List<InputDataClass> save(String inputInfo , String headers) {
        List<SFDC_Native_REST_Client__c> SFDCnRCList = new List<SFDC_Native_REST_Client__c>();
        SFDC_Native_REST_Client__c SFDCnRC = new SFDC_Native_REST_Client__c();
        List<InputDataClass> finalDalaList = new List<InputDataClass>();
        try {
            System.debug('headersheaders'+inputInfo + '  '+headers);
            if(inputInfo != null) {
                InputDataClass inputInfoData = new InputDataClass();
                List<InputDataClass.HeaderClass> headerList = new List<InputDataClass.HeaderClass>();
                inputInfoData  = (InputDataClass) System.JSON.deserialize(inputInfo, InputDataClass.class);
                headerList  = (List<InputDataClass.HeaderClass>) System.JSON.deserialize(headers, List<InputDataClass.HeaderClass>.class);	
                SFDCnRCList =[Select URL__c,Id,Method_Type__c from SFDC_Native_REST_Client__c where URL__c =: inputInfoData.URL];
                if(SFDCnRCList.size() == 0) {
                    SFDCnRC.Body__c = inputInfoData.body;
                    SFDCnRC.Method_Type__c = inputInfoData.methodType;
                    SFDCnRC.URL__c = inputInfoData.URL;
                    SFDCnRC.Password__c = inputInfoData.password;
                    SFDCnRC.Username__c = inputInfoData.userName;
                    SFDCnRC.Author__c = inputInfoData.type;
                    SFDCnRC.ClientId__c = inputInfoData.clientId;
                    SFDCnRC.ClientSecret__c = inputInfoData.clientSecret;
                    SFDCnRC.SecurityToken__c = inputInfoData.Securitytoken;
                    
                    insert SFDCnRC;
                    System.debug('SFDCnRC###'+SFDCnRC);
                    if(headerList != null) {
                        List<Headers__c> headersList = new List<Headers__c>();
                        for(InputDataClass.HeaderClass headr : headerList) {
                            if(headr.key != '' && headr.value != '') {
                                Headers__c hdr = new Headers__c();
                                hdr.SFDC_Native_REST_Client__c = SFDCnRC.id;
                                hdr.Key__c = headr.key;
                                hdr.Value__c = headr.value;
                                headersList.add(hdr);
                            }
                        }
                        insert headersList;
                    }
                } 
                
            }           
            finalDalaList = fetchData();
        } catch (Exception ex) {
            System.debug('Exception is ' +  ex.getMessage() + ex.getLineNumber());
        }       
        return finalDalaList;
    }
    @AuraEnabled
    public static List<InputDataClass> fetchData() {
        List<InputDataClass> returnDataList = new List<InputDataClass>();
        
        try {
            List<SFDC_Native_REST_Client__c> SFDCNativeList = [Select Username__c,Body2__c, URL__c, SecurityToken__c, Password__c, OwnerId, Name, Method_Type__c, Id, isSelected__c,CreatedById, ClientSecret__c, ClientId__c, Body__c, Author__c, (Select Key__c, Value__c From Headers__r) From SFDC_Native_REST_Client__c];
            System.debug('SFDCNativeList'+SFDCNativeList);
            if(SFDCNativeList != null) {
                for(SFDC_Native_REST_Client__c selectedRecord :SFDCNativeList) {
                    InputDataClass returnData = new InputDataClass();
                    returnData.body =  selectedRecord.Body__c; 
                    returnData.methodType = selectedRecord.Method_Type__c;
                    returnData.URL = selectedRecord.URL__c;
                    returnData.password = selectedRecord.Password__c;
                    returnData.userName = selectedRecord.Username__c;
                    returnData.type = selectedRecord.Author__c;
                    returnData.clientId = selectedRecord.ClientId__c;
                    returnData.clientSecret = selectedRecord.ClientSecret__c;
                    returnData.Securitytoken = selectedRecord.SecurityToken__c;
                    returnData.isSelected = false;
                    returnData.id = selectedRecord.Id;
                    for(Headers__c hdr : selectedRecord.Headers__r ) {
                        InputDataClass.HeaderClass header = new  InputDataClass.HeaderClass();
                        if(hdr.Key__c != null && hdr.Value__c != null) {
                            header.key = hdr.Key__c;
                            header.value = hdr.Value__c;
                            returnData.headerList.add(header);
                        }
                        
                    }
                    returnDataList.add(returnData);
                }  
            }
            
        } catch (Exception ex) {
            System.debug('Exception is ' +  ex.getMessage() + ex.getLineNumber());
        }       
        return returnDataList;
    }
}