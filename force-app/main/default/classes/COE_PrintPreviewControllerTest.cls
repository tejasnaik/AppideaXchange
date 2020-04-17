@isTest
public class COE_PrintPreviewControllerTest {
  
    public static testMethod void internalJSONPrintPreviewControllerTest(){
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        testAccount.billingStreet = '123 Test';
        insert testAccount;
        
        User userObj = [Select Id,Name FROM User WHERE Alias = 'sshar'];
        
        system.runAs(userObj){
            Test.StartTest();
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('InternalObjectJSON');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json');
            Test.setMock(HttpCalloutMock.class, mock);       
            
            Test.setCurrentPageReference(Page.PrintPreview); 
            System.currentPageReference().getParameters().put('recId', testAccount.Id);
            COE_PrintPreviewController  newObj = new COE_PrintPreviewController();
            Test.StopTest();
        }
    }
    
    public static testMethod void printPreviewControllerTest(){
        COE_PrintPreviewController.currencySymbol('ZWD');
        
        Contact testContact = new Contact();
        testContact.LastName = 'Test Contact';
        testContact.MailingStreet = '123 Test';
        insert testContact;
        COE_PrintPreviewController.getURL(testContact.Id);
    }
    
}