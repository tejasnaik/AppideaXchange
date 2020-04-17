/*
 *  Written By Ashlekh Gera
 *  Des - It is a controller of multipicklist component.
 *  
 */ 
public class AKCustomPicklistFieldController {
    
    
    /*
     *  Method executeInit()
     *  Parameter 1) objectName - API name of Object.
     * 			  2) fieldName  - API name of field (Field Should be Multi Picklist or Picklist )
     *  Return - Wrapper Class.
     */ 
    @AuraEnabled
    public static String executeInit(String objectName,String fieldName,String extraValue){
       
        OutputWrapper oWrapper = new OutputWrapper();
        if(objectName !=null && objectName.trim() !='' && fieldName !=null && fieldName.trim() !=''){
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
            if(gd.containsKey(objectName)){
                Schema.DescribeSObjectResult r =  gd.get(objectName).getDescribe();
                Map<String, Schema.SObjectField> FsMap = r.fields.getMap();
                if(FsMap.containsKey(fieldName))
                {
                    Schema.DescribeFieldResult field =  FsMap.get(fieldName).getDescribe();
                    oWrapper.fieldType = String.valueOf(field.getType());
                    oWrapper.fieldType = field.getType() == Schema.DisplayType.MULTIPICKLIST?'MULTIPICKLIST':
                    						(field.getType() == Schema.DisplayType.PICKLIST?'PICKLIST':oWrapper.fieldType);
                    
                    oWrapper.ismuliPickList = (oWrapper.fieldType.contains('MULTIPICKLIST'));
                    oWrapper.fieldLabel = field.getLabel();
                    if(oWrapper.fieldType.contains('PICKLIST') ){
                        List<Schema.PicklistEntry> picklistEntries = field.getPicklistValues();  
                        oWrapper.picklistOptions = new Map<String,String>();
                        if(picklistEntries != null)
                        for (Schema.PicklistEntry ple : picklistEntries){ 
                            if(ple.isActive() && ple.getValue() !=null && ple.getLabel() !=null && ple.getLabel() !='')
                                oWrapper.picklistOptions.put(ple.getValue(), ple.getLabel());
                        }
                        oWrapper.message = 'SUCCESS';
                    }else{
                         oWrapper.message = 'Provided field is not a picklist type.';
                    }
                    
                }else{
                    oWrapper.message = 'Field Not exist.';
                }
                
            }else{
                oWrapper.message = 'Object Not exist.';
            }
            
        }else{
            oWrapper.message = 'Please provide proper object and field API Name';
        }
        return JSON.serialize(oWrapper);
    }
    
    public class OutputWrapper
    {
        public boolean ismuliPickList;
        public string  fieldType;
        public Map<String,String> picklistOptions;
        public String fieldLabel;
        public String message;
        public OutputWrapper(){}
    }
}