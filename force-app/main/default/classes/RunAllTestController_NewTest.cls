@isTest
public class RunAllTestController_NewTest{
    
    static testMethod void enqueueTests(){
        Test.startTest();
        RunAllTestController_New.enqueueTests();
        Test.stopTest();
    }
    
    static testMethod void checkClassStatusTests(){
        Test.startTest();
        List<String> jobList = new List<String>();
        jobList.add('7077F00801oPn1kQAC');
        jobList.add('7077F00901oPn1kQAC');
        RunAllTestController_New.checkClassStatus(jobList);
        Test.stopTest();
    }
    
    static testMethod void checkMethodStatusTests(){
        Test.startTest();
        List<String> jobList = new List<String>();
        jobList.add('7077F00801oPn1kQAC');
        jobList.add('7077F00901oPn1kQAC');
        RunAllTestController_New.checkMethodStatus(jobList);
        Test.stopTest();
    }
    
}