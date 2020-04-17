public class FileUploadController {
    
    @AuraEnabled
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) { 
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment attachmentNew = new Attachment();
        attachmentNew.parentId = parentId;

        attachmentNew.Body = EncodingUtil.base64Decode(base64Data);
        attachmentNew.Name = fileName;
        attachmentNew.ContentType = contentType;
        insert attachmentNew;
        
        return attachmentNew.Id;
    }
    
    @AuraEnabled
    public static Id saveTheChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) { 
        if (String.isBlank(fileId)) {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
        
        return Id.valueOf(fileId);
    }
    
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Attachment attachmentNew = [SELECT Id, Body FROM Attachment WHERE Id = :fileId];
        
     	String existingBody = EncodingUtil.base64Encode(attachmentNew.Body);
        attachmentNew.Body = EncodingUtil.base64Decode(existingBody + base64Data); 
        
        update attachmentNew;
    }
}