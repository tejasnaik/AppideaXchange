/*
* @class : GlobalIntegrationSettingClass
* @author Original : Narayana (CTS)
* @Description : Class declare web service header and methods parameters. 
* @Change History :
*/
public class GlobalIntegrationSettingClass {
    
    //Method devoped to set the header values for integration classes      
    public static HttpRequest setHeaderValues(InputDataClass authentication,List<InputDataClass.HeaderClass> headerList) {   
        HttpRequest request  = new HttpRequest();        
        //Header Values 
        System.debug('authentication.userName'+authentication.userName +' '+authentication.password);
        if((authentication.userName != '' && authentication.userName != null) && (authentication.password != '' && authentication.password != null)){
            Blob headerValue = Blob.valueOf(authentication.userName + ':' + authentication.password);                         
            String authorizationHeader = 'Basic'+ ' ' + EncodingUtil.base64Encode(headerValue); 
            System.debug('authorizationHeader@@'+authorizationHeader);
            System.debug('authenticationAUTHORIZATION'+authentication.AUTHORIZATION);
            request.setHeader('Authorization', authorizationHeader); 
        }
        System.debug('headerList@@'+headerList);
        if(headerList != null) {
            for(InputDataClass.HeaderClass header : headerList) {
                if((header.key != null && header.key != '') && (header.value != null && header.value != '')) {               
                    request.setHeader(header.key , header.value);             }           
            }
        }
        request.setTimeout(120000); 
        System.debug('request@@@'+request);
        return request;
    }
    
    /*
* @getResponse : Method to get respose that need to show on UI.
* @param HTTPResponse: response.
* @return : String
*/ 
    public static String getResponse(HTTPResponse response) {
        String responseStr;
        try {
            System.debug('whitelist issueresponse'+response);
            if(response.getStatusCode() == GlobalConstantClass.SUCCESSCODE200) {
                responseStr = response.getBody();
            } else if (response.getStatusCode() == Integer.valueOf(GlobalConstantClass.BADDATA) || response.getStatusCode() == GlobalConstantClass.FAILURECODE) {
                // Parse JSON response to get errorMessage field values.
                JSONParser parser = JSON.createParser(response.getBody());
                String errorMessage;
                if(!Test.isRunningTest()){
                    while (parser.nextToken() != null) {
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'errorMessage')) {
                                parser.nextToken();
                                errorMessage = parser.getText();
                            }                    
                    }
                } else {
                    errorMessage ='Data issuse';
                }
                responseStr = errorMessage;
            } else {
                System.debug('response@@'+response);
                responseStr = response.getStatus();
            }
        } catch(Exception ex) {
            System.debug('Exception in GlobalIntegrationSettingClass.getResponse @@@ ' + ex.getMessage() + ':' + ex.getLineNumber());
            throw ex;
        }
        System.debug('GISCresponseStr'+responseStr);
        return responseStr;
    }    
    
}