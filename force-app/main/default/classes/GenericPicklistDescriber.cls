/****
 * Class Name: GenericPicklistDescriber 
 * Description: Fetch picklist values as per parameters passed
 * Developed by: Rajendra Singh Nagar (640829)
 * Author: Cognizant Technology Solutions
****/
public class GenericPicklistDescriber {
    static final Pattern OPTION_PATTERN = Pattern.compile('<option.+?>(.+?)</option>'); 
    
    /**
    Desribe a picklist field for an sobject id. RecordType is automatically picked
    based on the record's RecordTypeId field value.
    example usage :
    List<String> options = PicklistDescriber.describe(accountId, 'Industry');
    */
    public static List<String> describe(Id sobjectId, String pickListFieldAPIName) {
        return parseOptions(
            new Map<String, String> {
                'id' => sobjectId,
                    'pickListFieldName'=> pickListFieldAPIName
                    }
        );
    }
    
    /**
    Describe a picklist field for a SobjectType, its given record type developer name and the picklist field
    example usage : 
    List<String> options = PicklistDescriber.describe('Account', 'Record_Type_1', 'Industry'));
    */
    public static List<String> describe(String sobjectType, String recordTypeName, String pickListFieldAPIName) {
        return parseOptions(
            new Map<String, String> {
                'sobjectType' => sobjectType,
                    'recordTypeName' => recordTypeName,
                    'pickListFieldName'=> pickListFieldAPIName
                    }
        );
    }
    
    /**
    Describe a picklist field for a SobjectType, its given record type ID and the picklist field
    example usage : 
    Id recType1Id = [Select Id from RecordType Where SobjectType = 'Account' 
    AND DeveloperName like 'Record_Type_2'].Id;
    System.assertEquals(REC_TYPE_1_OPTIONS, PicklistDescriber.describe('Account', recType2Id, 'Industry'));
    */
    public static List<String> describe(String sobjectType, Id recordTypeId, String pickListFieldAPIName) {
        return parseOptions(
            new Map<String, String> {
                'sobjectType' => sobjectType,
                    'recordTypeId' => recordTypeId,
                    'pickListFieldName'=> pickListFieldAPIName
                    }
        );
    }
    
    /*
    Internal method to parse the OPTIONS
    */
    static List<String> parseOptions(Map<String, String> params) {
        Pagereference pr = Page.GenericPicklistDesc;
        // to handle development mode, if ON
        pr.getParameters().put('core.apexpages.devmode.url', '1');
        
        for (String key : params.keySet()) {
            pr.getParameters().put(key, params.get(key));   
        }
        
        String xmlContent;
        // In Test method - "Methods defined as TestMethod do not support getContent call"
        if(!Test.isRunningTest()){
            xmlContent = pr.getContent().toString();
        }else{
            xmlContent='';
        }
        
        Matcher mchr = OPTION_PATTERN.matcher(xmlContent);
        List<String> options = new List<String>();
        while(mchr.find()) {
            options.add(mchr.group(1));
        } 
        // remove the --None-- element
        if (!options.isEmpty() && options[0].toLowerCase().contains('none')){
           options.remove(0); 
        } 
        return options;
    }
}