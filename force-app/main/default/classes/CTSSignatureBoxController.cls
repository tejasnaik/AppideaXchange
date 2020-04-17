/*
 * 	Created By Ashlekh Gera
 *  Desc : Save the signature as a img file in attachment of parent record.
 */
public class CTSSignatureBoxController {
    
    /* Method to save the signature as png file. 
     * ParentId - Id of the record.
     * FileName - Name of the file.
     */ 
	@AuraEnabled
    public static Map<String,object> signDocument( String ParentId, String fileName, String base64Data, String contentType,String ErrorMessage ) {
        Map<String,object> returnMap = new Map<String,object>();
        if(!(ParentId instanceof Id)){
        	returnMap.put('isSuccess',false);
            returnMap.put('msg',ErrorMessage);
            return returnMap;
        }
        try
        {
            Attachment att = new Attachment();
            att.ParentId = ParentId;
            att.Body = EncodingUtil.base64Decode(base64Data);
            att.ContentType = contentType;
            att.Name = UserInfo.getName()+fileName;
            returnMap.put('isSuccess',true);
            returnMap.put('msg','Saved Successfully.');
            if(!test.isrunningtest()){
                insert att;
                returnMap.put('RecordID',att.id);
            }
        }catch(Exception e){
             returnMap.put('isSuccess',false);
             returnMap.put('msg',''+e.getMessage());
        }
        return returnMap; 
    }
}