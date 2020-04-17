@isTest
private class imageUploadControllerTest {
    private static testmethod void getProfilePictureTest(){
        Contact conObj = new Contact();
        conObj.LastName = 'Sharma';
        insert conObj;
        
        Attachment attObj = new Attachment();
        attObj.parentId = conObj.Id;
        attObj.body = EncodingUtil.base64Decode('2F9j2FBooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAoooHxHh8H2bRR');
        attObj.Name = 'avatar1.jpg';
	    attObj.contentType = 'image/jpeg';
        insert attObj;
        
        system.assert(imageUploadController.getProfilePicture(conObj.Id)!=null);
    }
    
    private static testmethod void saveAttachmentTest(){
        Contact conObj = new Contact();
        conObj.LastName = 'Sharma';
        insert conObj;
        
        system.assert(imageUploadController.saveAttachment(conObj.Id, 'avatar1.jpg', '2F9j2FBooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAoooHxHh8H2bRR', 'image/jpeg')!=null);
    }
}