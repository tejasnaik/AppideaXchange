/*--------------------------------------------------------------------------
   Class: GenericParserCtrl
    
   Class Description: 
   This class is recives the chunk of csv data as text and forms into sobject record as per field mapping.
   Also this class does all the transformation related to static and/or dynamic data mapping.
      
      Date          Whom        Change #    
   ===========    ========    ============ 
   11-Nov-2017      Ayan      This class is implemented for dynamic email load.
   08-Feb-2018      Ayan  [Changed generateSFColumnVsLookedupMapValue method to form map based on fieldapiName as key]                         
--------------------------------------------------------------------------*/
public class GenericParserCtrl
{   
/*--------------------------------------------------------------------------
   Name              : generateNameVsValueMap
   Method Description: 
   This method is resonsible for mapping the file column with csv data as per 
   field mapping.
      
      Date          Whom        Input #       Output #
   ===========    ========    ============   =============
   11-Nov-2017      Ayan      headerString   List of map of column name versus
                             /csvrawdata     its respective value
   
--------------------------------------------------------------------------*/
public static List<Map<string,string>> generateNameVsValueMap(List<String>onlyHeader, List<List<String>> headerAndValue)
{
    List<Map<string,string>>allcolumnAndValues=new List<Map<string,string>>();
    for(Integer rowcount=0;rowcount<headerAndValue.size();rowcount++)
    {
        Map<string,string>FileColumnVsValue=new Map<string,string>();
        List<string>eachRowString=new List<string>();
        if(headerAndValue[rowcount]!=onlyHeader)
        {
            eachRowString=headerAndValue[rowcount];
            for(Integer columncount=0;columncount<onlyHeader.size();columncount++)
            {
                FileColumnVsValue.put(onlyHeader[columncount],eachRowString[columncount]);
            }
            allcolumnAndValues.add(FileColumnVsValue);
        }
        
        
        
    }
    return allcolumnAndValues;
}
/*--------------------------------------------------------------------------
   Name              : generateFieldMap
   
   Method Description: 
   This method is responsible for transforming the file column pair with csv data 
   to Salesforce field with csv data.
      
      Date          Whom        Input #                      Output #
   ===========    ========    ============                  =============
   11-Nov-2017      Ayan      csvsetting                    Map of salesforce column and its value
                             /list of file column           as object.
                             with csv data/ Salesforce 
                             lookup object column and its 
                             data for dynamic mapping
------------------------------------------------------------------------------*/
public static Map<String, Object> generateFieldMap(String csvSetting, Map<string,string>FileColumnVsValue,Map<String,Map<String,String>>SFColumnVsLookedupMapValue)
{
    Map<String, Object> fieldMap=new Map<String, Object>();
    Map<String,Set<String>>FieldVsValueSet=new Map<String,Set<String>>();
    Map<String,List<Data_Mapping_Setting__mdt> > DataVsfieldSetting=new Map<String,List<Data_Mapping_Setting__mdt> >();
    for(Data_Mapping_Setting__mdt eachdataMapping:[select Field_Mapping_Setting__r.File_Column_Name__c, Mapping_Type__c,Field_Mapping_Setting__r.DeveloperName,DeveloperName,File_Value__c,Target_Value__c from Data_Mapping_Setting__mdt where CSV_Setting__r.File_Initials__c=:csvSetting])
    {
        if(!DataVsfieldSetting.keySet().contains(eachdataMapping.Field_Mapping_Setting__r.developerName))
        {
           
            List<Data_Mapping_Setting__mdt>temp=new List<Data_Mapping_Setting__mdt>();
            temp.add(eachdataMapping);
            DataVsfieldSetting.put(eachdataMapping.Field_Mapping_Setting__r.developerName,temp);
        }
        else
        {
            List<Data_Mapping_Setting__mdt>temp=DataVsfieldSetting.get(eachdataMapping.Field_Mapping_Setting__r.developerName);
            temp.add(eachdataMapping);
            DataVsfieldSetting.put(eachdataMapping.Field_Mapping_Setting__r.developerName,temp);
        }
    }
        
    
    for(Field_Mapping_Setting__mdt eachfieldMapping:[select CSV_Setting__c,DeveloperName,File_Column_Name__c,SF_Data_Type__c,SF_Field_Name__c from Field_Mapping_Setting__mdt where CSV_Setting__r.File_Initials__c=:csvSetting])
    {
        if(FileColumnVsValue.keySet().contains(eachfieldMapping.File_Column_Name__c))
        {
            if(DataVsfieldSetting.keySet().contains(eachfieldMapping.developerName))
            {
                for(Data_Mapping_Setting__mdt dt:DataVsfieldSetting.get(eachfieldMapping.developerName))
                {
                    if(dt.Mapping_Type__c=='Static')
                    {
                        
                        if(dt.Field_Mapping_Setting__r.File_Column_Name__c==eachfieldMapping.File_Column_Name__c && FileColumnVsValue.keySet().contains(eachfieldMapping.File_Column_Name__c))
                        {
                            
                            for(String filecol :FileColumnVsValue.keySet())
                            {
                            
                                if(filecol==eachfieldMapping.File_Column_Name__c && filecol==dt.Field_Mapping_Setting__r.File_Column_Name__c && FileColumnVsValue.get(filecol)==dt.File_Value__c)
                                {
                                    fieldMap.put(eachfieldMapping.SF_Field_Name__c,dt.Target_Value__c );
                                   
                                }
                                
                                
                            }
                            
                        }
                    }
                    else if(dt.Mapping_Type__c=='Dynamic')
                    {
                        
                        fieldMap.put(eachfieldMapping.SF_Field_Name__c,SFColumnVsLookedupMapValue.get(eachfieldMapping.SF_Field_Name__c).get(FileColumnVsValue.get(eachfieldMapping.File_Column_Name__c)));
                    }
                    
                }
                
            }
            
            else
            {
                fieldMap.put(eachfieldMapping.SF_Field_Name__c,FileColumnVsValue.get(eachfieldMapping.File_Column_Name__c));
            }
        }
    }
    
    return fieldMap;
}
/*--------------------------------------------------------------------------
   Name              : KeyStringVsId
   
   Method Description: 
   This method returns the key string and its value pair for update operation
      
      Date          Whom        Input #                           Output #
   ===========    ========    ============                       =============
   11-Nov-2017      Ayan      Object Api Name                    Keystring with the Id 
                              /File key Versus its value map     for update operation
                              /SalesforceKeyField
------------------------------------------------------------------------------*/

public static Map<String,String> KeyStringVsId(String objectApi,Map<String,Set<String>>keyVsValues,String KeySFField)
{
    Map<String,String>existingKeysVsId=new Map<String,String>();
    if(keyVsValues!=null)
    {
        for(String key:keyVsValues.keySet())
        {
            Set<String>temp=keyVsValues.get(key);
            System.debug('@@@@@temp###'+temp);
            for(Sobject obj:  Database.query('select Id, '+KeySFField+' from '+objectApi+' where '+KeySFField+ ' in: temp'))
            {
                existingKeysVsId.put(String.ValueOf(obj.get(KeySFField)),String.ValueOf(obj.get('Id')));
            }
        }
        
    }
    return existingKeysVsId;
}
/*------------------------------------------------------------------------------
   Name              : keyFieldVsValueSet
   
   Method Description: 
   This method forms the key and its value set to query for limited data in context 
   of update operation
      
      Date          Whom        Input #                           Output #
   ===========    ========    ============                       =============
   11-Nov-2017      Ayan      CSV Setting                    Map of key for update along with its set of value
                              /List of filecumn and its 
                              value pair
------------------------------------------------------------------------------*/
public static Map<String,Set<String>> keyFieldVsValueSet(String csvSetting, List<Map<string,string>>FileColumnsVsValue)
{
    
    Map<String,Set<String>>FieldVsValueSet=new Map<String,Set<String>>();
    CSV_Setting__mdt setting=[select MasterLabel,Target_Object_API_Name__c,KeyFieldForUpdateSF__c,KeyForUpdate__c,File_Initials__c,Error_Email_Sent_To_be__c from CSV_Setting__mdt where File_Initials__c=:csvSetting limit 1];
    List<String> keycolumns=new List<String>();
    if(setting.KeyForUpdate__c!=null && setting.KeyForUpdate__c.contains('|'))
    {
        for(String k: setting.KeyForUpdate__c.split('\\|'))
        {
            keycolumns.add(k);
        }  
    } 
    else
    {
        keycolumns.add(setting.KeyForUpdate__c);
    }
    
    
    Set<String>temp=new Set<String>();
    for(Map<string,string> FileColumnVsValue:FileColumnsVsValue)
    {
        String s='';
        for(String k:keycolumns)
        {
            if(FileColumnVsValue.keySet().contains(k) && FileColumnVsValue.get(k)!=null)
            s+=FileColumnVsValue.get(k)+'|';
        }
        
        temp.add(s.removeEnd('|'));
    }
    
    FieldVsValueSet.put(setting.KeyForUpdate__c,temp);
    return FieldVsValueSet;
}
/*------------------------------------------------------------------------------
   Name              : keyFieldVsValueSet
   
   Method Description: 
   This method forms the Salesforce fieldName and its value set to query for limited data in context 
   of dynamic lookup
      
      Date          Whom        Input #                           Output #
   ===========    ========    ============                       =============
   11-Nov-2017      Ayan      CSV Setting                    Map of all field with dynamic data mapping
                              /List of filecumn and its      and its value set
                              value pair
------------------------------------------------------------------------------*/
public static Map<String,Set<String>> generateFieldVsValueSet(String csvSetting, List<Map<string,string>>FileColumnsVsValue)
{
    
    Map<String,Set<String>>FieldVsValueSet=new Map<String,Set<String>>();
    Map<String,List<Data_Mapping_Setting__mdt> > DataVsfieldSetting=new Map<String,List<Data_Mapping_Setting__mdt> >();
    for(Data_Mapping_Setting__mdt eachdataMapping:[select Field_Mapping_Setting__r.File_Column_Name__c, Mapping_Type__c,Field_Mapping_Setting__r.DeveloperName,DeveloperName,File_Value__c,Target_Value__c from Data_Mapping_Setting__mdt where CSV_Setting__r.File_Initials__c=:csvSetting])
    {
        if(!DataVsfieldSetting.keySet().contains(eachdataMapping.Field_Mapping_Setting__r.developerName))
        {
            List<Data_Mapping_Setting__mdt>temp=new List<Data_Mapping_Setting__mdt>();
            temp.add(eachdataMapping);
            DataVsfieldSetting.put(eachdataMapping.Field_Mapping_Setting__r.developerName,temp);
        }
        else
        {
            List<Data_Mapping_Setting__mdt>temp=DataVsfieldSetting.get(eachdataMapping.Field_Mapping_Setting__r.developerName);
            temp.add(eachdataMapping);
            DataVsfieldSetting.put(eachdataMapping.Field_Mapping_Setting__r.developerName,temp);
        }
    }
    for(Field_Mapping_Setting__mdt eachfieldMapping:[select CSV_Setting__c,DeveloperName,File_Column_Name__c,SF_Data_Type__c,SF_Field_Name__c from Field_Mapping_Setting__mdt where CSV_Setting__r.File_Initials__c=:csvSetting])
    {
           
        if(DataVsfieldSetting.keySet().contains(eachfieldMapping.developerName))
        {
            for(Data_Mapping_Setting__mdt dt:DataVsfieldSetting.get(eachfieldMapping.developerName))
                {
                    if(dt.Mapping_Type__c=='Dynamic')
                    {
                        for(Map<string,string> FileColumnVsValue:FileColumnsVsValue)
                        {
                            
                            if(FileColumnVsValue.keySet().contains(eachfieldMapping.File_Column_Name__c))
                            {
                                
                                if(!FieldVsValueSet.keySet().contains(eachfieldMapping.File_Column_Name__c))
                                {
                                    Set<String>temp=new Set<String>();
                                    temp.add(FileColumnVsValue.get(eachfieldMapping.File_Column_Name__c));
                                    FieldVsValueSet.put(eachfieldMapping.File_Column_Name__c,temp);
                                }
                                else
                                {
                                    Set<String>temp=FieldVsValueSet.get(eachfieldMapping.File_Column_Name__c);
                                    temp.add(FileColumnVsValue.get(eachfieldMapping.File_Column_Name__c));
                                    FieldVsValueSet.put(eachfieldMapping.File_Column_Name__c,temp);
                                }
                            }
                        
                        }
                    }
                }
        }
    }
    return FieldVsValueSet;
}
/*------------------------------------------------------------------------------
   Name              : keyFieldVsValueSet
   
   Method Description: 
   This method forms the Salesforce fieldName and its value set to query for limited data in context 
   of dynamic lookup
      
      Date          Whom        Input #                           Output #
   ===========    ========    ============                       =============
   11-Nov-2017      Ayan      CSV Setting                    Map of all field with dynamic data mapping
                              /List of filecumn and its      and its value set
                              value pair
------------------------------------------------------------------------------*/
public static Map<String,Map<String,String>> generateSFColumnVsLookedupMapValue(String csvSetting, Map<String,Set<String>>FieldVsValueSet)
{  
    Map<String,Map<String,String>>SFColumnVsLookedupMapValue=new Map<String,Map<String,String>>();
    Map<String,List<Data_Mapping_Setting__mdt> > DataVsfieldSetting=new Map<String,List<Data_Mapping_Setting__mdt> >();
    for(Data_Mapping_Setting__mdt eachdataMapping:[select Field_Mapping_Setting__r.File_Column_Name__c, Look_Up_Object__c,Mapped_Field__c,Look_Up_Field__c,Mapping_Type__c,Field_Mapping_Setting__r.DeveloperName,DeveloperName,File_Value__c,Target_Value__c from Data_Mapping_Setting__mdt where CSV_Setting__r.File_Initials__c=:csvSetting])
    {
        if(!DataVsfieldSetting.keySet().contains(eachdataMapping.Field_Mapping_Setting__r.developerName))
        {
            List<Data_Mapping_Setting__mdt>temp=new List<Data_Mapping_Setting__mdt>();
            temp.add(eachdataMapping);
            DataVsfieldSetting.put(eachdataMapping.Field_Mapping_Setting__r.developerName,temp);
        }
        else
        {
            List<Data_Mapping_Setting__mdt>temp=DataVsfieldSetting.get(eachdataMapping.Field_Mapping_Setting__r.developerName);
            temp.add(eachdataMapping);
            DataVsfieldSetting.put(eachdataMapping.Field_Mapping_Setting__r.developerName,temp);
        }
    }
    List<String>temp=new List<String>();
    Set<String>tempSet=new Set<String>();
    for(Field_Mapping_Setting__mdt eachfieldMapping:[select CSV_Setting__c,DeveloperName,File_Column_Name__c,SF_Data_Type__c,SF_Field_Name__c from Field_Mapping_Setting__mdt where CSV_Setting__r.File_Initials__c=:csvSetting])
    {
        Map<String,String>FileValueVsSFValue=new  Map<String,String>();
        if(FieldVsValueSet.keySet().contains(eachfieldMapping.File_Column_Name__c))
        {
           
            if(DataVsfieldSetting.keySet().contains(eachfieldMapping.developerName))
            {
                for(Data_Mapping_Setting__mdt dt:DataVsfieldSetting.get(eachfieldMapping.developerName))
                {
                    if(dt.Mapping_Type__c=='Dynamic')
                    {
                        for(String val:FieldVsValueSet.get(eachfieldMapping.File_Column_Name__c))
                        {
                            if(val!=null && val!='' && !tempSet.contains(val))
                            {
                                temp.add('%'+val+'%');
                                tempSet.add(val);
                            }
                        }
                    }
                }
             }
         }
    }
    System.debug('@@@@temp==>'+temp);
    for(Field_Mapping_Setting__mdt eachfieldMapping:[select CSV_Setting__c,DeveloperName,File_Column_Name__c,SF_Data_Type__c,SF_Field_Name__c from Field_Mapping_Setting__mdt where CSV_Setting__r.File_Initials__c=:csvSetting])
    {
        Map<String,String>FileValueVsSFValue=new  Map<String,String>();
        if(FieldVsValueSet.keySet().contains(eachfieldMapping.File_Column_Name__c))
        {
           
            if(DataVsfieldSetting.keySet().contains(eachfieldMapping.developerName))
            {
                for(Data_Mapping_Setting__mdt dt:DataVsfieldSetting.get(eachfieldMapping.developerName))
                {
                    if(dt.Mapping_Type__c=='Dynamic')
                    {
                            System.debug('fieldname==>'+eachfieldMapping.developerName);
                            System.debug('query==>'+'select '+dt.Mapped_Field__c+', '+dt.Look_Up_Field__c+' from '+dt.Look_Up_Object__c+' where '+dt.Look_Up_Field__c+ ' LIKE :temp limit 49999');
                            for(Sobject obj:  Database.query('select '+dt.Mapped_Field__c+', '+dt.Look_Up_Field__c+' from '+dt.Look_Up_Object__c+' where '+dt.Look_Up_Field__c+ ' LIKE :temp limit 49999'))
                            {
                                
                                System.debug('Look_Up_Field__c==>'+String.ValueOf(obj.get(dt.Look_Up_Field__c)));
                                System.debug('Mapped_Field__c==>'+String.ValueOf(obj.get(dt.Mapped_Field__c)));
                                if(String.ValueOf(obj.get(dt.Look_Up_Field__c))!=null && String.ValueOf(obj.get(dt.Look_Up_Field__c))!='' && String.ValueOf(obj.get(dt.Look_Up_Field__c)).contains(','))
                                {
                                    for(String eachKey: String.ValueOf(obj.get(dt.Look_Up_Field__c)).split(','))
                                    {
                                        FileValueVsSFValue.put(eachKey,String.ValueOf(obj.get(dt.Mapped_Field__c))); 
                                    }
                                }
                                else if(String.ValueOf(obj.get(dt.Look_Up_Field__c))!=null && String.ValueOf(obj.get(dt.Look_Up_Field__c))!='' && !String.ValueOf(obj.get(dt.Look_Up_Field__c)).contains(','))
                                {
                                    
                                    FileValueVsSFValue.put(String.ValueOf(obj.get(dt.Look_Up_Field__c)),String.ValueOf(obj.get(dt.Mapped_Field__c)));
                                    
                                }
                            }
                    }
                }
                
            }
           
        }
        
        SFColumnVsLookedupMapValue.put(eachfieldMapping.SF_Field_Name__c,FileValueVsSFValue);
        
    }
    System.debug('SFColumnVsLookedupMapValue'+SFColumnVsLookedupMapValue);
    return SFColumnVsLookedupMapValue;
}
/*------------------------------------------------------------------------------
   Name              : formSobjectRow
   
   Method Description: 
   This method forms Sobject record from the map
      
      Date          Whom        Input #                           Output #
   ===========    ========    ============                       =============
   11-Nov-2017      Ayan      object API Name                    List of SObject Instance
                              /Salesforce Field Name with value      
                              /update flag/Update Key
                              /KeyString and its related Id map
                              /column setting map for filecolumn and SF Column
------------------------------------------------------------------------------*/
public static SObject formSobjectRow(String sObjectApiName, Map<String, Object> fieldMap,Map<String, String> fileMap,Boolean isUpdate,String updateKey,Map<String,String>KeyStringVsId,Map<String,Field_Mapping_Setting__mdt > columnsettingMap,Map<String,Field_Mapping_Setting__mdt > apicolumnsettingMap)
{
    Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sObjectApiName);
    SObject newSobject = targetType.newSObject();
    Map<String, Schema.sObjectField> targetFields = targetType.getDescribe().fields.getMap();
    for (String key : fieldMap.keySet())
    {
        Object value = fieldMap.get(key);
        Schema.DisplayType valueType = targetFields.get(key).getDescribe().getType();
        if (value instanceof String && valueType != Schema.DisplayType.String)
        {
            String svalue = (String)value;
            if (valueType == Schema.DisplayType.Date)
                newSobject.put(key, GenericParserCtrl.setStringToDateFormat(((svalue!=null && svalue!='')?svalue.substringBefore(' '):null),key,apicolumnsettingMap));            
            else if(valueType == Schema.DisplayType.DateTime)
                newSobject.put(key, DateTime.valueOfGmt(svalue));
            else if (valueType == Schema.DisplayType.Percent || valueType == Schema.DisplayType.Currency)
                newSobject.put(key, svalue == '' ? null : Decimal.valueOf(svalue.remove(',')));
            else if (valueType == Schema.DisplayType.Double)
                newSobject.put(key, svalue == '' ? null : Double.valueOf(svalue.remove(',')));
            else if (valueType == Schema.DisplayType.Integer)
                newSobject.put(key, Integer.valueOf(svalue.remove(',')));
            else if (valueType == Schema.DisplayType.Base64)
                newSobject.put(key, Blob.valueOf(svalue));
            else
                newSobject.put(key, svalue);
        }
        else
            newSobject.put(key, value);
            
        if(isUpdate)
        {
            List<String> keycolumns=new List<String>();
            if(updateKey.contains('|'))
            {
                for(String k: updateKey.split('\\|'))
                {
                    keycolumns.add(k);
                }  
            } 
            else
            {
                keycolumns.add(updateKey);
            }
            String keyForUpdate='';
            for(String s: keycolumns)
            {
                keyForUpdate+=String.ValueOf(fileMap.get(s))+'|';
            }
            System.debug('$$$$$$$keyForUpdate'+keyForUpdate.removeEnd('|'));
            if(keyForUpdate!=null && keyForUpdate!='')
            newSobject.put('Id', KeyStringVsId.get(keyForUpdate.removeEnd('|')));
        }
    }
    return newSobject;
}
/*------------------------------------------------------------------------------
   Name              : setStringToDateFormat
   
   Method Description: 
   convert csv file's string to its apprpriate date format
      
      Date          Whom        Input #                           Output #
   ===========    ========    ============                    =============
   11-Nov-2017      Ayan      Date as string                     Date
                              ?Date Format
------------------------------------------------------------------------------*/
private static Date setStringToDateFormat(String myDate,String fieldname,Map<String,Field_Mapping_Setting__mdt >apicolumnsettingMap) {
   Date d;
   if(myDate!=null && myDate!='' && myDate.contains('/'))
   {
   String[] myDateOnly = myDate.split(' ');
   String[] strDate = myDateOnly[0].split('/');
   Integer myIntDate;
   Integer myIntMonth;
   Integer myIntYear;
   
   if(apicolumnsettingMap.get(fieldname).Date_Format__c=='mm/dd/yyyy')
   {
       myIntDate = integer.valueOf(strDate[1]);
       myIntMonth = integer.valueOf(strDate[0]);
       myIntYear = integer.valueOf(strDate[2]);
       
    }
    else if(apicolumnsettingMap.get(fieldname).Date_Format__c=='dd/mm/yyyy')
    {
       myIntDate = integer.valueOf(strDate[0]);
       myIntMonth = integer.valueOf(strDate[1]);
       myIntYear = integer.valueOf(strDate[2]);
       
    
    }
    else if(apicolumnsettingMap.get(fieldname).Date_Format__c=='yyyy/mm/dd')
    {
       myIntDate = integer.valueOf(strDate[2]);
       myIntMonth = integer.valueOf(strDate[1]);
       myIntYear = integer.valueOf(strDate[0]);
       
    }
    d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
    
   return d;
   }
   else if(apicolumnsettingMap.get(fieldname).Date_Format__c=='yyyy-mm-dd')
   {
       String[] myDateOnly = myDate.split(' ');
       String[] strDate = myDateOnly[0].split('-');
       Integer myIntDate=integer.valueOf(strDate[2]);
       Integer myIntMonth=integer.valueOf(strDate[1]);
       Integer myIntYear=integer.valueOf(strDate[0]); 
       d=Date.newInstance(myIntYear, myIntMonth, myIntDate);
       return d;
   }
   else
   return null;
}
}