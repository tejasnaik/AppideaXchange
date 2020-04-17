@isTest
private class IdeaXChangeControllerTest {

    @testSetup static void setupTestData() {
        List<CogniAppEx__Idea__c> ideaToBeInsertList = new List<CogniAppEx__Idea__c>();
        CogniAppEx__Idea__c ideaNew = new CogniAppEx__Idea__c();
        ideaNew.CogniAppEx__Title__c = 'Lightning Experience LEX - lightning speed please!';
        ideaNew.CogniAppEx__Description__c = 'In order for LEX to appeal to our users, it needs to react more quickly or at least be perceived to be faster - right now Lightning is a misnomer.  We see a landing page while the screen loads, which shows the release logo.';
        ideaNew.CogniAppEx__Category__c = 'Solution';
        ideaNew.CogniAppEx__User__c = Userinfo.getUserId();
        
        ideaToBeInsertList.add(ideaNew);
        insert ideaToBeInsertList;
        
        List<CogniAppEx__Idea_Comment__c> ideaCommentToBeInsertList = new List<CogniAppEx__Idea_Comment__c>();
        CogniAppEx__Idea_Comment__c ideaCommentNew = new CogniAppEx__Idea_Comment__c();
        ideaCommentNew.CogniAppEx__Idea__c = ideaNew.Id;
        ideaCommentNew.CogniAppEx__Body__c = 'Test Comment Description';
        ideaCommentNew.CogniAppEx__User__c = Userinfo.getUserId();
        
        ideaCommentToBeInsertList.add(ideaCommentNew);
        insert ideaCommentToBeInsertList;
    }

    @isTest 
    public Static void lookupSearchTest(){
        ideaXChangeController.lookupSearch('User','Pratiksha');
        
        ideaXChangeController.getpicklistvalues('CogniAppEx__Idea__c','CogniAppEx__Cloud__c');
    }
    @isTest static void ideaXChangeControllerTest() {
        Test.startTest();
        String title = 'Test Title';
        String category = 'Solution';
        String description = 'Test Description';
        String voteType = 'Up';
        String Vertical='BFS';
        String Cloud='Sales';
        String pocId=UserInfo.getUserId();
        
        Map<String,Object> resultMap = IdeaXChangeController.getIdeaList('RECENT', 'Test', 5);
        Boolean isSuccess = (Boolean)resultMap.get('success');
        System.assertEquals(true, isSuccess);
        
        resultMap = IdeaXChangeController.getIdeaList('POPULAR', 'Test', 5);
        System.assertEquals(true, isSuccess);
        
        CogniAppEx__Idea__c ideaNew = [SELECT Id FROM CogniAppEx__Idea__c LIMIT 1];
        List<Idea_Comment__c> ideaCommentList = IdeaXChangeController.getIdeaCommentsFor(ideaNew.Id);
        System.assertEquals(1, ideaCommentList.size());

        Map<String,Object> restResponse = IdeaXChangeController.submitIdea(title, category, description, pocId, Vertical, Cloud);
        restResponse = IdeaXChangeController.submitIdeaComment(ideaNew.Id, description);
        restResponse = IdeaXChangeController.submitIdeaVote(ideaNew.Id, voteType);
        
        Test.stopTest();
    }    
}