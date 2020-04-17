public class GroupAppDetailController {
    
    //To fetch attachments using group record ID
    @AuraEnabled
    public static List<GroupAppDetailWrapper> appDetail(String recordID){
        
        Set<Id> groupAppId = new Set<Id>();
        Set<Id> fileId = new Set<Id>();
        Map<Group_Application__c , List<Id>> files = new Map<Group_Application__c , List<Id>>();
        CollaborationGroup CGObj = new CollaborationGroup();
        
        CGObj = [SELECT Name, Id FROM CollaborationGroup WHERE CollaborationType='Public' AND Id=:recordID LIMIT 1];
        String groupName = String.valueOf(CGObj.Name);
        List<Group_Application__c> groupAppObj = [SELECT Application_Title__c, Description__c, Id FROM Group_Application__c WHERE Group_Name__c =: groupName AND Active__c = true];
        
        for(Group_Application__c gaobj : [SELECT Id FROM Group_Application__c WHERE Group_Name__c =: groupName AND Active__c = true]){
            groupAppId.add(gaobj.Id);
        }
        
        List<ContentDocumentLink> contentDocLinkList = new List<ContentDocumentLink>();
        contentDocLinkList = [SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN: groupAppId];
        Map<String, String> contentGroupLinkMap = new Map<String, String>();
        for(ContentDocumentLink cdl: contentDocLinkList){
            contentGroupLinkMap.put(cdl.ContentDocumentId, cdl.LinkedEntityId);
        }
        
        Map<String, List<ContentVersion>> contentVerMap = new Map<String, List<ContentVersion>>();
        List<ContentVersion> contentVerList = [SELECT Id,Title,FileType,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN: contentGroupLinkMap.keySet() AND IsLatest = true];
        for(ContentVersion cv: contentVerList){
            String appId = contentGroupLinkMap.get(cv.ContentDocumentId);                
            if(contentVerMap.containsKey(appId)){
                List<ContentVersion> temp = contentVerMap.get(appId);
                temp.add(cv);
                contentVerMap.put(appId, temp);
            }
            else{
                List<ContentVersion> temp = new List<ContentVersion>();
                temp.add(cv);
                contentVerMap.put(appId, temp);                
            }
        }
        
        List<GroupAppDetailWrapper> groupWrapper = new List<GroupAppDetailWrapper>();
        for(Group_Application__c ga: groupAppObj){
            GroupAppDetailWrapper groupWrapperObj = new GroupAppDetailWrapper(ga,contentVerMap.get(ga.Id));
            groupWrapper.add(groupWrapperObj);
        }
        
        return groupWrapper;
        
    }
}