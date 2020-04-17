public class ProNotesController {
    
    //Retrieve all notes
    @AuraEnabled
    public static List<Note> findAll(Id recordId) {
        List<Note> a=[SELECT Id,Title FROM Note WHERE ParentId=:recordId];
        return a;
        
    }
    
    //To delete Notes
    @Auraenabled
    public static List<Note> deleteNoteById(String NoteId,Id recordId)
    {
        Note delNote=[Select Id from Note where Id=:NoteId];
        delete delNote;
        return [Select Id,Title from Note WHERE ParentId=:recordId];
    }
    
    //To save notes
    @Auraenabled
    public static List<Note> saveNote(String noteName,String noteBody,Id recordId)
    {
        Note nt = new Note();
        nt.Title = noteName;
        nt.Body = noteBody;
        nt.ParentId = recordId;
        insert nt;
        return [SELECT Id,Title FROM Note WHERE ParentId=:recordId];
        
    }
}