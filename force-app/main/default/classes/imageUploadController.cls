public class imageUploadController {    
    //To get the image
    @AuraEnabled
    public static Attachment getProfilePicture(Id imageId) {
        return [SELECT Id, Name, LastModifiedDate, ContentType FROM Attachment 
                WHERE parentid=:imageId AND ContentType IN ('image/png', 'image/jpeg', 'image/gif') 
                ORDER BY LastModifiedDate DESC LIMIT 1];
        
    }    
    //To save the image
    @AuraEnabled
    public static Id saveAttachment(Id imageId, String fileName, String base64Data, String contentType) { 
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Attachment attachment = new Attachment();
        attachment.parentId = imageId;
        attachment.body = EncodingUtil.base64Decode(base64Data);
        attachment.name = fileName;
        attachment.contentType = contentType;
        insert attachment;
        return attachment.id;
    }   
}