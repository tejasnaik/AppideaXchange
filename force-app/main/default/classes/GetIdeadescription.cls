public without sharing class GetIdeadescription {
    @AuraEnabled
    public static List<Idea> getIdea(){
        return [SELECT Id, Title, Body, CommunityId, NumComments, 
                VoteScore, VoteTotal, Categories,  Status,CreatorSmallPhotoUrl ,CreatorName,CreatedDate  FROM Idea];
    }
    
    @AuraEnabled
    public static List<Idea> getIdea1(){
        List<Idea> i=[SELECT Id, Title, Body, CreatedDate FROM Idea order by CreatedDate desc];
        System.debug('hi'+i);
        return [SELECT Id, Title, Body, CreatedDate,VoteScore,VoteTotal,CreatorSmallPhotoUrl,CreatorName   FROM Idea order by CreatedDate desc];
    }
    
    @AuraEnabled
    public static List<Idea> getIdea2(){
        List<Idea> i=[SELECT Title, Id, CreatedDate, Body, VoteScore FROM Idea order by VoteScore desc];
        System.debug('hi'+i);
        return [SELECT Title, Id, CreatedDate, Body, VoteScore,VoteTotal,CreatorSmallPhotoUrl,CreatorName   FROM Idea order by VoteScore desc];
    }
    
    @AuraEnabled
    public static List<Idea> getIdea3(String id){
        List<Idea> i=[SELECT Title, Id, CreatedDate, Body, VoteScore,VoteTotal,CreatorSmallPhotoUrl,CreatorName  FROM Idea where Id=:id order by VoteScore desc ];
        
        return [SELECT Title, Id, CreatedDate, Body, VoteScore,VoteTotal,CreatorSmallPhotoUrl,CreatorName   FROM Idea order by VoteScore desc];
    }
    
    @AuraEnabled
    public static List<Idea> getRelatedIdeas(String ideaName){
        try{
            List<List<SObject>> searchList=[FIND :ideaName IN ALL FIELDS RETURNING Idea (Title,NumComments,Status,VoteTotal)];
            if(searchList.size()>0){
                Idea[] ideas=(List<Idea>)searchList[0];
                if(ideas.size()>0)
                    return ideas;
            }    
        }catch(Exception e){
            System.debug(e.getStackTraceString());
        }
        return null;
    }
    
    @AuraEnabled
    public static void createIdea(String title,String body,String cat){
        try{
            Idea newIdea=new Idea();
            newIdea.Title=title;
            newIdea.Body=body;
            newIdea.CommunityId='09a46000000kVtgAAE';
            newIdea.Categories=cat;
            
            
            insert newIdea;
            
        }catch(Exception e){
            system.debug(e.getStackTraceString());
        }
        
    }
    
    public static void createComment(Id iId,String comment){
        
        try{
            IdeaComment newIdeaComment=new IdeaComment();
            newIdeaComment.IdeaId=iId;
            newIdeaComment.CommentBody=comment;
            
            insert newIdeaComment;
        }catch(DmlException e){
            
        }
    }
    
   
}