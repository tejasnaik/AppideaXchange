/*
*   Written By Ashlekh Gera
*   This class is a controller of CTS_Coomment lighting component. And provide the functions to get the user comment and save in DB.
*   Date - 18 April 2017
*/
public without sharing class Cts_CommentController {

    @AuraEnabled
    public static string getAllRelatedComments(String itemId, Integer limitNo,Integer offsetNo){
        
          OutPutWrapper opIns = new OutPutWrapper();
          opIns.isSuccess = false;    
        
        try
        {
            
            if(!(itemId instanceof id))
            { 
                opIns.message = 'Item id not valid.';
            
            }else{
                    String query = 'select id,CogniAppEx__Body__c,CogniAppEx__Days_Difference__c ,CogniAppEx__User__c,CogniAppEx__User__r.name,CogniAppEx__User__r.IsProfilePhotoActive,CogniAppEx__User__r.SmallPhotoUrl'; 
                           query +=' from CogniAppEx__Idea_Comment__c where CogniAppEx__Listing__c =:itemId order by createddate desc';
                    Integer totalComents = database.countQuery('select count() from CogniAppEx__Idea_Comment__c where CogniAppEx__Listing__c =:itemId ');
                    query +=' limit '+limitNo+' OFFSET '+offsetNo+' ';
            
                List<sObject> recordList = database.query(query);
                opIns.isSuccess = true;
                opIns.totalRecords = totalComents;
                opIns.message = 'SUCCESS';
                if(recordList !=null)
                   opIns.recordList = recordList;
            }    
                  
        }catch(Exception e){
            opIns.isSuccess = true;
            opIns.message = ''+e.getMessage();
        }
        return JSON.serialize(opIns);
    }
    
    /*
    *   Function - commentShareCaller();
    *   Parameters - 1.  String body  - Take the comment body provided by user. 
    *                2.  String CommentForID - Contain the id of entity for which or about comment is going to record.
    *                3.  String commentById - Contain the id of user who is going to comment.
    */
    
    @AuraEnabled
    public static String commentShareCaller(String body, String CommentForID, String commentById){
        
        OutPutWrapper opIns = validateParams(body, CommentForID, commentById);
        //opIns.message = 'Coming 1';
        if(!(commentById instanceof Id)){
                commentById =  UserInfo.getUserId();
        }
        
        //opIns.message = 'Coming 2';
        if(!opIns.isSuccess)
            return JSON.serialize( opIns);
        
       //opIns.message = 'Coming 3';
        try{
                body = body.replaceAll('\n',' ').replaceAll('\r',' ');
                OutPutWrapper result = logComment(body,CommentForID,commentById,opIns);
                if(result.isSuccess != null && result.isSuccess )
                {
                    opIns.message = ' Your comment has been saved.';
                }else{
                    opIns.isSuccess = false;
                }
        }catch(Exception e){
                opIns.isSuccess = false;
                opIns.message = 'commentShareCaller ['+e.getMessage()+']';
        }
        
        return JSON.serialize( opIns);
    }
    
    private static OutPutWrapper validateParams(String body, String CommentForID, String commentById){
        OutPutWrapper opIns = new OutPutWrapper();
        opIns.isSuccess = false;
        
        if(body == null || String.escapeSingleQuotes(body) == '' || String.escapeSingleQuotes(body).trim() == ''){
                opIns.message =  'Body not found';
        }
         
        if(!(CommentForID instanceof Id)){
                opIns.message =  'Comment taker not found';
        }
        
        if(opIns.message == null)
            opIns.isSuccess = true;
        
        return opIns;
    }
    
    public static string createComment(String listingId,String Userid ,String commentbody)
    {
        OutPutWrapper outPutWrap = new OutPutWrapper();
         outPutWrap.isSuccess = false;
        try
        {
            outPutWrap = validateParams(commentbody, listingId, Userid);
            if(outPutWrap.isSuccess != null &&  outPutWrap.isSuccess){
                if(Userid instanceof Id){
                    //commentbody = commentbody.replaceAll('-1-','\n').replaceAll('-2-','#2');
                    CogniAppEx__Idea_Comment__c ideaComtIns = new CogniAppEx__Idea_Comment__c();
                    ideaComtIns.CogniAppEx__Body__c = commentbody;
                    ideaComtIns.CogniAppEx__Comment_On__c = 'APPXChange';
                    ideaComtIns.CogniAppEx__Listing__c = listingId;
                    ideaComtIns.CogniAppEx__User__c = Userid;
                    insert ideaComtIns;
                    outPutWrap.isSuccess = true;
                    outPutWrap.message = 'SUCCESS';
                   
                }
            }
        }catch(Exception e){
            outPutWrap.message = 'createComment >> ['+e.getMessage()+']';
        }
        return JSON.serialize(outPutWrap);
    }

    
    //Hit the API to insert comment.
    private static OutPutWrapper logComment(String commentbody, String listingId, String Userid,OutPutWrapper opIns )
    {
        REST_API_Setting__mdt restAPISetting = Cts_AppXUtility.getCustomMetadata('Notification_REST_API_Config');
       
        if(restAPISetting != null && restAPISetting.Is_Active__c) {
            try{
                String body = '{"listingId":"'+listingId+'","userId":"'+Userid+'","body":"'+commentbody+'","type":"comments","extraData":""}';
                HttpRequest hr = Cts_AppXUtility.getRequest( restAPISetting.REST_Endpoint__c + '/v1/comments', 'POST', 'application/json', body );
                Http htp = new Http();
                if(!Test.isRunningTest()){
                    HttpResponse res = htp.send(hr);
                    if(res.getStatusCode() == 200){
                        opIns.isSuccess = true;
                        opIns.message = res.getBody();
                    }else{
                        opIns.isSuccess = false;
                        opIns.message = res.getBody()+' [logComment - API got Failed to pass this request.]';
                    }
                }else{
                    opIns.isSuccess = true;
                    opIns.message = 'SUCCESS';
                    createComment(listingId, Userid , commentbody);
                    return opIns;
                }
                
            }catch(Exception e){
                opIns.isSuccess = false;
                opIns.message = 'logComment error [1'+e.getMessage()+']';
            }
        }
        return opIns;
        
    }
    
    
    public class OutPutWrapper
    {
        public string message;
        public Boolean isSuccess;
        public List<sObject> recordList;
        public Integer totalRecords;
        public OutPutWrapper(){}
    }
    
}