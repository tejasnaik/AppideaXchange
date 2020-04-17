@isTest
public class ReusableChartApexTest {
    
    @isTest
    static void chckReportId()
    {
        test.startTest();
        System.assertEquals(null, ReusableChartApex.getReportId('skmsAccountReportSummary'));
        //System.assertEquals(null, ReusableChartApex.getReportId('skmsAccountReportSummary'));
        test.stopTest();
    }

    @isTest
    static void checkBaseURL()
    {
        system.assertEquals('https://cts-app-ex-dev-ed.my.salesforce.com', ReusableChartApex.getBaseURL());
    }
    
    
   @isTest(seeAllData = true)
    static void testCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
     
        String result=ReusableChartApex.GetReportData('skmsOpportunitySummary');
        System.debug('test ep:- '+result);
         String result2=ReusableChartApex.GetReportData('nonExistingReport');
        String expectedResult='{\'attributes\':{\'describeUrl\':\'/services/data/v29.0/analytics/reports/00O7F000008BYINUA4/describe\',\'instancesUrl\':\'/services/data/v29.0/analytics/reports/00O7F000008BYINUA4/instances\',\'reportId\':\'00O7F000008BYINUA4\',\'reportName\':\'testSummaryReportOrgs\',\'type\':\'Report\'},\'allData\':true,\'factMap\':{\'T!T\':{\'aggregates\':[{\'label\':\'6\',\'value\':6}],\'rows\':[{\'dataCells\':[{\'label\':\'Alekh new\',\'value\':\'a007F00000I9mzUQAR\'},{\'label\':\'75%\',\'value\':75}]},{\'dataCells\':[{\'label\':\'navneet org\',\'value\':\'a007F00000I93SjQAJ\'},{\'label\':\'17%\',\'value\':17}]},{\'dataCells\':[{\'label\':\'Production\',\'value\':\'a007F00000DuhDTQAZ\'},{\'label\':\'-\',\'value\':null}]},{\'dataCells\':[{\'label\':\'Sandbox\',\'value\':\'a007F00000DuhDJQAZ\'},{\'label\':\'-\',\'value\':null}]},{\'dataCells\':[{\'label\':\'saurabh org\',\'value\':\'a007F00000I9mz0QAB\'},{\'label\':\'-\',\'value\':null}]},{\'dataCells\':[{\'label\':\'shilpa org\',\'value\':\'a007F00000I94KcQAJ\'},{\'label\':\'78%\',\'value\':78}]}]}},\'groupingsAcross\':{\'groupings\':[]},\'groupingsDown\':{\'groupings\':[]},\'hasDetailRows\':true,\'reportExtendedMetadata\':{\'aggregateColumnInfo\':{\'RowCount\':{\'acrossGroupingContext\':null,\'dataType\':\'int\',\'downGroupingContext\':null,\'label\':\'Record Count\'}},\'detailColumnInfo\':{\'CUST_NAME\':{\'dataType\':\'string\',\'label\':\'Salesforce org: Salesforce org Name\'},\'codecover__Salesforce_org__c.codecover__Total_Coverage__c\':{\'dataType\':\'percent\',\'label\':\'Total Coverage\'}},\'groupingColumnInfo\':{}},\'reportMetadata\':{\'aggregates\':[\'RowCount\'],\'currency\':null,\'detailColumns\':[\'CUST_NAME\',\'codecover__Salesforce_org__c.codecover__Total_Coverage__c\'],\'developerName\':\'testSummaryReportOrgs\',\'groupingsAcross\':[],\'groupingsDown\':[],\'id\':\'00O7F000008BYINUA4\',\'name\':\'testSummaryReportOrgs\',\'reportBooleanFilter\':null,\'reportFilters\':[],\'reportFormat\':\'TABULAR\',\'reportType\':{\'label\':\'Salesforce orgs\',\'type\':\'CustomEntity$codecover__Salesforce_org__c\'}}}';
             test.startTest();
        System.assertEquals(null,result); 
        
        test.stopTest();
    }
    
 @isTest(seeAllData = true)
    public static void GetSessionIdTest(){
        String sessionId = ReusableChartApex.getSessionIdFromVFPage();
        system.debug('in test ses id:-  '+sessionId);
        test.startTest();
        system.assertEquals(sessionId != null, true);
          
       test.stopTest();
    }
}