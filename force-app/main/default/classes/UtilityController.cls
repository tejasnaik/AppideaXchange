/****************************************************************************************************************************
@Author Cognizant
@name UtilityController
@Description Controller is used to pass the links to home page
@Version 40.0 
*/
public class UtilityController {

    /************************************************************************************************************************
    * @Description: Methods is the Aura enabled methods which retrun the homepage links to component
    * Return Type:List<Home_Page_Links__c>
    */
    @AuraEnabled
    public static List<Home_Page_Links__c> getLinks(){
        return [select id, name,URL__c, SortOrder__c from Home_Page_Links__c order by SortOrder__c asc];
    }
}