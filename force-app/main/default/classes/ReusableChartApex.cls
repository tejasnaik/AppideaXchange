public class ReusableChartApex {
 //Returns the session Id by using visualforce Page SessionId
    public static String getSessionIdFromVFPage() {
        try{
            if(!test.isRunningTest()){
                PageReference visualforcePage = Page.SessionId;
                String content = visualforcePage.getContent().toString();
                Integer s = content.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
                    e = content.indexOf('End_Of_Session_Id');
                return content.substring(s, e);
            }
            return 'testSessionId';
        }Catch(Exception e){
            system.debug('EXception e = '+e);
        }
        return null;
    } 
    
    //get report data
    @AuraEnabled
    public static String GetReportData(String strReportName) {
        system.debug('got report name:- '+strReportName);
        system.debug('got session id:- :- '+getSessionIdFromVFPage());
        try {
            Id reportId = SOQLHelper.getReportId(strReportName);

            HttpResponse res;
            if (reportId != null) {
                HttpRequest req = new HttpRequest();
                req.setHeader('Authorization', 'Bearer ' + getSessionIdFromVFPage());
                req.setHeader('Content-Type', 'application/json');
                req.setMethod('GET');
                    system.debug('report id:- '+reportId);
                req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v29.0/analytics/reports/' + reportId + '?includeDetails=true');
                
                if(!test.isRunningTest()){
                Http h = new Http();
                res = h.send(req);

                while (res.getStatusCode() == 302) {
                    req.setEndpoint(res.getHeader('Location'));
                    res = new Http().send(req);
                }

                system.debug(' report res = -------------' + res);
                system.debug('report res body----------- = ' + res.getbody());
                
                return res.getbody();        
                }
                else
                {
                    //return ReportSampleResponse.GetSampleResponse();
                }
            }

            return null;
        }
        Catch(Exception e) {
            system.debug('Exception e:' + e.getMessage());
        }
        return null;
    }
    
    @AuraEnabled
    public static string getReportId(String strName)
    {
        return SOQLHelper.getReportId(strName);
    }

@AuraEnabled 
    public static String getBaseURL()
    {
        return  URL.getSalesforceBaseUrl().toExternalForm();
    }

   
}