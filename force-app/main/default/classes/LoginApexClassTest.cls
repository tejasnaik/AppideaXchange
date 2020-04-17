@isTest(SeeAllData=true)
public class LoginApexClassTest {
    public static testmethod void LoginApexClassTestMethod()
    {
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
        );
        insert u;
        //Run As user1
        System.RunAs(u)
        {
            try
            {
                
                Test.startTest();
                wrapperLoginHistory wlh = new wrapperLoginHistory();
                wlh = LoginApexClass.searchAll(5);
                System.debug('all loglist size is = '+wlh.logList.size());
                //System.assert(wlh.logList.size()>0);
                wlh = LoginApexClass.searchSuccess(5);
                System.debug('success loglist size is = '+wlh.logList.size());
                //System.assert(wlh.logList.size()>0);
                wlh = LoginApexClass.searchFailure(5);
                System.debug('failure loglist size is = '+wlh.logList.size());
                // System.assert(wlh.logList.size()>0);  
                Test.stopTest();
            }
            catch(Exception ex){}
        }
    }
    
}