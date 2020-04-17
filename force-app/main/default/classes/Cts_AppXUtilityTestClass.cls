@isTest
private class Cts_AppXUtilityTestClass {
    static testmethod void submitRatingTestMethod(){
        User userObj = FlashUtilityClass.createUser(false);
        insert userObj;
        
        asb_Store__c storeObj = new asb_Store__c(Name='Cognizant AppXchange',Status__c ='Online' );
        insert storeObj;
        
        asb_App__c appObj = new asb_App__c(isActive__c=true,AppType__c ='Component',Categories__c='HumanResources');
        appObj.Name = 'Test';
        appObj.Store__c = storeObj.id;
        appObj.Languages__c = 'Englist';
        appObj.LogoUrl__c = '/servlet/servlet.FileDownload?file=00P46000000y2OZEAY';
        appObj.InstallUrl__c = 'https://login.salesforce.com/packaging/installPackage.apexp?p0=04t46000000KROf';
        insert appObj;
        
        Attachment attachmentObj = new Attachment(ParentId = appObj.id,Name='TEST');
        attachmentObj.Body = blob.valueOf('Test'); 
        insert attachmentObj;
        
        asb_Listing__c listingObj = new asb_Listing__c(Status__c = 'Live');
        listingObj.asb_App__c = appObj.id;
        listingObj.Description__c = 'TEst';
        listingObj.Tagline__c= 'TEST';
        listingObj.Language__c= 'Englilsh';
        insert listingObj;
        
        System.runAs(userObj){
            System.assert(Cts_AppXUtility.submitRating(String.valueOf(listingObj.Id),String.valueOf(userObj.Id) ,String.valueOf(attachmentObj.Body) )!=null);
            System.assert(Cts_AppXUtility.logComment(String.valueOf(listingObj.Id),String.valueOf(userObj.Id) ,String.valueOf(attachmentObj.Body))!=null);
            System.assert(Cts_AppXUtility.getRequest( '/v1/comments', 'POST', 'application/json', String.valueOf(attachmentObj.Body))!=null);            
            
        }
    } 
    
    static testmethod void getCustomMetadataTestMethod(){
        System.assert(Cts_AppXUtility.getCustomMetadata('Notification_REST_API_Config')!=null);            
    }
    
    //                HttpRequest hr = Cts_AppXUtility.getRequest( restAPISetting.REST_Endpoint__c + '/v1/comments', 'POST', 'application/json', body );
    
}