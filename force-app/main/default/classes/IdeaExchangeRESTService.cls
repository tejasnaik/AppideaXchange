/*
 * Author: Sachin Chavan
 * Description: REST API to insert Idea, IdeaComment and Likes.
 */

@RestResource(urlMapping='/api/ideaservice')
global without sharing class IdeaExchangeRESTService {
    /*
     * Author       : Sachin Chavan
     * Description  : This is generic HTTP Post method used to insert/update new Ideas, Idea Comments and Idea Votes.
     * Date         : April 2017
     */
    @HttpPost
    global static sObject doPost(String action, String title, String body, String category, String voteType, String ideaId, String userId){
        if('IDEA'.equalsIgnoreCase(action)) {
            return submitIdea(title, category, body, userId);
        } else if('IDEA_COMMENT'.equalsIgnoreCase(action)) {
            return submitIdeaComment(ideaId, body, userId);
        } else if('IDEA_VOTE'.equalsIgnoreCase(action)) {
            return submitIdeaVote(ideaId, userId, voteType);
        }
        
        return null;
    }
    
    /*
     * Author       : Sachin Chavan
     * Description  : This is utility method used to insert new Ideas.
     * Date         : April 2017
     */
    @testVisible
    private static Idea__c submitIdea(String title, String category, String body, Id userId) {
        Idea__c ideaNew = new Idea__c();
        ideaNew.Title__c = title;
        ideaNew.Body__c = body;
        ideaNew.Category__c = category;
        ideaNew.User__c = userId;
        
        insert ideaNew;
        
        ideaNew = [SELECT Id, Name, CogniAppEx__User__c, CogniAppEx__User__r.Name, CogniAppEx__User__r.SmallPhotoUrl, CogniAppEx__Title__c, CogniAppEx__Body__c, CogniAppEx__Category__c, CogniAppEx__Like_Count__c, CogniAppEx__Dislike_Count__c, CogniAppEx__Status__c, CogniAppEx__Days_Difference__c, CreatedDate, (SELECT Id FROM CogniAppEx__Idea_Comments__r)
                   FROM CogniAppEx__Idea__c
                   WHERE Id = :ideaNew.Id];
        
        return ideaNew;
    }
    
    /*
     * Author       : Sachin Chavan
     * Description  : This is utility method used to insert new Idea Comments.
     * Date         : April 2017
     */
    @testVisible
    private static Idea_Comment__c submitIdeaComment(String ideaId, String body, String userId) {
        Idea_Comment__c ideaCommentNew = new Idea_Comment__c();
        ideaCommentNew.Idea__c = ideaId;
        ideaCommentNew.Body__c = body;
        ideaCommentNew.User__c = userId;
        
        insert ideaCommentNew;
        
        ideaCommentNew = [SELECT Id, Name, CogniAppEx__User__r.Name, CogniAppEx__User__r.SmallPhotoURL, CogniAppEx__Days_Difference__c, CogniAppEx__Body__c, CogniAppEx__Idea__c, CreatedDate 
                          FROM CogniAppEx__Idea_Comment__c
                          WHERE Id = :ideaCommentNew.Id];
        
        return ideaCommentNew;
    }
    
    /*
     * Author       : Sachin Chavan
     * Description  : This is utility method used to insert new Idea Votes.
     * Date         : April 2017
     */
    @testVisible
    private static Idea__c submitIdeaVote(String ideaId, String userId, String voteType) {
        List<Idea__c> ideaList = [SELECT Id, CogniAppEx__Like_Count__c, CogniAppEx__Dislike_Count__c FROM CogniAppEx__Idea__c WHERE Id = :ideaId];
        List<Idea_Vote__c> ideaVoteList = [SELECT Id, CogniAppEx__Type__c FROM CogniAppEx__Idea_Vote__c WHERE User__c = :userId AND Idea__c = :ideaId];
        
        Idea_Vote__c ideaVoteNew = ideaVoteList.isEmpty() ? new Idea_Vote__c() : ideaVoteList[0];
        ideaVoteNew.Idea__c = ideaId;
        ideaVoteNew.User__c = userId;
        ideaVoteNew.Type__c = voteType;
        upsert ideaVoteNew;
        
        //Update Like/Dislike Count
        if('UP'.equalsIgnoreCase(voteType)) {
            ideaList[0].CogniAppEx__Like_Count__c += 1;
            if(!ideaVoteList.isEmpty()) {
                ideaList[0].CogniAppEx__Dislike_Count__c -= 1;
            }
        } else if('DOWN'.equalsIgnoreCase(voteType)) {
            ideaList[0].CogniAppEx__Dislike_Count__c += 1;
            if(!ideaVoteList.isEmpty()) {
                ideaList[0].CogniAppEx__Like_Count__c -= 1;
            }
        }
        
        update ideaList[0];
        return ideaList[0];
    }
}