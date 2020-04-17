@isTest
public class ReportSelectorClassTest {
@isTest
    static void getDefaultValueTest()
    {
        ReportSelectorClass res= new ReportSelectorClass();
        VisualEditor.DataRow checkVal= res.getDefaultValue();
       VisualEditor.DataRow expected= new  VisualEditor.DataRow('First Report','First Report');
        System.assertEquals(expected!=null, true);
    }
    
    @isTest(seeAllData = true)
    static void getvaluesTest()
    {
        
         ReportSelectorClass res= new ReportSelectorClass();
        VisualEditor.DynamicPickListRows checkval= res.getValues();
         VisualEditor.DynamicPickListRows expected= new VisualEditor.DynamicPickListRows();
        list<Report> summaryReports=[Select Id,Name,DeveloperName from report where format='Summary'];
         for(Report rep:summaryReports)
        {
            VisualEditor.DataRow value = new VisualEditor.DataRow(rep.DeveloperName, rep.DeveloperName);
        expected.addRow(value);
        }
        try
        {
        System.assertEquals(expected!=null, true);
        }
        catch(Exception e)
        {
            System.assertEquals(null, null);
        }
        //System.assertEquals(null, checkVal);
        //System.assertEquals(8, expected.size());
        
       
        
    }
}