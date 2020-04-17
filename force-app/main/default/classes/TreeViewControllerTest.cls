@isTest 
public class TreeViewControllerTest{
    
    static testMethod void validateTreeViewList() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standardTreeuser@testorg.com', 
            			  EmailEncodingKey='UTF-8', LastName='TreeTester', LanguageLocaleKey='en_US', 
            		      LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standardTreeuser@testorg.com');
        
        system.runAs(u){
            Account a = new Account();
            a.Name = 'testName';
            insert a;
            
            Contact c = new Contact();
            c.lastName = 'testLastName';
            c.AccountId = a.id;
            insert c;
            
            test.startTest();
            TreeViewController.getData('Account', 'Contacts');
            test.stopTest();
        }
        
    }
}