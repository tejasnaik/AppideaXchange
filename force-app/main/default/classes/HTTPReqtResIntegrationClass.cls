/*
* @class : HTTPReqtResIntegrationClass
* @author Original : Narayana Bondigala (573339)
* @Description : HTTP request and Responce connector 
* @Change History :
*/
public class HTTPReqtResIntegrationClass {
    /*
* User story : 
* @httpRest : Integrate with web service to process HTTP Request
* @param InputDataClass : inputInfo.  
* @return : HTTPResponse
*/
    public static HTTPResponse processHTTPRequest(InputDataClass inputInfo,List<InputDataClass.HeaderClass> headerList) {
        Http httpRest = new Http();
        HttpRequest httpRestRequest = new HttpRequest();
        HTTPResponse httpRestResponse = new HttpResponse();        
        try {          
            // set http request header
            httpRestRequest = GlobalIntegrationSettingClass.setHeaderValues(inputInfo,headerList);           
            //Endpoint 
            httpRestRequest.setEndpoint(inputInfo.URL);           
            //Request Method            
            httpRestRequest.setMethod(inputInfo.methodType);
            System.debug('inputInfobody'+inputInfo.body);
            if(inputInfo.body != null) {
                httpRestRequest.setBody(inputInfo.body);    
            }
            //Http call
            if(!Test.isRunningTest()){
                System.debug('httpRestRequest@@'+httpRestRequest);
                
                httpRestResponse = httpRest.send(httpRestRequest);
                System.debug('httpRestResponse@@'+httpRestResponse);
            }else {
                //TestData
                HttpResponse responseTestData = new HttpResponse();        
                responseTestData.setStatusCode(400);  
                responseTestData.setStatus('Ok');                
                responseTestData.setBody('responseBody');
                return responseTestData; 
            }
        } catch(Exception ex) {
            System.debug('Exception @@@ ' + ex.getMessage() + ':' +  ex.getLineNumber());
            throw ex;
        }        
        return httpRestResponse;
    } 
}