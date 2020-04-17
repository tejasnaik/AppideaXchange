@isTest
public class LookupSObjectController_Test {
    static testMethod void searchAccountForLookup(){
        Account testAccount = new Account();
        testAccount.Name='Test Account';
        insert testAccount;
        Id [] fixedSearchResults = new Id[]{testAccount.Id};
        Test.setFixedSearchResults(fixedSearchResults);
      	String [] fields=new String[]{'Name','Id'};
        LookupSObjectController.lookup('Test','Account',fields,'NAME');
    }
}