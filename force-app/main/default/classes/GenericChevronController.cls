/****
 * Class Name: GenericChevronController 
 * Description: Apex Class to get picklist values as per record type.
 * Developed by: Rajendra Singh Nagar (640829)
 * Author: Cognizant Technology Solutions
****/
public class GenericChevronController {
    @AuraEnabled
    public static List<String> getPicklistValues(String recordId,String fieldName){ 
        /** This won't work, as we have to fetch picklist values as per record type
        Schema.sObjectType sobject_type = Id.valueOf(recordId).getSObjectType(); //Get the sobject type for the record id passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        //grab the list of picklist values for the passed field on the sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldName).getDescribe().getPickListValues(); 
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            lstPickvals.add(a.getValue());//add the value  to our final list
        }
        */
        return GenericPicklistDescriber.describe(recordId, fieldName);
    }
}