@isTest
public class ReCaptchaControllerTest {
    
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"success":"true"}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    @isTest static void testVerify() {
        ReCaptchaController reCapObj = new ReCaptchaController();
        reCapObj.verified = true;
        reCapObj.myName = 'test';
        reCapObj.myEmail = 'test';
        String publicKey = reCapObj.publicKey;
        String response = reCapObj.response;
        String challenge = reCapObj.challenge;
        PageReference ref1 = reCapObj.reset();

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        reCapObj.verify('http://api.salesforce.com/foo/bar', 'your private key here!', 'Host', 'Challenge', 'Response');
        reCapObj.verify('http://api.salesforce.com/foo/bar', 'your private key here!', 'Host', 'Challenge', null);
        Test.stopTest();
    }
    
    @isTest static void testRemoteHost() {
        ReCaptchaController reCapObj = new ReCaptchaController();
        String remote = reCapObj.remoteHost;
    }
}