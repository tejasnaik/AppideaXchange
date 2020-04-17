/****
 * Test Class for Hc_PatientProfileController Class
 * Developed by: Rajendra Singh Nagar (640829)
 * Author: Cognizant Technology Solutions
****/
@isTest
private class GenericPatientProfileController_Test {
    private static testmethod void getContactDetails(){
        //Create Account
        Account parentAccount = new Account(name='Account');
        insert parentAccount;
        
        //Create Contact
        Contact patientContact = new contact(accountId=parentAccount.Id,lastName='Contact');
        insert patientContact;
        
        //Create Case
        Case patientCase = new case(accountId=parentAccount.Id);
        insert patientCase;
        
        Test.startTest();
            //Test by passing account Id
            GenericPatientProfileController.getPatientDetails('id,name,Profile_Card_Image__c',String.valueOf(parentAccount.Id));
        
            //Test by passing contact Id    
            GenericPatientProfileController.getPatientDetails('id,name,Profile_Card_Image__c',String.valueOf(patientContact.Id));
            //Update contact 
            patientContact.Profile_Card_Image__c ='<img alt="User-added image" src="https://health-cloud-dev-ed--c.na35.content.force.com/servlet/rtaImage?eid=0034100000rHi9z&amp;feoid=00N4100000XYybS&amp;refid=0EM41000000OJR0"></img>';
            update patientContact;
            GenericPatientProfileController.getPatientDetails('id,name,Profile_Card_Image__c',String.valueOf(patientContact.Id));
        Test.stopTest();
    }
}