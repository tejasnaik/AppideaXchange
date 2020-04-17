/*--------------------------------------------------------------------------
   Class: EmailLoadBatch
    
   Class Description: 
   This class process the csv file in batches.
      
      Date          Whom        Change #    
   ===========    ========    ============ 
   11-Nov-2017      Ayan      This class is implemented for dynamic email load.
   08-Feb-2018      Ayan    [Changed SFColumnVsLookedupMapValue to get the value by sfdc apiname]  
                 
--------------------------------------------------------------------------*/
global with sharing class EmailLoadBatch implements Database.batchable<String>, Database.Stateful
{
   private String m_csvFile;
   private Integer chunkNumber;
   private Integer successCount;
   private Integer errorCount;
   private Parser m_parser;
   private string emailadd;
   private string successString;
   private string errorString;
   private Messaging.InboundEmail email;
   private List<String> headerStr;
   private Boolean hasError=false;
   private String errmsg='';
   private set<string> updateId=new set<string>();
   private Map<String,CSV_Setting__mdt > settingMap=new Map<String,CSV_Setting__mdt >();
   private Map<String,Field_Mapping_Setting__mdt > columnsettingMap=new Map<String,Field_Mapping_Setting__mdt >();
   private Map<String,Field_Mapping_Setting__mdt > apicolumnsettingMap=new Map<String,Field_Mapping_Setting__mdt >();
   /*--------------------------------------------------------------------------
   Name              : EmailLoadBatch
   Method Description: 
   This is the constructor of the batch class.
   It forms the csv setting Map with the email subject as key.
      
      Date          Whom        Input #       Output #
   ===========    ========    ============   =============
   11-Nov-2017      Ayan          N/A            N/A
--------------------------------------------------------------------------*/
   public EmailLoadBatch(String attachmentStr,Messaging.InboundEmail emailMess)
   {
       m_csvFile=attachmentStr;
       email=emailMess;
       //System.debug('m_csvFile==>'+EncodingUtil.base64Decode(m_csvFile).toString());
       for(CSV_Setting__mdt setting:[select MasterLabel,Target_Object_API_Name__c,KeyFieldForUpdateSF__c,KeyForUpdate__c,File_Initials__c,Error_Email_Sent_To_be__c from CSV_Setting__mdt])
       {
         settingMap.put(setting.File_Initials__c ,setting);
       } 
       if(m_csvFile==null || m_csvFile=='')
       {
           errmsg+='Email has no attchment';
           haserror=true;
           emailadd=email.fromAddress;
       }
       else if(settingMap.keySet().contains(email.Subject))
       {
           if(settingMap.get(email.Subject).Error_Email_Sent_To_be__c!=null)
               emailadd=settingMap.get(email.Subject).Error_Email_Sent_To_be__c;
           else
               emailadd=email.fromAddress;
           for(Field_Mapping_Setting__mdt eachfieldMapping:[select CSV_Setting__c,DeveloperName,Date_Format__c,File_Column_Name__c,SF_Data_Type__c,SF_Field_Name__c from Field_Mapping_Setting__mdt where CSV_Setting__r.File_Initials__c=:email.Subject])
           {
               columnsettingMap.put(eachfieldMapping.File_Column_Name__c,eachfieldMapping);
               apicolumnsettingMap.put(eachfieldMapping.SF_Field_Name__c ,eachfieldMapping);
    
           
           }
       }
       
       else
       {
           errmsg+='Invalid email subject';
           haserror=true;
           emailadd=email.fromAddress;
       }
       chunkNumber=1; 
       successCount=0;
       errorCount=0;
   }
   /*--------------------------------------------------------------------------
   Name              : start Method
   Method Description: 
   This method returns csv row as per batch size  
      
      Date          Whom        Input #           Output #
   ===========    ========    ============       =============
   11-Nov-2017      Ayan     Batchable Context     chunk of csvString
--------------------------------------------------------------------------*/
   global Iterable<String> start(Database.batchableContext batchableContext)
   { 
      return new CSVIterator(m_csvFile, Parser.crlf);
   }
   /*--------------------------------------------------------------------------
   Name              : execute Method
   Method Description: 
   This method process the chunk of csv data and upsert the records.
      
      Date          Whom        Input #           Output #
   ===========    ========    ============       =============
   11-Nov-2017      Ayan     Batchable Context    upsert records
                             /csvstring
--------------------------------------------------------------------------*/
   global void execute(Database.BatchableContext batchableContext, List<String> scope)  
   {
       //TODO: Create a map with the column name and the position.
       
       String csvFile = '';
       for(String row : scope)
       {
          csvFile += row + Parser.crlf;
       }
        List<Sobject>sobjectlist=new List<Sobject>();
        List<Sobject>sobjectlistUpdate=new List<Sobject>();
        List<Map<String, Object>>allRows=new List<Map<String, Object>>();
        Map<Integer,Integer>insertIndexMap=new Map<Integer,Integer>();
        Map<Integer,Integer>updateIndexMap=new Map<Integer,Integer>();
        List<List<String>> csvFileString = CSVReader.readIETFRFC4180CSVFile(Blob.ValueOf(csvFile));
        
        if(chunkNumber==1)
        {
            String hstr='';
            headerStr=csvFileString [0];
            
            for(String s:headerStr)
            {
                if(s!=null && s!='')
                hstr+=s+',';
            }
            
            successString=hstr.remove('null')+'Status \n';
            errorString=hstr.remove('null')+'Status \n';
        }
        List<Map<string,string>>nameVersusValueMapList=GenericParserCtrl.generateNameVsValueMap(headerStr,csvFileString);
        System.debug('######nameVersusValueMapList'+nameVersusValueMapList);
        String sub=email.Subject;
        Map<String,Set<String>>KeyFieldVsValueSet=GenericParserCtrl.keyFieldVsValueSet(sub,nameVersusValueMapList);
        String Key=null;
        for(String eachKey :KeyFieldVsValueSet.keySet())
        {
            Key=eachKey ;
        }
        Map<String,String>KeyStringVsId=new Map<String,String>();
        if(settingMap.get(sub).KeyFieldForUpdateSF__c!=null)
            KeyStringVsId=GenericParserCtrl.KeyStringVsId(settingMap.get(sub).Target_Object_API_Name__c,KeyFieldVsValueSet,settingMap.get(sub).KeyFieldForUpdateSF__c);
        Map<String,Set<String>>FieldVsValueSet=GenericParserCtrl.generateFieldVsValueSet(sub,nameVersusValueMapList);
        Map<String,Map<String,String>>SFColumnVsLookedupMapValue=GenericParserCtrl.generateSFColumnVsLookedupMapValue(sub,FieldVsValueSet);
        for(Integer i=0;i<nameVersusValueMapList.size();i++)
        {
            
            allRows.add(GenericParserCtrl.generateFieldMap(sub,nameVersusValueMapList[i],SFColumnVsLookedupMapValue));
        }
        Integer j=0;
        Integer k=0;
        for(Integer i=0;i<allRows.size();i++)
        {
            Set<String> keycolumns=new Set<String>();
            if(Key!=null && Key.contains('|'))
            {
                for(String l: Key.split('\\|'))
                {
                    keycolumns.add(l);
                }  
            } 
            else
            {
                keycolumns.add(Key);
            }
            String keyForUpdate='';
            for(String s: keycolumns)
            {   
               
               if(nameVersusValueMapList[i].KeySet().contains(s) && nameVersusValueMapList[i].get(s)!=null)
                   keyForUpdate+=nameVersusValueMapList[i].get(s)+'|';
               //System.debug('1st==>'+GenericParserCtrl.formSobjectRow(settingMap.get(sub).Target_Object_API_Name__c,allRows[i],false,key,null,columnsettingMap,apicolumnsettingMap));
               //if(columnsettingMap.get(s)!=null && GenericParserCtrl.formSobjectRow(settingMap.get(sub).Target_Object_API_Name__c,allRows[i],false,key,null,columnsettingMap,apicolumnsettingMap).get(columnsettingMap.get(s).SF_Field_Name__c)!=null)
               //keyForUpdate+=String.ValueOf(GenericParserCtrl.formSobjectRow(settingMap.get(sub).Target_Object_API_Name__c,allRows[i],false,key,null,columnsettingMap,apicolumnsettingMap).get(columnsettingMap.get(s).SF_Field_Name__c))+'|';
   
            }
            System.debug('@@@@@@keyForUpdate'+keyForUpdate);
            System.debug('######allRows[i]'+allRows[i]);
            System.debug('######KeyStringVsId'+KeyStringVsId);
            if(key!=null && key!='' && KeyStringVsId!=null && KeyStringVsId.KeySet().contains(keyForUpdate.removeEnd('|')))
            {
                Sobject ob=GenericParserCtrl.formSobjectRow(settingMap.get(sub).Target_Object_API_Name__c,allRows[i],nameVersusValueMapList[i],true,key,KeyStringVsId,columnsettingMap,apicolumnsettingMap);
                if(updateId!=null && !updateId.contains(ob.Id))
                {
                    sobjectlistUpdate.add(ob);
                    updateId.add(ob.Id);
                    
                }
                updateIndexMap.put(j,i);
                j++;
            }
            else
            {                 
                sobjectlist.add(GenericParserCtrl.formSobjectRow(settingMap.get(sub).Target_Object_API_Name__c,allRows[i],nameVersusValueMapList[i],false,key,null,columnsettingMap,apicolumnsettingMap));               
                insertIndexMap.put(k,i);
                k++;
            }
        }
        System.debug('@@@@sobjectlist'+sobjectlist);
        System.debug('@@@@sobjectlistUpdate'+sobjectlistUpdate);
        if(sobjectlist!=null && sobjectlist.size()>0)
        {
            Database.SaveResult[] srList = Database.insert(sobjectlist, false);
            for (Integer i=0;i<srList.size();i++) {                
                if (srList[i].isSuccess()) {
                    
                    if(insertIndexMap.keySet().contains(i) && insertIndexMap.get(i)!=null)
                    {
                        String str='';
                        if(chunknumber==1)
                        {
                            for(String s:csvFileString[insertIndexMap.get(i)+1])
                            {
                                if(s!=null)
                                str+=s+',';
                            }
                        }
                        
                        else
                        {
                            for(String s:csvFileString[insertIndexMap.get(i)])
                            {
                                if(s!=null)
                                str+=s+',';
                            }
                        
                        }
                       
                        successString+=str.remove('null')+'Item Created \n';
                        successCount++;
                    }
                    
                    
                }
                else {
                    
                    
                    // Operation failed, so get all errors   
                    
                    if(insertIndexMap.keySet().contains(i) && insertIndexMap.get(i)!=null)
                    {
                        String str='';
                        if(chunknumber==1)
                        {
                            for(String s:csvFileString[insertIndexMap.get(i)+1])
                            {
                                if(s!=null)
                                str+=s+',';
                            }
                        }
                        
                        else
                        {
                            for(String s:csvFileString[insertIndexMap.get(i)])
                            {
                                if(s!=null)
                                str+=s+',';
                            }
                        
                        }
                        
                        errorString+=str.remove('null')+'Error:'+srList[i].getErrors()[0].getMessage()+' \n'; 
                        errorCount++;
                    }
                                
                    
                }
            }
        }
        if(sobjectlistUpdate!=null && sobjectlistUpdate.size()>0)
        {
            Database.SaveResult[] srListUpdate = Database.update(sobjectlistUpdate, false);
            for (Integer i=0;i<srListUpdate.size();i++) {
                
                if (srListUpdate [i].isSuccess()) {
                    
                    
                    if(updateIndexMap.keySet().contains(i) && updateIndexMap.get(i)!=null)
                    {
                        String str='';
                        if(chunknumber==1)
                        {
                            for(String s:csvFileString[updateIndexMap.get(i)+1])
                            {
                                if(s!=null)
                                str+=s+',';
                            }
                        }
                        else
                        {
                            for(String s:csvFileString[updateIndexMap.get(i)])
                            {
                                if(s!=null)
                                str+=s+',';
                            }
                        
                        }
                        successString+=str.remove('null')+'Item Updated \n';
                        successCount++;
                    }
                    
                    
                }
                else {
                    
                    
                    
                    if(updateIndexMap.keySet().contains(i) && updateIndexMap.get(i)!=null)
                    {
                        String str='';
                        
                        if(chunknumber==1)
                        {
                            for(String s:csvFileString[updateIndexMap.get(i)+1])
                            {
                                if(s!=null)
                                str+=s+',';
                            }
                        }
                        else
                        {
                            for(String s:csvFileString[updateIndexMap.get(i)])
                            {
                                if(s!=null)
                                str+=s+',';
                            }
                        
                        }
                        errorString+=str.remove('null')+'Error:'+srListUpdate [i].getErrors()[0].getMessage()+' \n';  
                        errorCount++;
                    }
                    
                    // Operation failed, so get all errors                
                    
                }
            }
        }
        chunkNumber++;
        System.debug('chunkNumber===>@@@@'+chunkNumber);
   }
   /*--------------------------------------------------------------------------
   Name              : finish Method
   Method Description: 
   This method generates the success and error file and send to
   configure email address
      
      Date          Whom        Input #           Output #
   ===========    ========    ============       =============
   11-Nov-2017      Ayan     Batchable Context    send email
  --------------------------------------------------------------------------*/
   global void finish(Database.BatchableContext batchableContext){
       Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
       message.toAddresses = new String[] { emailadd };
       message.subject = 'Email Load Status';
       if(!hasError)
       {
            Messaging.EmailFileAttachment csvErrAttc = new Messaging.EmailFileAttachment();
            blob csvErrBlob = Blob.valueOf(errorString);
            string csvErrname= 'Error.csv';
            csvErrAttc .setFileName(csvErrname);
            csvErrAttc .setBody(csvErrBlob );
            
            Messaging.EmailFileAttachment csvSuccAttc = new Messaging.EmailFileAttachment();
            blob csvsuccBlob = Blob.valueOf(successString);
            string csvsuccname= 'Success.csv';
            csvSuccAttc .setFileName(csvsuccname);
            csvSuccAttc .setBody(csvsuccBlob );
            message.setHtmlBody(successCount+' success and '+ errorCount+' error');
            message .setFileAttachments(new Messaging.EmailFileAttachment[]{csvSuccAttc ,csvErrAttc });
            
      }
      else
      {
          message.setHtmlBody(errmsg);
      }
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
        Messaging.sendEmail(messages);
   }
}