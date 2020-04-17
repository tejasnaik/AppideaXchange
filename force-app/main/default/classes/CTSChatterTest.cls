public without sharing class CTSChatterTest {

    @AuraEnabled
    public static string testMe(){
        Account acc = new Account();
        try{

            FeedItem f1 = new FeedItem();
            f1.RelatedRecordId = '00146000003hXcM';
            f1.body = 'Comment By AKG';
            insert f1;

        }catch(Exception e){
            return 'exception- '+e.getMessage();
        }
        return acc.id;
    } 
}