/*
* Class : HTTPReqtResControllerClassTest 
* Description : Class to cover code for HTTPReqtResControllerClass.
* @author : Narayana(573339)
* History : 
*/
@isTest
public class HTTPReqtResControllerClassTest {    
    /*
* @testHTTPReqtResClassMethod : Test method is to cover HTTPReqtResControllerClass.
*/
    public static testMethod void testHTTPReqtResClassMethod() {
        HTTPReqtResControllerClass.oauthLogin('loginUri','clientId','clientSecret', 'username', 'password','Securitytoken','method'); 
        String inputInfo ='{"methodType":"GET","URL":"https://private-454903-lifetimecreditbilling.apiary-mock.com/billing_product_module/v2/discounts/10001/CRCOM","type":"NoAuth"}';
        String headers ='[{"key":"key1","value":"value1"},{"key":"key2","value":"value2"}]';
        HTTPReqtResControllerClass.invokeHTTPReqtResMethod(inputInfo,headers); 
        HTTPReqtResControllerClass.save(inputInfo,headers); 
        
    }
}