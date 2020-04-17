/* *************************************************
Name         : SOQLHelper
Description  : Handle all SOQL & SOSL queries
Auther       : Saurabh Tripathi 
Created Date : 21-03-2018
************************************************** */
public class SOQLHelper{

    public static Id getReportId(String strName){
         try{
             List<Report> lstReports= [select id,name from Report where DeveloperName =: strName limit 1]; 
             if(!lstReports.isEmpty())
                 return lstReports[0].Id;
             return null;
         }Catch(Exception e){
             return null;
         }
    }
    
       
    

}