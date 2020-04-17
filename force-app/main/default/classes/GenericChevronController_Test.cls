/****
 * Class Name: GenericChevronController_Test 
 * Description: Test class for GenericChevronController
 * Developed by: Rajendra Singh Nagar (640829)
 * Author: Cognizant Technology Solutions
****/
@IsTest
public class GenericChevronController_Test {
    @testSetup static void setUpData(){
        //Create Case 
        Case caseRec = new Case();
        insert caseRec;
    }
    
    public testMethod static  void describeCase(){
        Test.startTest();
        //Fetch created Case
        Case caseRec = [select id from Case limit 1];
        //1st Describe Call
        GenericChevronController.getPicklistValues(caseRec.Id,'Status');
        Test.stopTest();
    }
}