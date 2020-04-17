public class COE_PrintPreviewHttpServices {
    public static HttpResponse getHttpPrintPreviewService(String sessionId, String endpointServiceUrl) {
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + sessionId);
        req.setHeader('Content-Type', 'application/json');
        String domainUrl = URL.getSalesforceBaseUrl().toExternalForm();
        String endpointUrl = domainUrl+endpointServiceUrl;
        req.setEndpoint(endpointUrl);
        req.setMethod('GET');      
        Http h = new Http();
        HttpResponse res = h.send(req);
        System.debug('res >>'+res);
        return res;
    }
}