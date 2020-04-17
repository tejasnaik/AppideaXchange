@isTest
private class CircularProgressControllerTest {

    public static testmethod void unitTest()
    {
        Opportunity opportunity = new Opportunity(Name = 'Test Opportunity', StageName = 'Negotiating', CloseDate = System.today(), Amount = 30000);
        insert opportunity;
        
        Test.startTest();
        CircularProgressController.computePercentage('Opportunity', opportunity.Id, 'Amount', 'ExpectedRevenue');
        Test.stopTest();
    }
}