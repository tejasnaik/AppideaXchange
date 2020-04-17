/*
Written By : Ashlekh Gera
Description : This is a controller of custom serach component to proivde search functionality.
*/
public without sharing class CustomSearchController {
    
    
    /*
*   Method Name -  searchRecord
*   Parameters    1.  searchField --> String -- Keyword entered by enduser to search.
*                 2.  queryFast -->   String -- Query which need to execute.(hold the objects)
*                 3.  Configuration --> String (JSON) -- Contains component configuratin data. 
*   returnType - List<sObject> - return search records.
*   Desctiption - When user enter any keyword in search box of component, component call this function to find the result.  
*/
    @AuraEnabled
    public static List<sObject> searchRecord(String searchField,String queryFast, String Configuration )
    {
        String searchquery='FIND\'*'+searchField+'*\'IN ALL FIELDS RETURNING '+ queryFast; 
        List<Sobject> returnList =new List<Sobject>();
        if(queryFast !=null && queryFast !='' && queryFast.trim() !='' )
        {
            List<List<SObject>> searchList =search.query(searchquery);
            for(List<Sobject> inst : searchList)
                returnList.addAll(inst);
            
        }
        return returnList;
    }
    
    /*
*    Method Name -- DoIntSetup().
*    Parameter   -- Configuration - String - Contains component configuration data in JSON form. 
*    Return Type - String - Return the Query.
*    Description -- When component get loaded this function get call and create sutiable query to find the result.
*/
    
    @AuraEnabled
    public static String DoIntSetup(String configuration)
    {
        ConfigurationWrapper config = (ConfigurationWrapper)JSON.deserialize(Configuration, CustomSearchController.ConfigurationWrapper.Class);
        Map<String,String> returnMap = new Map<String,String>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();   
        String KAVObject = '__kav';
        String query = ''; 
        Set<String> metadataObjectSet;
        for(String sObj : gd.keySet())
        {
            Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();
            if(!r.isSearchable()) continue;
            string objName =r.getName();
            
            if((config.inUserContext && !r.isAccessible() )|| objName.endsWithIgnoreCase(KAVObject)  )
                continue;
            
            Boolean isSkip = false;
            
            if(!config.OpenSearchMetaData ){
                metadataObjectSet = metadataObjectSet ==null?getMetaObjectSet():metadataObjectSet;
                if(metadataObjectSet.contains(objName))
                    continue;
            }
            
            if(!config.OpenObjectSchema){
                metadataObjectSet = metadataObjectSet ==null?getMetaObjectSet():metadataObjectSet;
                if(!metadataObjectSet.contains(objName))
                    continue;         
            }
            
            
            if(r.getKeyPrefix() !=null && r.getKeyPrefix() !='')
                returnMap.put(r.getKeyPrefix(),r.getLabel().toLowercase());
            
            Map<String, Schema.SObjectField> FsMap = r.fields.getMap();
            
            String CreateDate = '';
            String uniquefieldName = '';
            
            if(FsMap.containsKey('createDate') || FsMap.containsKey('CreateDate'))
                CreateDate = ',CreateDate';   
            
            
            if(FsMap.containsKey('Name') || FsMap.containsKey('name'))
                uniquefieldName = 'Name';   
            else if(FsMap.containsKey('LastName') || FsMap.containsKey('lastname'))
                uniquefieldName = 'LastName';
            else if(FsMap.containsKey('Title') || FsMap.containsKey('title'))
                uniquefieldName = 'Title';
            else if(FsMap.containsKey('Subject') || FsMap.containsKey('subject'))
                uniquefieldName = 'Subject';
            else if(FsMap.containsKey('DataCategoryName') || FsMap.containsKey('datacategoryname'))
                uniquefieldName = 'DataCategoryName';
            if(uniquefieldName !=''){
                query +=query!=''? ','+r.getName() +'(id,':r.getName()+'(id,';
                query +=uniquefieldName+ CreateDate + ')';
            }
        }
        
        string rm ='';
        if(returnMap != null)
            rm = JSON.serialize(returnMap);
        return JSON.serialize(new StaticDataWrapper(rm,query));
    }
    
    
    /*
*    Method - getPrefixMap
*    Parameter - String - Passing Configuration data in the form of JSON.
*    Return type - string 
*/
    
    @AuraEnabled    
    public static String getPrefixMap(String Configuration){
        return doIntSetup(Configuration);
    }
    
    public class ConfigurationWrapper{
        public Boolean inUserContext;
        public Boolean OpenSearchMetaData; 
        public Boolean OpenObjectSchema;
        public ConfigurationWrapper(Boolean inUserContext,Boolean OpenSearchMetaData,Boolean OpenObjectSchema){
            this.inUserContext = inUserContext;
            this.OpenSearchMetaData = OpenSearchMetaData;
            this.OpenObjectSchema = OpenObjectSchema;
        }
    }
    
    //Wrapper class to hold the data.
    public class StaticDataWrapper{
        @AuraEnabled
        public String keyPrefixMap;
        @AuraEnabled
        public String fastQuery;
        public StaticDataWrapper(String keyPrefixMap,String fastQuery){
            this.keyPrefixMap = keyPrefixMap;
            this.fastQuery = fastQuery;
        }
    }
    
    //This is set we have created to assume metadata category.
    public static  Set<String> getMetaObjectSet()
    {
        Set<String> d = new Set<String>();
        d.add('PermissionSet');
        d.add('CollaborationGroup');
        d.add('Group');
        d.add('ApexPage');
        d.add('Profile');
        d.add('ApexClass');
        d.add('ApexTrigger');
        d.add('ApexComponent');
        d.add('StaticResource');
        d.add('ProcessDefinition');
        d.add('UserRole');
        d.add('AssignmentRule');
        return d;
    }
}