@isTest
public class Test_barcodeActionController {
     @testSetup static void setup() {
        // Create common test accounts
        List<Account> testAccts = new List<Account>();
        for(Integer i=0;i<2;i++) {
            testAccts.add(new Account(Name = 'TestAcct'+i));
        }
        insert testAccts;        
    }
	static testMethod void validate() {
        test.startTest();
        	String objField = 'Name';
        	Account acct = [SELECT Id, Name FROM Account WHERE Name = 'TestAcct0' LIMIT 1];
        	id objID = acct.Id;
        	String result= barcodeActionController.getFields(objID, objField);
        	System.assertEquals('TestAcct0', result);
        	
        	String codeval = result; String technique = 'code128';
        	String actionResult = barcodeActionController.saveTheFile(objID, codeval, technique, objField);
        	System.assertEquals('Attachment Created Successfully', actionResult);
        test.stopTest();
    }
}