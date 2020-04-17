@isTest
private class CTS_CustomDependedPicklistControllerTest {

    private static testMethod void unitTestOne(){
        Test.startTest();  
        String ot =  CTS_CustomDependedPicklistController.executer( '','StageName','StageName');
        CTS_CustomDependedPicklistController.OutPutWrapper mif = (CTS_CustomDependedPicklistController.OutPutWrapper)JSON.deserializeStrict(ot, CTS_CustomDependedPicklistController.OutPutWrapper.class);
        system.assertEquals(mif.isSuccess, false);
        CTS_CustomDependedPicklistController.executer( 'Opportunity','StageName1','StageName');
        CTS_CustomDependedPicklistController.executer( 'Opportunity','StageName','StageName1');
        CTS_CustomDependedPicklistController.executer( 'Opportunity','Name','StageName');
        CTS_CustomDependedPicklistController.executer( 'Opportunity1','StageName','StageName'); 
        CTS_CustomDependedPicklistController.executer( 'Opportunity','StageName','StageName');
        Test.stopTest();
    }
    
}