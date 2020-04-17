/*
//Author : Sumit Sharma Flash
//ID	 : 575360
*/
public class ReCaptchaController {

    // The API endpoint for the ReCaptcha service
    @TestVisible private static String baseUrl = 'https://www.google.com/recaptcha/api/verify'; 

    // The keys you get by signing up for ReCaptcha for your domain
    @TestVisible private static String privateKey = 'your private key here!';
    public String publicKey { 
        get { return 'your public site key here!'; }
    } 

    /* Implementation */
    
    public String myName { get; set; }
    public String myEmail { get; set; }
    
    // Create properties for the non-VF component input fields generated
    // by the ReCaptcha JavaScript.
    @TestVisible public String challenge { 
        get {
            return ApexPages.currentPage().getParameters().get('recaptcha_challenge_field');
        }
    }
    @TestVisible public String response  { 
        get {
            return ApexPages.currentPage().getParameters().get('recaptcha_response_field');
        }
    }
    
    @TestVisible public Boolean verified { get; private set; }
    
    public ReCaptchaController() {
        this.verified = false;
    }
    
    public PageReference verify(){
        //DELETE THIS METHOD AS IT IS FOR TESTING PURPOSE ONLY
        return null;
    }
    
        // On first page load, form is empty, so no request to make yet
    public PageReference verify(String baseUrl, String privateKey, String remoteHost, String challenge, String response) //PLEASE REMOVE ALL THE PARAMETERS IN 'verify()' AS IT IS ONLY REQUIRED FOR TESTING
    { 
        System.debug('ReCaptcha verification attempt');
        if ( challenge == null || response == null ) { 
            System.debug('ReCaptcha verification attempt with empty form');
            return null; 
        }
                    
        HttpResponse r = makeRequest(baseUrl,
            'privatekey=' + privateKey + 
            '&remoteip='  + remoteHost + 
            '&challenge=' + challenge +
            '&response='  + response
        );
        
        if ( r!= null ) {
            this.verified = (r.getBody().startsWithIgnoreCase('true'));
        }
        
        if(this.verified) {
            // If they pass verification, you might do something interesting here
            // Or simply return a PageReference to the "next" page
			System.debug('Verified');
            return null;
        }
        else {
            // stay on page to re-try ReCaptcha
			System.debug('Not Verified');
            return null; 
        }
    }

    public PageReference reset() {
        return null; 
    }   

    /* Private helper methods */
    
    @TestVisible private static HttpResponse makeRequest(string url, string body)  {
        HttpResponse response = null;
        HttpRequest req = new HttpRequest();   
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody (body);
        try {
            Http http = new Http();
            response = http.send(req);
            System.debug('ReCaptcha response: ' + response);
            System.debug('ReCaptcha body: ' + response.getBody());
        } catch(System.Exception e) {
            System.debug('ERROR: ' + e);
        }
        return response;
    }   
        
    @TestVisible private String remoteHost { 
        get { 
            String ret = '127.0.0.1';
            Map<String, String> hdrs = ApexPages.currentPage().getHeaders();
            if (hdrs.get('x-original-remote-addr')!= null)
                ret =  hdrs.get('x-original-remote-addr');
            else if (hdrs.get('X-Salesforce-SIP')!= null)
                ret =  hdrs.get('X-Salesforce-SIP');
            return ret;
        }
    }
}