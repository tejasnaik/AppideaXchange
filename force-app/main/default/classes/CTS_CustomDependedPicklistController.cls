/*
 *  Written By : Ashlekh Gera
 *  Des : It is controller of the dependend Picklist component.
 */

public class CTS_CustomDependedPicklistController {
    
    @AuraEnabled
    public static String executer(  String objectName,String controllingField,String dependentField){
        OutPutWrapper outPt = getOutPutInner(objectName,controllingField, dependentField);
        if(outPt != null && outPt.isSuccess){
            return JSON.serialize(outPt);
        }
        return JSON.serialize(outPt);
    }
    
    private static OutPutWrapper getOutPutInner(  String objectName,String controllingField,String dependentField){
        
        OutPutWrapper outPt = new OutPutWrapper();
        outPt.isSuccess = false;
        if(isContainValidValue(objectName) || isContainValidValue(controllingField) || isContainValidValue(dependentField)){
            outPt.msg = 'Please provide correct value of Object,Controlling field and Dependent field';
            return outPt;
        }
        
        Map<String, List<String>> controllingInfo = new Map<String, List<String>>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        
        if(!gd.containsKey(objectName)){
            outPt.msg = 'Please provide correct API name of object.';
            return outPt;
        }
        
        Schema.SObjectType objType = gd.get(objectName);
        
        Schema.DescribeSObjectResult describeResult = objType.getDescribe();
        
        Map<String, Schema.SObjectField> FsMap = describeResult.fields.getMap();
        
        if(!FsMap.containsKey(controllingField)){
            outPt.msg = 'Please provide correct API name of Controlling Field.';
            return outPt;
        }
        
        if(!FsMap.containsKey(dependentField)){
            outPt.msg = 'Please provide correct API name of Dependent Field.';
            return outPt;
            
        }
        
        Schema.DescribeFieldResult controllingFieldInfo = FsMap.get(controllingField).getDescribe();
        
        
        String conField = String.valueOf(controllingFieldInfo.getType());
        conField = controllingFieldInfo.getType() == Schema.DisplayType.MULTIPICKLIST?'MULTIPICKLIST':
        (controllingFieldInfo.getType() == Schema.DisplayType.PICKLIST?'PICKLIST':conField);
            
            if(!conField.contains('PICKLIST')){
                outPt.msg = 'Provided field is not a picklist.';
                return outPt;                                                
            }
        
        
        
        Schema.DescribeFieldResult dependentFieldInfo = FsMap.get(dependentField).getDescribe();
        
        conField = String.valueOf(dependentFieldInfo.getType());
        conField = dependentFieldInfo.getType() == Schema.DisplayType.MULTIPICKLIST?'MULTIPICKLIST':
        (dependentFieldInfo.getType() == Schema.DisplayType.PICKLIST?'PICKLIST':conField);
            
            outPt.isDependendFieldMultiPickList = conField.contains('MULTIPICKLIST') ;                                      
        
        
        
        List<Schema.PicklistEntry> controllingValues = controllingFieldInfo.getPicklistValues();
        List<Schema.PicklistEntry> dependentValues = dependentFieldInfo.getPicklistValues();
        
        for(Schema.PicklistEntry currControllingValue : controllingValues)
        {
            //System.debug('ControllingField: Label:' + currControllingValue.getLabel());
            controllingInfo.put(currControllingValue.getLabel(), new List<String>());
        }
        
        if(!Test.isRunningTest())
        for(Schema.PicklistEntry currDependentValue : dependentValues)
        {
            //String jsonString = JSON.serialize(currDependentValue);
            MyPickListInfo info = (MyPickListInfo) JSON.deserialize(JSON.serialize(currDependentValue), MyPickListInfo.class);
            String hexString = EncodingUtil.convertToHex(EncodingUtil.base64Decode(info.validFor)).toUpperCase();
            //System.debug('DependentField: Label:' + currDependentValue.getLabel() + ' ValidForInHex:' + hexString + ' JsonString:' + jsonString);
            Integer baseCount = 0;
            for(Integer curr : hexString.getChars())
            {
                Integer val = 0;
                if(curr >= 65) val = curr - 65 + 10;
                else val = curr - 48;
                
                if((val & 8) == 8) controllingInfo.get(controllingValues[baseCount + 0].getLabel()).add(currDependentValue.getLabel());
                if((val & 4) == 4) controllingInfo.get(controllingValues[baseCount + 1].getLabel()).add(currDependentValue.getLabel());                    
                if((val & 2) == 2) controllingInfo.get(controllingValues[baseCount + 2].getLabel()).add(currDependentValue.getLabel());                    
                if((val & 1) == 1)   controllingInfo.get(controllingValues[baseCount + 3].getLabel()).add(currDependentValue.getLabel());                    
                baseCount += 4;
            }            
        } 
        
        outPt.msg = 'Done';
        outPt.isSuccess = true;
        outPt.controllingInfo = controllingInfo;
        return outPt;
        
    }
    
    private static boolean isContainValidValue(String container){
        return (container ==null || container.trim() =='');
    }
    
    public class MyPickListInfo { public String validFor; }
    
    public class OutPutWrapper{
        public  Map<String, List<String>> controllingInfo = new Map<String, List<String>>();
        public  Boolean isDependendFieldMultiPickList;
        public Boolean isSuccess; 
        String msg;
        public OutPutWrapper(){}
        
    }
}