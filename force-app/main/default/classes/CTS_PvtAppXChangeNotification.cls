/*
* Created By : Ashlekh Gera 
* This Class has been expose on site to provide API method for Chatter APPXChange aplication.
* Currenly only having POST verb to insert the Page and Install hit functionality. 
*/
@RestResource(urlMapping='/notificationservice/*')
global without sharing class CTS_PvtAppXChangeNotification {
    
    @HttpPost
    global static String doPost(String listingId, String userId){
        RestRequest req = RestContext.request;
        String postRedirectPath = (req ==null)?'Install':req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        if(listingId instanceof Id)
            return logActivity(listingId,postRedirectPath,userId);
        
        return '.';
    }
    
    /*
* Create log activities for page hits and install hints.
*/
    private static String logActivity(String listingId,String postRedirectPath, String userId){
        try{
            Id recordTypeId;
            String SOBJECT_NAME = asb_ListingActivity__c.SObjectType.getDescribe().getName();
            for (RecordType rt : [SELECT ID, name FROM RecordType where sobjectType = :SOBJECT_NAME and name =:postRedirectPath]) {
                recordTypeId = rt.id;
            }
            asb_ListingActivity__c laObj = new asb_ListingActivity__c();
            laObj.asb_Listing__c = listingId;
            laObj.CogniAppEx__Visitor__c = userId;   
            laObj.RecordTypeId = recordTypeId; 
            laObj.Duplicate__c = getIsDuplicate(listingId,null,recordTypeId,userId);
            insert laObj;
            return laObj.id;
        }catch(Exception e ){
            system.debug(''+e.getMessage());
        }
        return '';
    }
    
    //This will find the duplicate- if same user has visit again on page or install same listing app then this function will find the record from db and notify.
    public static Boolean getIsDuplicate(Id listingId, Id listingAssetId, Id recordType,String userId) {
        Integer count = [SELECT count() from asb_ListingActivity__c 
                         WHERE asb_Listing__c =: listingId
                         And CogniAppEx__Visitor__c =:userId
                         AND ListingAsset__c =: listingAssetId 
                         AND RecordTypeId =: recordType limit 1];
                         /*AND CreatedDate = LAST_N_DAYS:180 
                         AND CreatedById =: UserInfo.getUserId() 
                         LIMIT 1 ];*/
        return (count != null && count > 0);
    }
    
    
    
}