/*
* Author	: Sachin Chavan
* Date 	 	: April 2017
*/

public without sharing class IdeaXChangeController {
    
     @AuraEnabled
    public static String lookupSearch(String objectName, String keyword) {
        keyword = '\'%' + keyword + '%\'';
        String query = 'SELECT Id, Name FROM ' + objectName + ' WHERE Name LIKE ' + keyword + 'and IsActive=true LIMIT 5';
        List<SObject> recordList = Database.query(query);
        
        return JSON.serialize(recordList);
    }
    
    @AuraEnabled
    public static List<String> getpicklistvalues(String objectname, String fieldname) {
      List<String> values = new List<String>();
      List<String> types = new List<String>();
      types.add(objectname);
      Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
      for(Schema.DescribeSobjectResult res : results) {
         for (Schema.PicklistEntry entry : res.fields.getMap().get(fieldname).getDescribe().getPicklistValues()) {
            if (entry.isActive()) {values.add(entry.getValue());}
         }
      }
      return values;
   }


    
    @AuraEnabled
    public static Map<String,Object> getIdeaList(String filterType, String searchKeyword, Integer iLimit) {
        Map<String,Object> result = new Map<String,Object>();
        String query = 	'SELECT Id, Name, CogniAppEx__User__c, CogniAppEx__User__r.Name, CogniAppEx__User__r.SmallPhotoUrl, CogniAppEx__Title__c, CogniAppEx__POC__c,CogniAppEx__POC__r.Name, CogniAppEx__Description__c,CogniAppEx__Vertical__c,CogniAppEx__Cloud__c, CogniAppEx__Category__c, CogniAppEx__Like_Count__c, CogniAppEx__Dislike_Count__c, CogniAppEx__Status__c, CogniAppEx__Days_Difference__c, CreatedDate, (SELECT Id FROM CogniAppEx__Idea_Comments__r) ' +
            			'FROM CogniAppEx__Idea__c';
        String countQuery = 'SELECT COUNT() FROM CogniAppEx__Idea__c';
        
        if(String.isNotBlank(searchKeyword)) {
            query += ' WHERE CogniAppEx__Title__c LIKE \'%' + searchKeyword + '%\'';
            countQuery += ' WHERE CogniAppEx__Title__c LIKE \'%' + searchKeyword + '%\'';
        }
        
        if('RECENT'.equalsIgnoreCase(filterType)) {
            query += ' ORDER BY CreatedDate DESC';
        } else if('POPULAR'.equalsIgnoreCase(filterType)) {
            query += ' ORDER BY CogniAppEx__Like_Count__c DESC';
        }
        
        if(iLimit != null) {
            query += ' LIMIT ' + iLimit;
        }
        
        List<SObject> ideaList = Database.query(query);
        Integer iIdeaCount = Database.countQuery(countQuery);
        result.put('success', true);
        result.put('IdeaList', ideaList);
        result.put('IdeaCount', iIdeaCount);
        
        return result;
    }
    
    @AuraEnabled
    public static List<Idea_Comment__c> getIdeaCommentsFor(String ideaId) {
        List<Idea_Comment__c> ideaCommentList = [SELECT Id, Name, CogniAppEx__User__r.Name, CogniAppEx__User__r.SmallPhotoURL, CogniAppEx__Days_Difference__c, CogniAppEx__Body__c, CogniAppEx__Idea__c, CreatedDate 
                                                 FROM CogniAppEx__Idea_Comment__c
                                                 WHERE CogniAppEx__Idea__c = :ideaId
                                                 ORDER BY CreatedDate DESC];
        return ideaCommentList;
    }
    
    /*
     * Author		: Sachin Chavan
     * Description	: This is utility method used to insert new Ideas.
     * Date 	 	: April 2017
     */
    @AuraEnabled
    public static Map<String,Object> submitIdea(String title, String category, String description, String pocId,String Vertical ,String Cloud) {
        /*SY 0403 Add POC*/
        system.debug('Vertical'+Vertical);
        //String requestBody = '{ "action" : "IDEA", "title" : "' + title + '", "category" : "' + category + '", "body" : "' + description + '", "userId" : "' + Userinfo.getUserId() + '" }';
        String requestBody = '{ "action" : "IDEA", "title" : "' + title + '", "category" : "' + category + '", "body" : "' + description + '", "userId" : "' 
            + Userinfo.getUserId() + '", "POCId" : "' + pocId + '" , "Vertical" : "' + Vertical + '", "Cloud" : "' + Cloud + '"}';
        
        /*SY 0403 Add POC*/
        requestBody = requestBody.replaceAll('\r\n', ' ');
        Map<String,Object> restResponse = IdeaXChangeController.executeHTTPRequest(requestBody);

        return restResponse;
    }
    
    /*
     * Author		: Sachin Chavan
     * Description	: This is utility method used to insert new Idea Comments.
     * Date 	 	: April 2017
     */
    @AuraEnabled
    public static Map<String,Object> submitIdeaComment(String ideaId, String description) {
        String requestBody = '{ "action" : "IDEA_COMMENT", "ideaId" : "' + ideaId + '", "body" : "' + description + '", "userId" : "' + Userinfo.getUserId() + '" }';
        requestBody = requestBody.replaceAll('\r\n', ' ');
        Map<String,Object> restResponse = IdeaXChangeController.executeHTTPRequest(requestBody);
        
        return restResponse;
    }
    
    /*
     * Author		: Sachin Chavan
     * Description	: This is utility method used to insert new Idea Votes.
     * Date 	 	: April 2017
     */
    @AuraEnabled
    public static Map<String,Object> submitIdeaVote(String ideaId, String voteType) {
        Map<String,Object> restResponse = new Map<String,Object>();
        restResponse.put('success', true);
        
        Integer iRecordCount = [SELECT COUNT() FROM CogniAppEx__Idea_Vote__c WHERE User__c = :Userinfo.getUserId() AND Idea__c = :ideaId AND CogniAppEx__Type__c = :voteType];
        if(iRecordCount > 0) {
            restResponse.put('message', 'You have already submitted your feedback for this idea.');
            return restResponse;
        } else {
            String requestBody = '{ "action" : "IDEA_VOTE", "ideaId" : "' + ideaId + '", "userId" : "' + Userinfo.getUserId() + '", "voteType" : "' + voteType + '" }';
            restResponse = IdeaXChangeController.executeHTTPRequest(requestBody);   
        }
        
        return restResponse;
    }
    
    /*
     * Author		: Sachin Chavan
     * Description	: This is utility method used to make HTTP Callouts.
     * Date 	 	: April 2017
     */
    private static Map<String,Object> executeHTTPRequest(String requestBody) {
        Map<String,Object> restResponse = new Map<String,Object>();
        restResponse.put('success', true);
        
        try {
            HTTPResponse response = null;
            CogniAppEx__REST_API_Setting__mdt restAPISetting = [SELECT MasterLabel, DeveloperName, CogniAppEx__REST_Endpoint__c, CogniAppEx__Is_Active__c 
                                                                FROM CogniAppEx__REST_API_Setting__mdt
                                                                WHERE DeveloperName = 'Idea_REST_API_Config'];
            
            if(restAPISetting != null && restAPISetting.CogniAppEx__Is_Active__c) {
                HttpRequest request = new HttpRequest();
                request.setMethod('POST');
                request.setEndpoint(restAPISetting.CogniAppEx__REST_Endpoint__c);
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('Accept', 'application/json');
                request.setBody(requestBody);
                
                Http httpClient = new Http();
                if(!Test.isRunningTest()){
                    response = httpClient.send(request);
                    if(response.getStatusCode() == 200) {
                        restResponse.put('success', true);
                        restResponse.put('message', 'HTTP REST Callout processed successfully.');
                    } else {
                        restResponse.put('success', false);
                        restResponse.put('status', response.getStatus());
                        restResponse.put('statusCode', response.getStatusCode());
                        restResponse.put('message', 'An error occurred while processing your request. Please contact your System Administrator.');
                    }
                    
                    restResponse.put('response', response.getBody());
                }
            }
        } catch(Exception ex) {
            restResponse.put('success', false);
            restResponse.put('message', ex.getMessage());
            restResponse.put('stackTrace', ex.getStackTraceString());
            restResponse.put('exceptionType', ex.getTypeName());
        }
        
        return restResponse;
    }
}