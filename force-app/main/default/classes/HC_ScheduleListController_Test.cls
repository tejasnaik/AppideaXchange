/****
* Test Class for Hc_PatientProfileController Class
* Developed by: Rajendra Singh Nagar (640829)
* Author: Cognizant Technology Solutions
****/
@isTest
private class HC_ScheduleListController_Test {
    private static testmethod void getPatientDetails(){
        Test.startTest();
        //Test getPatientDetails
        HC_ScheduleListController.getScheduleList(new list<String>{'Id','Subject'},'Contact',1);
        Test.stopTest();
    }
}