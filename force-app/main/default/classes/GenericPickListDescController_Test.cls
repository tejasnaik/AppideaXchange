/****
 * Class Name: GenericPickListDescController_Test 
 * Description: Test Class for GenericPickListDescController
 * Developed by: Rajendra Singh Nagar (640829)
 * Author: Cognizant Technology Solutions
****/
@IsTest
public class GenericPickListDescController_Test {
    @testSetup static void setUpData(){
        //Create Case 
        Case caseRec = new Case();
        insert caseRec;
    }
    
    public testMethod static  void describePageController(){
        Test.startTest();
            //Fetch created Case
            Case cas = [select id from Case limit 1];
        
            //Controller Describe Call
            GenericPickListDescController dpc = new GenericPickListDescController();
        
            Test.setCurrentPageReference(new PageReference('Page.DRMI_PicklistDesc'));
            System.currentPageReference().getParameters().put('id',cas.Id);
            System.currentPageReference().getParameters().put('recordTypeName','');
            System.currentPageReference().getParameters().put('sobjectType','Case');
            System.currentPageReference().getParameters().put('picklistFieldName','status');
            GenericPickListDescController dpc2 = new GenericPickListDescController();
            
        Test.stopTest();
    }
    
    public testMethod static  void describePageControllerWithId(){
        Test.startTest();
            //Fetch created Case
            Case cas = [select id from Case limit 1];
        
            //Controller Describe Call
            GenericPickListDescController dpc = new GenericPickListDescController();
        
            Test.setCurrentPageReference(new PageReference('Page.DRMI_PicklistDesc'));
            System.currentPageReference().getParameters().put('id',cas.Id);
            System.currentPageReference().getParameters().put('recordTypeName','');
            System.currentPageReference().getParameters().put('picklistFieldName','status');
            GenericPickListDescController dpc2 = new GenericPickListDescController();
            
        Test.stopTest();
    }
}