@isTest
public class GoogleMapTest {
static testMethod void searchAccountForLookup(){
    
        Account testAccount = new Account();
        testAccount.Name='Test Account';
    	testAccount.BillingCity = 'Jaipur';
     	testAccount.BillingStreet = 'okay plus';
    	testAccount.BillingState = 'Raj';
    	testAccount.BillingCountry = 'India';
    	testAccount.BillingPostalCode = '302020';
        insert testAccount;
        Id [] fixedSearchResults = new Id[]{testAccount.Id};
        Test.setFixedSearchResults(fixedSearchResults);
        String [] fields=new String[]{'Name','Id'};
        GoogleMap.getAccounts('JP AND *RAJ',fields,'Account','NAME','100','km');
        GoogleMap.getContacts(testAccount.Id);
    	GoogleMap.getAccounts('Test',fields,'Account','NAME','choose one...','choose one...');
    
    	//Calling controller method
    	Test.setMock(HttpCalloutMock.class, new MockHttpGoogleResponseGenerator());
    	GeocodeExtractor.findGeocodes();
    }
}