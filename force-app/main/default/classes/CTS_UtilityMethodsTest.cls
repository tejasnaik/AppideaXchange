@isTest
public class CTS_UtilityMethodsTest {

    private testMethod static void unitTest1(){
         List<string> pickListValues =   CTS_UtilityMethods.findObjectWithfield('Name','CogniAppEx__Availability__c','CogniAppEx__Expected_Role__c','Picklist'); 
         system.assertNotEquals(null, pickListValues);
        
    } 
}