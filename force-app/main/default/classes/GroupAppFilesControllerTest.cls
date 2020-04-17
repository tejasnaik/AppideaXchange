@isTest(SeeAllData=false)
public class GroupAppFilesControllerTest {
    
    private static testMethod void testGetFile() {
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
        
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Test ContentVersion Body'); 
        content.VersionData = bodyBlob; 
        content.origin = 'H';
        insert content;
        
        List<ContentVersion> iconFiles = new List<ContentVersion>();
        iconFiles.add(content);
        System.assert(GroupAppFilesController.getFile(groupAppObj.Id, iconFiles)!=null);
        
    } 
}