/****
* Test Class for Hc_PatientProfileController Class
* Developed by: Rajendra Singh Nagar (640829)
* Author: Cognizant Technology Solutions
****/
@isTest
private class TaskTileController_Test {
    @testSetup
    static void dataSetup() {
        //Create Account
        Account parentAccount = new Account(name='Patient Account');
        insert parentAccount;
        
        //Create Contact
        Contact patientContact = new contact(accountId=parentAccount.Id,lastName='Patient Contact');        
        patientContact.Birthdate=Date.today();
        patientContact.Customer_Pic__c ='<img alt="User-added image" src="https://health-cloud-dev-ed--c.na35.content.force.com/servlet/rtaImage?eid=0034100000rHi9z&amp;feoid=00N4100000XYybS&amp;refid=0EM41000000OJR0"></img>';
        insert patientContact;
        
        //Create Case
        Case patientCase = new case(accountId=parentAccount.Id);
        insert patientCase;
        
        //Create tasks
        list<Task> tl = new list<Task>();
        for(integer i=0;i<5;i++){
            tl.add(new task(Subject='task'+i,status='Not Started',Priority='Normal',activityDate=Date.today(),whoId=patientContact.Id));
        }
        insert tl;
    }
    private static testmethod void getPatientDetails(){
        delete [select id,Customer_Pic__c from contact where lastName!='Patient Contact' limit 1];//delete unwanted contacts (if any)
        Contact patientContact = [select id,Customer_Pic__c from contact limit 1];
        //Create Partner Portal user
        Id profileId = [SELECT Id FROM Profile WHERE Name LIKE '%Portal User%' Limit 1].Id;
        User portalUser = new User(Username = System.now().millisecond() + 'test2@test.com',
                                   Alias = 'batman',
                                   ProfileId=profileId,
                                   Email='bruce.wayne@wayneenterprises.com',
                                   EmailEncodingKey='UTF-8',
                                   Firstname='Bruce',
                                   Lastname='Wayne',
                                   LanguageLocaleKey='en_US',
                                   LocaleSidKey='en_US',
                                   TimeZoneSidKey='America/Chicago',
                                   contactId=patientContact.Id
                                  );
        Database.insert(portalUser);
        Test.startTest();
        //Test getPatientDetails
        
        list<String> tileFields = new list<String>{'Name','Birthdate'};
            list<String> tileFieldsMap = new list<String>{'Name:Name','Birthdate:BD'};
                TaskTileController.getTileDetails(tileFields,'Contact','Customer_Pic__c','Today',tileFieldsMap);
        
        TaskTileController.getTileDetails(tileFields,'Contact','Customer_Pic__c','ThisWeek',tileFieldsMap);
        TaskTileController.getTileDetails(tileFields,'Contact','Customer_Pic__c','NextWeek',tileFieldsMap);                       
        TaskTileController.getTileDetails(tileFields,'Contact','Customer_Pic__c','overdue',tileFieldsMap);
        //Update patientContact 
        System.debug('***con'+[select id,Name, Customer_Pic__c from Contact]);
        patientContact.Customer_Pic__c='';
        update patientContact;
        TaskTileController.getTileDetails(tileFields,'Contact','Customer_Pic__c','Tomorrow',tileFieldsMap);  
        TaskTileController.getTileDetails(tileFields,'Contact','Customer_Pic__c','Today',tileFieldsMap);
        
        //Call getUserContext
        TaskTileController.getUserContext();
        Test.stopTest();
    }
}