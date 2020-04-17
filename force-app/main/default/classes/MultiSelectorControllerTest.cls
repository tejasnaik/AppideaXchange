@isTEst
public class MultiSelectorControllerTest {
	
    private static testmethod void unitTest()
    {
        MultiSelectorController.onInit(null,'Opportunity','StageName');
        Case opp = new Case(Subject='TESt',Status='Closed');
        insert opp;
        MultiSelectorController.onInit(opp.id,'Case','Status');
        List<string> s= new List<String>();
        s.add('Open');
        MultiSelectorController.savePickList(opp.id,'Status' , 'Case',s);
        
    }
}