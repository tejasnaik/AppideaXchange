/**ss/|sss @Desc     : To serve as controller class for COE_PrintPreview Component
  *s/ /sss @Author   : Sumit Sharma (sumit.sharma3@cognizant.com)
  *s... |s @Methods  : 9
  *sss/ /s @TestClass: COE_PrintPreviewControllerTest.apxc
  *sss|/ss
  *sssssss 
 */

public class COE_PrintPreviewController {
    
    // Represents the final HTML Web Page String
    public String FinalHTML {get; set;}
    
    // Constructor to generate HTML Web Page
    public COE_PrintPreviewController(){
        String recordId = ApexPages.currentPage().getParameters().get('recId');
        if(recordId != NULL){
            FinalHTML = getTableLayout(recordId);
        }
    }
    
    // To obtain the URL for displaying the Printable View Web Page
    @AuraEnabled
    public static String getURL(String recordId){
        String urlString = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/PrintPreview?recId='+recordId;
        return urlString;
    }
    
    // Contains Alogrithms to generate body tag of Printable View Web Page
    @AuraEnabled
    public static String getTableLayout(String recordId){
        
        if(recordId == null || recordId == ''){
            return 'Unable to generate the view. Contact COE Team.';
        }
        
        // Varibale Declarations
        String recordName;
        String endpointServiceUrl;
        String resultBody;
        Integer startIndex;
        Integer lastIndex;
        String finalAPIString ;
        String newJSONString;
        List<String> objectFieldsLabel = new List<String>();
        List<String> objectFieldsValue = new List<String>();
        Integer sumRows = 0;
        Integer paraCount = 0;
        String paradoxString = 'sumitXparadox';
        Map<String, String> labelMap = new Map<String, String>();
        sObject accRecord;
        Map<String, String> fieldMap = new Map<String, String>();
        String baseURL;
        String htmlBody;
        String htmlPage;
        
        String objectName = findObjectAPIName(recordId);
        
        // To handle External Object Name Parameter
        if(objectName.endsWith('__x')){
            recordName = '  ';
        }
        else{
            try{
                sObject objDetail = Database.query('SELECT Id,Name FROM '+objectName+' WHERE Id=\''+recordId+'\'');
                recordName = String.valueOf(objDetail.get('Name'));
            }
            catch(Exception ex){
                return String.valueOf(ex.getMessage()+' '+ex.getCause()+' '+ex.getLineNumber()+' '+ex.getTypeName());
            }
        }
        
        // Obtain JSON response from salesforce
        try{
            endpointServiceUrl = '/services/data/v39.0/sobjects/'+objectName+'/describe/layouts';
            HttpResponse res = COE_PrintPreviewHttpServices.getHttpPrintPreviewService(UserInfo.getSessionId(), endpointServiceUrl);
            resultBody = String.valueOf(res.getBody());
            System.debug('resultBody >>'+resultBody);
            
            if(resultBody.substring(0, 15) == '{"layouts":null'){
                COE_PrintPreviewRecordTypeParse parsedResultBody = parseRecordTypeFlash(resultBody);
                
                for (Integer i = 0; i < parsedResultBody.recordTypeMappings.size(); i++ ) {
                    if(parsedResultBody.recordTypeMappings[i].defaultRecordTypeMapping == true){
                        try{
                            endpointServiceUrl = String.valueOf(parsedResultBody.recordTypeMappings[i].urls.layout);
                            HttpResponse resAgain = COE_PrintPreviewHttpServices.getHttpPrintPreviewService(UserInfo.getSessionId() , endpointServiceUrl);
                            resultBody = String.valueOf(resAgain.getBody());
                        }
                        catch(Exception ex){
                            return String.valueOf(ex.getMessage()+' '+ex.getCause()+' '+ex.getLineNumber()+' '+ex.getTypeName());
                        }
                    }
                }
                
            }
            
            startIndex = resultBody.indexOf('"detailLayoutSections":');
            lastIndex = resultBody.indexOf(',"editLayoutSections":');
            finalAPIString = resultBody.substring(startIndex, lastIndex);
            newJSONString = '{'+finalAPIString+'}';
            System.debug('newJSONString >>'+newJSONString);
        }
        catch(Exception ex){
            return String.valueOf(ex.getMessage()+' '+ex.getCause()+' '+ex.getLineNumber()+' '+ex.getTypeName());
        }
        
        COE_PrintPreviewParser parsedObject = parseFlash(newJSONString);
        
        // Sumitiching Extraction Algorithm
        for (Integer i = 0; i < parsedObject.detailLayoutSections.size(); i++ ) {
            
            if(parsedObject.detailLayoutSections[i].heading == 'Custom Links'){
                continue;
            }
            sumRows = sumRows + Integer.valueOf(parsedObject.detailLayoutSections[i].rows);
            
            if(parsedObject.detailLayoutSections[i].heading != null){
                paraCount = paraCount + 1;
            }
            
            for (Integer j = 0; j < parsedObject.detailLayoutSections[i].layoutRows.size(); j++ ){
                for (Integer k = 0; k < parsedObject.detailLayoutSections[i].layoutRows[j].layoutItems.size(); k++ ){
                    if(parsedObject.detailLayoutSections[i].layoutRows[j].layoutItems[k].label == ''){
                        paradoxString = paradoxString+i;
                        objectFieldsLabel.add(String.valueOf(paradoxString));
                    }else{
                        objectFieldsLabel.add(String.valueOf(parsedObject.detailLayoutSections[i].layoutRows[j].layoutItems[k].label));
                    }
                    if(parsedObject.detailLayoutSections[i].layoutRows[j].layoutItems[k].layoutComponents.size() != 0){
                        objectFieldsValue.add(String.valueOf(parsedObject.detailLayoutSections[i].layoutRows[j].layoutItems[k].layoutComponents[0].value));
                    }else{
                        objectFieldsValue.add('');
                    }
                }
            }
            
        }
        
        for(Integer i = 0; i< objectFieldsLabel.size(); i++){
            labelMap.put( String.valueOf(objectFieldsValue[i]), String.valueOf(objectFieldsLabel[i]));
        }
        
        String fields = String.join(objectFieldsValue,',');
        fields = fields.replaceAll(',,',',');
        if(fields.endsWith(',')){
            fields = fields.substring(0, fields.length()-1);
        }
        List<String> fieldList = fields.split(',');
        String query = 'SELECT Id,'+fields+' FROM '+objectName+' WHERE Id=\''+recordId+'\'';
        
        try{
            accRecord = Database.query(query);
        }
        catch(Exception ex){
            return String.valueOf(ex.getMessage()+' '+ex.getCause()+' '+ex.getLineNumber()+' '+ex.getTypeName());
        }
        
        for(String field: fieldList){
            fieldMap.put(field, String.valueOf(accRecord.get(field)));
        }
        
        // Sumitiching Mapping Algorithm
        for(Integer i = 0; i< objectFieldsValue.size(); i++){
            String fieldKeyName = objectFieldsValue[i];
            String fieldKeyId;
            String fieldObjectName;
            String fieldActualName;
            String fieldActualValue;
            if((fieldMap.get(fieldKeyName)!=null) && validateId(fieldMap.get(fieldKeyName))){
                fieldKeyId = fieldMap.get(fieldKeyName);
                fieldObjectName = findObjectAPIName(fieldKeyId);
                
                if(fieldObjectName != null && fieldObjectName != ''){
                    String queryObj = 'SELECT Id, Name FROM '+fieldObjectName+' WHERE Id=\''+fieldKeyId+'\'';
                    sObject obj;
                    try{
                        obj = Database.query(queryObj);
                        fieldActualName = String.valueOf(obj.get('Name'));
                    } catch(Exception ex){
                        fieldActualName = ' ';
                    }
                    
                    fieldMap.remove(objectFieldsValue[i]); 
                    fieldMap.put(String.valueOf(objectFieldsValue[i]), fieldActualName);
                }
            }
            else if(fieldKeyName != null && fieldKeyName != ''){
                Schema.SObjectType sObjType = Schema.getGlobalDescribe().get(objectName);
                Schema.DescribeSObjectResult sObjResult = sObjType.getDescribe();
                Schema.DescribeFieldResult sObjField = sObjResult.fields.getMap().get(fieldKeyName).getDescribe();
                
                String queryObj = 'SELECT Id, '+fieldKeyName+' FROM '+objectName+' WHERE Id=\''+recordId+'\'';
                sObject obj = Database.query(queryObj);
                fieldActualValue = String.valueOf(obj.get(fieldKeyName));
                
                if(String.valueOf(sObjField.getType()) == 'CURRENCY'){
                    String symbol = currencySymbol(UserInfo.getDefaultCurrency());
                    if(fieldActualValue == null || fieldActualValue == ''){
                        fieldActualValue = '  ';
                    }else{
                        fieldActualValue = symbol+fieldActualValue;
                    }
                }
                if(String.valueOf(sObjField.getType()) == 'PERCENT'){
                    if(fieldActualValue == null || fieldActualValue == ''){
                        fieldActualValue = '  ';
                    }else{
                        fieldActualValue = fieldActualValue+'%';
                    }
                }
                if(String.valueOf(sObjField.getType()) == 'ADDRESS'){
                    fieldActualValue = extractAddress(recordId, fieldKeyName);
                }
                fieldMap.put(fieldKeyName, fieldActualValue);
            }
        }
        
        baseURL = URL.getSalesforceBaseUrl().toExternalForm();
        htmlBody = '<table border="0" style="border-collapse: collapse; width: 100%; table-layout:fixed;">';
        
        // Dynamically creating HTML body tag
        for(Integer i = 0; i< objectFieldsValue.size(); i++){
            if((math.mod(i,2))==0){
                if(objectFieldsValue[i] == ''){
                    htmlBody += '<tr><td class="right18">&nbsp;</td><td class="left32">&nbsp;</td>';
                }
                else{
                    if(fieldMap.get(objectFieldsValue[i])==''||fieldMap.get(objectFieldsValue[i])== null){
                        if(String.valueOf(labelMap.get(objectFieldsValue[i])).contains('sumitXparadox')){
                            htmlBody += '<tr><td class="right18">&nbsp;</td><td class="left32">&nbsp;</td>';
                        }
                        else{
                            htmlBody += '<tr><td class="right18">'+labelMap.get(objectFieldsValue[i])+'</td><td class="left32">&nbsp;</td>';
                        }
                    }
                    else{
                        if(String.valueOf(labelMap.get(objectFieldsValue[i])).contains('sumitXparadox')){
                            htmlBody += '<tr><td class="right18">&nbsp;</td><td class="left32">&nbsp;</td>';
                        }
                        else{
                            if(String.valueOf(fieldMap.get(objectFieldsValue[i])).equals('true')){
                                htmlBody += '<tr><td class="right18">'+labelMap.get(objectFieldsValue[i])+'</td><td class="left32">'+'<img style="text-align: left;" src="'+ baseURL +'/img/checkbox_checked.gif" alt="true" width="21" height="16" title="true"/>'+'</td>';
                            }
                            else if(String.valueOf(fieldMap.get(objectFieldsValue[i])).equals('false')){
                                htmlBody += '<tr><td class="right18">'+labelMap.get(objectFieldsValue[i])+'</td><td class="left32">'+'<img style="text-align: left;" src="'+ baseURL +'/img/checkbox_unchecked.gif" alt="false" width="21" height="16" title="false"/>'+'</td>';
                            }
                            else{
                                htmlBody += '<tr><td class="right18">'+labelMap.get(objectFieldsValue[i])+'</td><td class="left32">'+fieldMap.get(objectFieldsValue[i])+'</td>';
                            }                  
                        }
                    }
                }
            }
            else{
                if(objectFieldsValue[i] == ''){
                    htmlBody += '<td class="right18">&nbsp;</td><td class="left32">&nbsp;</td></tr>';
                }
                else{
                    if(fieldMap.get(objectFieldsValue[i])==''||fieldMap.get(objectFieldsValue[i])== null){
                        if(String.valueOf(labelMap.get(objectFieldsValue[i])).contains('sumitXparadox')){
                            htmlBody += '<td class="right18">&nbsp;</td><td class="left32">&nbsp;</td></tr>';
                        }
                        else{
                            htmlBody += '<td class="right18">'+labelMap.get(objectFieldsValue[i])+'</td><td class="left32">&nbsp;</td></tr>';
                        }
                    }
                    else{
                        if(String.valueOf(labelMap.get(objectFieldsValue[i])).contains('sumitXparadox')){
                            htmlBody += '<td class="right18">&nbsp;</td><td class="left32">&nbsp;</td></tr>';
                        }
                        else{
                            if(String.valueOf(fieldMap.get(objectFieldsValue[i])).equals('true')){
                                htmlBody += '<td class="right18">'+labelMap.get(objectFieldsValue[i])+'</td><td class="left32">'+'<img style="text-align: left;" src="'+ baseURL +'/img/checkbox_checked.gif" alt="true" width="21" height="16" title="true"/>'+'</td></tr>';
                            }
                            else if(String.valueOf(fieldMap.get(objectFieldsValue[i])).equals('false')){
                                htmlBody += '<td class="right18">'+labelMap.get(objectFieldsValue[i])+'</td><td class="left32">'+'<img style="text-align: left;" src="'+ baseURL +'/img/checkbox_unchecked.gif" alt="false" width="21" height="16" title="false"/>'+'</td></tr>';
                            }
                            else{
                                htmlBody += '<td class="right18">'+labelMap.get(objectFieldsValue[i])+'</td><td class="left32">'+fieldMap.get(objectFieldsValue[i])+'</td></tr>';
                            }
                        }
                    }
                }
            }
            if((i==(objectFieldsValue.size()-1)) && ((math.mod(i,2))==0)){
                htmlBody += '<td class="right18">&nbsp;</td><td class="left32">&nbsp;</td></tr>';
            }
            
        }
        
        htmlBody += '</table>';
        htmlPage = getHTML(htmlBody, recordName);
        return htmlPage;
    }
    
    // To generate complete HTML body for Printable View Web Page
    public static string getHTML(String htmlTable, String Name){
        PrintPreview__c printPreviewObj = PrintPreview__c.getOrgDefaults();
        
        String html = '';
        String htmlHeader = '';
        String htmlFooter = '';
        String footerLabel = '';
        String logoURL = '';
        
        logoURL = String.valueOf(printPreviewObj.LogoURL__c);
        footerLabel = String.valueOf(printPreviewObj.CopyrightLabel__c);
        
        if(footerLabel == null || footerLabel == ''){
            footerLabel = 'Copyright © COE Pune, inc. All rights reserved.';
        }
        
        if(logoURL == null || logoURL == ''){
            logoURL = String.valueOf(URL.getSalesforceBaseUrl().toExternalForm()) + '/img/sfdc_printable_logo.gif';
        }
        
        htmlHeader += '<div style="height: 5%"><img style="text-align: left;" src="'+ logoURL +'" alt="Salesforce" width="146" height="47" title="Salesforce"/><div style="padding-top: 1%;"></div></div>';
        htmlHeader += '<div style="padding-bottom: 2%;"><h1 style="font-size: 140%; font-weight: bold;">'+ Name +'</h1></div>';
        htmlHeader += '<div style="border-bottom: 2px solid black; padding: 2p 2px 2px 2px; margin: 0; background-color: #fff;"></div>';
        
        htmlTable = '<div style="padding: 0; border: none; background: none; margin-bottom: 15px;">'+ htmlTable +'</div>';
        
        htmlFooter += '<div style="border-top: 1px solid #e8e8e8; padding: 10px 0 20px 0;"><div style="text-align: center; line-height: 1.8em;">'+footerLabel+'</div></div>';
        
        html += '<html><style> .right18 {color: #4a4a56; width: 18%;padding-top: 5px; padding-bottom: 5px;padding-right: 10px;font-size: 91%; font-weight: bold;text-align: right; word-wrap:break-word;} .left32 {color: #4a4a56;width: 32%;padding-top: 5px; padding-bottom: 5px;padding-left: 10px;text-align: left; word-wrap:break-word;}</style><body style="font-family: Arial,Helvetica,sans-serif;color: #222;">'+ htmlHeader + htmlTable + htmlFooter +'</body></html>';    
        
        return html;
    }
    
    // Validate Record Id
    public static Boolean validateId(String Idparam) {
        String Id = String.escapeSingleQuotes(Idparam);
        if((Id.length() == 15 || Id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', Id)) {
            return true;
        }
        return false;
    }
    
    public static String extractAddress(String recordId, String addressType){
        String fullAddress;
        if(addressType.containsIgnoreCase('Billing')){
            String queryObj = 'SELECT Id, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry FROM Account WHERE Id=\''+recordId+'\'';
            Account obj = Database.query(queryObj);
            fullAddress = obj.BillingStreet +' '+ obj.BillingCity +' '+ obj.BillingState +' '+ obj.BillingPostalCode +' '+ obj.BillingCountry;
        }
        else if(addressType.containsIgnoreCase('Shipping')){
            String queryObj = 'SELECT Id, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry FROM Account WHERE Id=\''+recordId+'\'';
            Account obj = Database.query(queryObj);
            fullAddress = obj.ShippingStreet +' '+ obj.ShippingCity +' '+ obj.ShippingState +' '+ obj.ShippingPostalCode +' '+ obj.ShippingCountry;
        }
        else if(addressType.containsIgnoreCase('Mailing')){
            String queryObj = 'SELECT Id, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry FROM Contact WHERE Id=\''+recordId+'\'';
            Contact obj = Database.query(queryObj);
            fullAddress = obj.MailingStreet +' '+ obj.MailingCity +' '+ obj.MailingState +' '+ obj.MailingPostalCode +' '+ obj.MailingCountry;
        }
        else{
            fullAddress = '';
        }
        
        fullAddress = fullAddress.replaceAll('null', '');
        
        return fullAddress;      
    }
    
    // Find Object Name from record ID
    public static string findObjectAPIName(String recordId){
        if(recordId == null)
            return null;
        String objectAPIName = '';
        String keyPrefix = recordId.substring(0,3);
        for( Schema.SObjectType obj : Schema.getGlobalDescribe().Values() ){
            String prefix = obj.getDescribe().getKeyPrefix();
            if(prefix == null){
                continue;
            }
            if(prefix.equals(keyPrefix)){
                objectAPIName = obj.getDescribe().getName();
                break;
            }
        }
        return objectAPIName;
    }
    
    // Find related Symbol for related ISO code
    public static String currencySymbol(String iso) { 
        String symbol = null;  
        if (iso=='ALL') { symbol='Lek'; } 
        else if (iso=='USD') { symbol='$'; } 
        else if (iso=='ARS') { symbol='$'; } 
        else if (iso=='AWG') { symbol='ƒ'; } 
        else if (iso=='AUD') { symbol='$'; } 
        else if (iso=='BSD') { symbol='$'; } 
        else if (iso=='BBD') { symbol='$'; } 
        else if (iso=='BYR') { symbol='p.'; } 
        else if (iso=='EUR') { symbol='€'; } 
        else if  (iso=='BZD') { symbol='BZ$'; } 
        else if (iso=='BMD') { symbol='$'; } 
        else if (iso=='BOB') { symbol='$b'; } 
        else if (iso=='BAM') { symbol='KM'; } 
        else if (iso=='BWP') { symbol='P'; } 
        else if (iso=='BRL') { symbol='R$'; } 
        else if (iso=='GBP') { symbol='£'; } 
        else if (iso=='BND') { symbol='$'; } 
        else if (iso=='CAD') { symbol='$'; } 
        else if (iso=='KYD') { symbol='$'; } 
        else if (iso=='CLP') { symbol='$'; } 
        else if (iso=='CNY') { symbol='¥'; } 
        else if (iso=='COP') { symbol='$'; } 
        else if (iso=='CRC') { symbol='¢'; } 
        else if (iso=='HRK') { symbol='kn'; } 
        else if (iso=='EUR') { symbol='€'; } 
        else if (iso=='CZK') { symbol='Kc'; } 
        else if (iso=='DKK') { symbol='kr'; } 
        else if (iso=='DOP') { symbol='RD$'; } 
        else if (iso=='XCD') { symbol='$'; } 
        else if (iso=='EGP') { symbol='£'; } 
        else if (iso=='SVC') { symbol='$'; } 
        else if (iso=='GBP') { symbol='£'; } 
        else if (iso=='EEK') { symbol='kr'; } 
        else if (iso=='EUR') { symbol='€'; } 
        else if (iso=='FKP') { symbol='£'; } 
        else if (iso=='FJD') { symbol='$'; } 
        else if (iso=='EUR') { symbol='€'; } 
        else if (iso=='GHC') { symbol='¢'; } 
        else if (iso=='GIP') { symbol='£'; } 
        else if (iso=='EUR') { symbol='€'; } 
        else if (iso=='GTQ') { symbol='Q'; } 
        else if (iso=='GGP') { symbol='£'; } 
        else if (iso=='GYD') { symbol='$'; } 
        else if (iso=='EUR') { symbol='€'; } 
        else if (iso=='HNL') { symbol='L'; } 
        else if (iso=='HKD') { symbol='$'; } 
        else if (iso=='HUF') { symbol='Ft'; } 
        else if (iso=='ISK') { symbol='kr'; } 
        else if (iso=='IDR') { symbol='Rp'; } 
        else if (iso=='EUR') { symbol='€'; } 
        else if (iso=='IMP') { symbol='£'; } 
        else if (iso=='EUR') { symbol='€'; } 
        else if (iso=='JMD') { symbol='J$'; } 
        else if (iso=='JPY') { symbol='¥'; } 
        else if (iso=='JEP') { symbol='£'; } 
        else if (iso=='LVL') { symbol='Ls'; }
        else if (iso=='LBP') { symbol='£'; } 
        else if (iso=='LRD') { symbol='$'; } 
        else if (iso=='CHF') { symbol='CHF'; } 
        else if (iso=='LTL') { symbol='Lt'; } 
        else if (iso=='EUR') { symbol='€'; } 
        else if (iso=='MYR') { symbol='RM'; } 
        else if (iso=='EUR') { symbol='€'; } 
        else if (iso=='MXN') { symbol='$'; } 
        else if (iso=='MZN') { symbol='MT'; } 
        else if (iso=='NAD') { symbol='$'; } 
        else if (iso=='ANG') { symbol='ƒ'; } 
        else if (iso=='EUR') { symbol='€'; } 
        else if (iso=='NZD') { symbol='$'; } 
        else if (iso=='NIO') { symbol='C$'; } 
        else if (iso=='NOK') { symbol='kr'; } 
        else if (iso=='PAB') { symbol='B/.'; } 
        else if (iso=='PYG') { symbol='Gs'; } 
        else if (iso=='PEN') { symbol='S/.'; } 
        else if (iso=='PHP') { symbol='Php'; } 
        else if (iso=='PLN') { symbol='zl'; }
        else if (iso=='RON') { symbol='lei'; } 
        else if (iso=='SHP') { symbol='£'; } 
        else if (iso=='SGD') { symbol='$'; } 
        else if (iso=='EUR') { symbol='€'; } 
        else if (iso=='SBD') { symbol='$'; } 
        else if (iso=='SOS') { symbol='S'; } 
        else if (iso=='ZAR') { symbol='R'; } 
        else if (iso=='EUR') { symbol='€'; } 
        else if (iso=='SEK') { symbol='kr'; } 
        else if (iso=='CHF') { symbol='CHF'; } 
        else if (iso=='SRD') { symbol='$'; } 
        else if (iso=='SYP') { symbol='£'; } 
        else if (iso=='TWD') { symbol='NT$'; } 
        else if (iso=='TTD') { symbol='TT$'; } 
        else if (iso=='TRY') { symbol='TL'; } 
        else if (iso=='TRL') { symbol='£'; } 
        else if (iso=='TVD') { symbol='$'; } 
        else if (iso=='GBP') { symbol='£'; } 
        else if (iso=='USD') { symbol='$'; } 
        else if (iso=='UYU') { symbol='$U'; } 
        else if (iso=='EUR') { symbol='€'; } 
        else if (iso=='VEF') { symbol='Bs'; } 
        else if (iso=='ZWD') { symbol='Z$'; } 
        return symbol; 
    }
    
    public static COE_PrintPreviewParser parseFlash(String JSONString){
        COE_PrintPreviewParser parsedString = COE_PrintPreviewParser.parse(JSONString);
        return parsedString;
    }
    
    public static COE_PrintPreviewRecordTypeParse parseRecordTypeFlash(String JSONString){
        COE_PrintPreviewRecordTypeParse parsedString = COE_PrintPreviewRecordTypeParse.parse(JSONString);
        return parsedString;
    }
    
}