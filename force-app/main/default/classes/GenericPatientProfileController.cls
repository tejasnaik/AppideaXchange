/****
* Class Name: GenericPatientProfileController
* Developed by: Rajendra Singh Nagar (640829)
* Author: Cognizant Technology Solutions
****/
public class GenericPatientProfileController {
	@AuraEnabled
    public static ProfileWrapper getPatientDetails(String fields, String contactRecId){
        Schema.SObjectType typeIs = Id.valueOf(contactRecId).getSObjectType();
        if(typeIs==Account.getSObjectType()){
            contactRecId = [select id from Contact where AccountId=:contactRecId limit 1].Id;//This will apply only for patients
        }
        
        Contact contactRecord = Database.query('select '+fields+' from Contact where Id=:contactRecId limit 1');
       
        //Set photo URL
        String imageLink=contactRecord.Profile_Card_Image__c;
        if(imageLink != null && imageLink.contains('</img>')){
            imageLink  = imageLink.substring(imageLink.indexOf('<img'));
            imageLink  = imageLink.substring(imageLink.indexOf('src="')+5,imageLink.indexOf('">'));
            imageLink  = imageLink.replace('&amp;','&');
        }else{
            imageLink = URL.getSalesforceBaseUrl().toExternalForm() + '/profilephoto/005/F';
        }
        
        return new ProfileWrapper(contactRecord, imageLink);
    }
    //Define wrapper to store Patient Information
    public class ProfileWrapper{
        @AuraEnabled
        public Contact contactRecord;
         @AuraEnabled
        public String imageURL;
        public ProfileWrapper(Contact contactRecord, String imageURL){
            this.contactRecord=contactRecord;
            this.imageURL=imageURL;
        }
    }
}