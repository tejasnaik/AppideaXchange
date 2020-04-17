public class GoogleMapsController{
    public static string getGoogleMapsAPIKey(){
        string strKey = Label.GOOGLE_API_KEY;
        return strKey;
    }
    @AuraEnabled
    public static string getAddressAutoComplete(String input, String types) {
        String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input='
            + EncodingUtil.urlEncode(input, 'UTF-8')
            + '&types=' + types
            + '&key=' + GoogleMapsController.getGoogleMapsAPIKey();
        return GoogleMapsController.getHttp(url);
    }
    
    public static string getHttp(string strURL){
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setMethod('GET');
        req.setEndpoint(strURL);
        req.setTimeout(120000);
        
        String responseBody = '';
        
        if(!Test.isRunningTest()) {
            res = h.send(req); 
            responseBody  = res.getBody(); 
        }
            
        return responseBody;
    }
}