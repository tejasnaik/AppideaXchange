public class GroupAppDetailWrapper {
    @AuraEnabled
    public Group_Application__c groupAppObj { get; set; }
    @AuraEnabled
    public List<ContentVersion> filesList { get; set; }
    
    public GroupAppDetailWrapper(Group_Application__c groupAppObj, List<ContentVersion> filesList){
        this.groupAppObj = groupAppObj;
        this.filesList = filesList;
    }
}