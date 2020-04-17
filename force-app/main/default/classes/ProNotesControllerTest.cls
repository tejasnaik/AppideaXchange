@isTest
public class ProNotesControllerTest {
    static testMethod void findAllTest(){
        
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;

        Note testNote = new Note();
        testNote.Title = 'Test Account Note';
        testNote.Body = 'Test Account Note Body.';
        testNote.ParentId = testAccount.Id;
        insert testNote;
        
        System.assert(ProNotesController.findAll(testAccount.Id)!=null);
    }
    
    static testMethod void deleteNoteByIdTest(){
        
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;

        Note testNote = new Note();
        testNote.Title = 'Test Account Note';
        testNote.Body = 'Test Account Note Body.';
        testNote.ParentId = testAccount.Id;
        insert testNote;
        
        System.assert(ProNotesController.deleteNoteById(testNote.Id, testAccount.Id)!=null);
    }
    
    static testMethod void saveNoteTest(){
        
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;

        System.assert(ProNotesController.saveNote('Name', 'Body', testAccount.Id)!=null);
    }

}