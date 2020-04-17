/*
* Author    : Sachin Chavan
* Date      : April 2017
*/
@isTest
private class IdeaExchangeRESTServiceTest {

    @isTest static void ideaExchangeRESTServiceTest() {
        String title = 'Test Idea Title';
        String category = 'Solution';
        String body = 'Test Idea Descripion';
        String voteType = 'Up';
        String userId = Userinfo.getUserId();
        
        Idea__c ideaNew = IdeaExchangeRESTService.submitIdea(title, category, body, userId);
        System.assertNotEquals(null, ideaNew.Id);
        
        Idea_Comment__c ideaCommentNew = IdeaExchangeRESTService.submitIdeaComment(ideaNew.Id, body, userId);
        System.assertNotEquals(null, ideaCommentNew.Id);
        
        ideaNew = IdeaExchangeRESTService.submitIdeaVote(ideaNew.Id, userId, voteType);
        System.assertNotEquals(null, ideaNew.Id);
        
        voteType = 'Down';
        ideaNew = IdeaExchangeRESTService.submitIdeaVote(ideaNew.Id, userId, voteType);
        System.assertNotEquals(null, ideaNew.Id);
    }
    
}