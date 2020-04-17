/*
    Written By : Ashlekh Gera
    Description : This is a controller of image uploader component to proivde functionality.
*/

public with sharing class PictureUploaderController {
    
    /*
    *     Method - getProfilePicture
    *     Parameter - String - parentId ( Record Id under which attachment(image) was uploaded)
    *     return - Attachment - return the attachment.
    *     Description - When the component get loaded under any standard record page, component try to find the last attached image by calling this function.
    */
    @AuraEnabled
    public static Attachment getProfilePicture(Id parentId) {
        List<Attachment> att =  [SELECT Id, Name, LastModifiedDate, ContentType FROM Attachment 
            WHERE parentid=:ParentId AND ContentType IN ('image/png', 'image/jpeg', 'image/gif') 
            ORDER BY LastModifiedDate DESC LIMIT 1];
        if(att != null && att.size()>0)
            return att[0];
        return null;
    }
    
    
     /*
     *     Method - saveAttachment
     *     Parameter - String - parentId ( Record Id under which attachment(image) need to upload)
     *                 String - fileName ( Contain file Name) 
     *                 String - base64Data - Contain BASE64 of uploaded image.
     *                 String - contentType - Contain the content type of uploaded image eg. jpg/png
     *     return - Id of the attachment 
     *     Description - Component call this function to upload image when user drop the image in area.
     *
     */
    @AuraEnabled
    public static Id saveAttachment(String parentId, String fileName, String base64Data, String contentType) { 

        if(parentId != null && fileName != null && base64Data != null && contentType !=null)
        {
            
            Attachment attachment = new Attachment(parentId = parentId, 
                                               body = EncodingUtil.base64Decode(base64Data),
                                               name = fileName,
                                               contentType = contentType);
            insert attachment;
            return attachment.id;
        }
        return null;
    }

}