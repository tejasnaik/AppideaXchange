/*
* Author	: Sachin Chavan
* Date 	 	: April 2017
*/
@isTest
private class IdeaXchangeRESTServiceTest {

    @isTest static void IdeaXchangeRESTServiceTest() {
        String title = 'Test Idea Title';
        String category = 'Solution';
        String body = 'Test Idea Descripion';
        String voteType = 'Up';
        String userId = Userinfo.getUserId();
        String pocid=Userinfo.getUserId();
        String ver='BFS';
        String cloud='Sales';
        
        CogniAppEx__Idea__c ideaNew1 = new CogniAppEx__Idea__c();
        ideaNew1.CogniAppEx__Title__c = 'Lightning Experience LEX - lightning speed please!';
        ideaNew1.CogniAppEx__Description__c = 'In order for LEX to appeal to our users, it needs to react more quickly or at least be perceived to be faster - right now Lightning is a misnomer.  We see a landing page while the screen loads, which shows the release logo.';
        ideaNew1.CogniAppEx__Category__c = 'Solution';
        ideaNew1.CogniAppEx__User__c = Userinfo.getUserId();
        insert ideaNew1;
        IdeaXchangeRESTService.doPost('IDEA234',title,body , category,'Up', ideaNew1.id, userId,pocid,ver,cloud);

       	IdeaXchangeRESTService.doPost('IDEA',title,body , category,'Up', ideaNew1.id, userId,pocid,ver,cloud);
        IdeaXchangeRESTService.doPost('IDEA_COMMENT',title,body , category,'Up', ideaNew1.id, userId,pocid,ver,cloud);
		IdeaXchangeRESTService.doPost('IDEA_VOTE',title,body , category,'Up', ideaNew1.id, userId,pocid,ver,cloud);

    	Idea__c ideaNew = IdeaXchangeRESTService.submitIdea(title, category, body, userId,pocid,ver,cloud);
        System.assertNotEquals(null, ideaNew.Id);
        
        Idea_Comment__c ideaCommentNew = IdeaXchangeRESTService.submitIdeaComment(ideaNew.Id, body, userId);
        System.assertNotEquals(null, ideaCommentNew.Id);
        
        ideaNew = IdeaXchangeRESTService.submitIdeaVote(ideaNew.Id, userId, voteType);
        System.assertNotEquals(null, ideaNew.Id);
        
        voteType = 'Down';
        ideaNew = IdeaXchangeRESTService.submitIdeaVote(ideaNew.Id, userId, voteType);
        System.assertNotEquals(null, ideaNew.Id);
    }
    
}