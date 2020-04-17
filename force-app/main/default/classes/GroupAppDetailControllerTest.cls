@isTest(SeeAllData=false)
public class GroupAppDetailControllerTest {
    
    private static testMethod void testAppDetail() {
        CollaborationGroup testGroup = new CollaborationGroup(
            Name = 'Your Group Name Edit Object Manager',
            CollaborationType = 'Public',
            CanHaveGuests = false,
            IsArchived = false,
            IsAutoArchiveDisabled = true
        );
        insert testGroup;
        
        Profile profileObj = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User testUser = new User(Alias = 'Sumit',Country = 'India',
                                 Email = 'sumit@test.com',EmailEncodingKey = 'UTF-8', 
                                 LastName = 'Testing', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US',
                                 ProfileId = profileObj.Id,TimeZoneSidKey='America/Los_Angeles', 
                                 UserName='sumit@test.com');        
        insert testUser;
        
        Group_Application__c groupAppObj = new Group_Application__c();
        groupAppObj.Application_Title__c = 'TestApp';
        groupAppObj.Description__c = 'TestDesc';
        groupAppObj.Group_Name__c = 'Your Group Name Edit Object Manager';
        groupAppObj.Active__c = true;
        groupAppObj.OwnerId = testUser.Id;
        insert groupAppObj;
        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        ); 
        insert contentVersion;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.ContentDocumentId = documents[0].Id;
        contentlink.LinkedEntityId = groupAppObj.id;
        contentlink.shareType = 'V';
        insert contentlink; 
        
        System.runAs(testUser){
            System.assert(GroupAppDetailController.appDetail(testGroup.Id)!=null);
        }
        
    }
}