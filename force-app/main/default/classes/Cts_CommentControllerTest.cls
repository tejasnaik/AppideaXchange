@isTest
private class Cts_CommentControllerTest {
    
    private static testMethod void negativeTestOne(){
        String returnData =  Cts_CommentController.getAllRelatedComments(null, 5, 0);	
        Cts_CommentController.OutPutWrapper res = (Cts_CommentController.OutPutWrapper)JSON.deserialize(returnData,Cts_CommentController.OutPutWrapper.class);
		system.assertEquals(res.isSuccess, false );
        returnData= Cts_CommentController.commentShareCaller( null, null, null);
        res = (Cts_CommentController.OutPutWrapper)JSON.deserialize(returnData,Cts_CommentController.OutPutWrapper.class);
        system.assertEquals(res.isSuccess, false );
    }
    
    private static testMethod void positiveTestOne(){
      	asb_App__c app =   createData();
        string entityId = app.DefaultListing__c;
        String returnData =  Cts_CommentController.commentShareCaller('TEST CLASS EXECUTIOM',entityId,null);	
        Cts_CommentController.OutPutWrapper res = (Cts_CommentController.OutPutWrapper)JSON.deserialize(returnData,Cts_CommentController.OutPutWrapper.class);
		system.assertEquals(res.isSuccess, true );
        returnData =  Cts_CommentController.getAllRelatedComments(entityId, 5, 0);
    	res = (Cts_CommentController.OutPutWrapper)JSON.deserialize(returnData,Cts_CommentController.OutPutWrapper.class);
        system.assertEquals(res.isSuccess, true );
        returnData =  Cts_CommentController.getAllRelatedComments(entityId, null, 0);
        CTS_PvtAppXChangeNotificationV1.doPost(entityId,userinfo.getUserId(),'TEST CLASS CREATING THIS body','comments','');
        CTS_PvtAppXChangeNotificationV1.doPost(entityId,userinfo.getUserId(),'3','submitRating','');
        Cts_pvtAppXlandingController.submitRating (3, entityId,userinfo.getUserId(), 'COMPONENT');
    }
    
    private static asb_App__c createData()
    {
        asb_Store__c store = new asb_Store__c(Name='Cognizant AppXchange',Status__c ='Online' );
        insert store;
        asb_App__c ap = new asb_App__c(isActive__c=true,AppType__c ='Component',Categories__c='HumanResources');
        ap.Name = 'Test';
        ap.Store__c = store.id;
        //ap.Status__c = 'Published';
        ap.Languages__c = 'Englist';
        ap.LogoUrl__c = '/servlet/servlet.FileDownload?file=00P46000000y2OZEAY';
        ap.InstallUrl__c = 'https://login.salesforce.com/packaging/installPackage.apexp?p0=04t46000000KROf';
        insert ap;
        Attachment att = new Attachment(ParentId = ap.id,Name='TEST');
        att.Body = blob.valueOf('test'); 
        insert att;
        asb_Listing__c lal = new asb_Listing__c(Status__c = 'Live');
        lal.asb_App__c = ap.id;
        lal.Description__c = 'TEst';
        //lal.isDefaultAppListing__c = true;
        lal.Tagline__c= 'TEST';
        lal.Language__c= 'Englilsh';
        insert lal;
        ap.DefaultListing__c = lal.id;
        ap.InstallUrl__c = '/servlet/servlet.FileDownload?file='+att.id;
        //CTS_PageHitNotification__c cs = new CTS_PageHitNotification__c(SetupOwnerId=UserInfo.getOrganizationId(), isActive__c=true,EndPointUrl__c ='google.cm');
        //insert cs;
        update ap;
        return ap;
        
    }
}