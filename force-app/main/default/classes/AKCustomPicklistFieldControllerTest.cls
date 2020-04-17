/*
 *  Written By Ashlekh Gera
 *  Des - TEST CLASS.
 */ 
@isTest
private class AKCustomPicklistFieldControllerTest {
	
    private static testMethod void unitTestFirst(){
        //Test.startTest();
        String outpt = AKCustomPicklistFieldController.executeInit('Opportunity','StageName','');
        AKCustomPicklistFieldController.OutputWrapper ot =(AKCustomPicklistFieldController.OutputWrapper)JSON.deserialize(outpt, AKCustomPicklistFieldController.OutputWrapper.class);
        system.assertEquals('SUCCESS', ot.message);
        //Test.stopTest();
    } 
    
      private static testMethod void unitTestSecond(){
        //Test.startTest();
        String outpt = AKCustomPicklistFieldController.executeInit('Opportunity','StageName1','');
        AKCustomPicklistFieldController.OutputWrapper ot =(AKCustomPicklistFieldController.OutputWrapper)JSON.deserialize(outpt, AKCustomPicklistFieldController.OutputWrapper.class);
        system.assertNotEquals('SUCCESS', ot.message);
        //Test.stopTest();
    } 
    
     private static testMethod void unitTestThird(){
        //Test.startTest();
        String outpt = AKCustomPicklistFieldController.executeInit('Opportunity1','StageName1','');
        AKCustomPicklistFieldController.executeInit('','',''); 
        AKCustomPicklistFieldController.executeInit('Opportunity','Name','');  
        AKCustomPicklistFieldController.OutputWrapper ot =(AKCustomPicklistFieldController.OutputWrapper)JSON.deserialize(outpt, AKCustomPicklistFieldController.OutputWrapper.class);
        system.assertNotEquals('SUCCESS', ot.message);
        //Test.stopTest();
    } 
}