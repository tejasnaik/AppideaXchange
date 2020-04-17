@isTest
private class CTS_PvtAppXChangeNotificationTest {

    private static testMethod void unitTest(){
        asb_App__c c =  createData();
        String r = CTS_PvtAppXChangeNotification.doPost(c.DefaultListing__c, userinfo.getUserId());
    	system.assert(r instanceof Id);
    }
    
    private static asb_App__c createData(){
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