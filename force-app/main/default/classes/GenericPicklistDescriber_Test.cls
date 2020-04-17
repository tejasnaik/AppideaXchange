/****
 * Class Name: GenericPicklistDescriber_Test 
 * Description: Test Class for GenericPicklistDescriber
 * Developed by: Rajendra Singh Nagar (640829)
 * Author: Cognizant Technology Solutions
****/
@IsTest
public class GenericPicklistDescriber_Test {
    
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
            GenericPicklistDescriber.describe(caseRec.Id,'status');
            
        	list<RecordType> recordTypeList = [select Name from recordtype where sObjectType='Case' limit 1];
            String recordTypeName = recordTypeList.isEmpty()?'':recordTypeList[0].Name;
        	String recordTypeId = recordTypeList.isEmpty()?'':recordTypeList[0].Id;
        	//2nd Describe Call
            GenericPicklistDescriber.describe('Case',recordTypeName,'status');
        
        
            //3rd Describe Call
            GenericPicklistDescriber.describe('Case',recordTypeId,'status');
        Test.stopTest();
    }
}