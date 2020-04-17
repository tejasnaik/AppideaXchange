@isTest
private class FileUploadControllerTest {

    @testSetup static void setupTestData() {
        Idea__c ideaNew = new Idea__c();
        ideaNew.User__c = Userinfo.getUserId();
        ideaNew.Title__c = 'Test Idea Title';
        ideaNew.Body__c = 'Test Idea Body';
        ideaNew.Category__c = 'Solution';
        insert ideaNew;
    }
    
    @isTest static void fileUploadControllerTest() {
        List<Idea__c> ideaList = [SELECT Id, User__c, Title__c, Body__c, Category__c FROM Idea__c WHERE Title__c= 'Test Idea Title'];
        Id fileId = FileUploadController.saveTheChunk(ideaList[0].Id, 'TestAttachment', 'Test Attachment Body', 'text/plain', null);
        System.assertNotEquals(null, fileId);
        
        fileId = FileUploadController.saveTheChunk(ideaList[0].Id, 'TestAttachment', 'Test Attachment Body', 'text/plain', fileId);
        System.assertNotEquals(null, fileId);
    }
}