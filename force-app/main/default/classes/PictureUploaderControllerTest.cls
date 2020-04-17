@isTest
public class PictureUploaderControllerTest {
	
    public static testmethod void unitTest()
    {
        Account a = new Account(name='Test');
        insert a;
        Test.startTest();
        PictureUploaderController.getProfilePicture(a.id);
        PictureUploaderController.saveAttachment(a.id,'TEST','da','image/png');
        Test.stopTest();
    }
}