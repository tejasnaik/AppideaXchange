public class barcodeActionController{
	@AuraEnabled
    Public Static String getFields(id objID, String objField){
        String objtype = string.valueOf(objID).substring(0, 3);
        Schema.SObjectType objectName;
        for( Schema.SObjectType ot : Schema.getGlobalDescribe().values() ){
            String keyPrefix = (String)ot.getDescribe().getKeyPrefix();
            if( keyPrefix != null && keyPrefix.equals( objtype ) ){
                objectName = ot;
            }
        }
        
		Sobject results = Database.query('select '+ objField+' from ' + objectName +' where id=:objID');
        return String.valueOf(results.get(objField));    
    }
    
    @AuraEnabled
    public static String saveTheFile(Id parentId, String codeval, String technique, String objField) { 
        String message='';
        String attachName = 'Barcode_'+objField+'_'+technique+'.htm';
        list<Attachment> checkattch = [SELECT Name FROM Attachment WHERE Parentid=:parentId and Name=:attachName]; 
        
        if(checkattch.size() == 0){
           	String codeAttach = EncodingUtil.base64Encode(Blob.valueOf(codeval));
            string base64Data = EncodingUtil.urlDecode(codeAttach, 'UTF-8');
            
            Attachment a = new Attachment();
            a.parentId = parentId;
            a.Body = Blob.valueOf(codeval);
            a.Name = attachName;
            insert a;
            message = 'Attachment Created Successfully'; 
        }
        return message;
    }
}