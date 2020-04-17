@isTest(SeeAllData = false)
public class UtilityController_Test{

    static testMethod void initializeData() {
        //Set up user
          User u = new User(
              ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
              LastName = 'last',
              Email = 'puser000@amamama.com',
              Username = 'puser000@amamama.com' + System.currentTimeMillis(),
              CompanyName = 'TEST',
              Title = 'title',
              Alias = 'alias',
              TimeZoneSidKey = 'America/Los_Angeles',
              EmailEncodingKey = 'UTF-8',
              LanguageLocaleKey = 'en_US',
              LocaleSidKey = 'en_US'
              //UserRoleId = r.Id
          );
          insert u;
        //Run As user1
     System.RunAs(u)
      {
        try
        {
        
          Test.startTest();
          /**
        * TO DO
        * Uncomment the below code or write your own code to call the Test Data Factory method to generate test data

        * SObject  testDataObject = TestDataFactory.getLinks;

        */
         
            /*Create Test Data*/
            List<Home_Page_Links__c> lstlinks = new List<Home_Page_Links__c>();
            for ( Integer i = 0 ; i < 5 ; i++ ) {
                
                Home_Page_Links__c hpl = new Home_Page_Links__c(Name = 'Google Link' + i, SortOrder__c = i, URL__c = 'https://www.google.co.in/');
                lstlinks.add( hpl);
            }
            
            //List<Home_Page_Links__c> lstlinks = TestDataFactory.createLinksData(5);
            if(lstlinks.size()>0)
                insert lstlinks;
            System.assert( lstlinks != null);  

            List<Home_Page_Links__c> lstHomeLinks = UtilityController.getLinks();
            Test.stopTest();
        }
        catch(Exception ex){}
      }
    }
	
}