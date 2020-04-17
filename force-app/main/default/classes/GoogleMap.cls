public with sharing class GoogleMap {
    @AuraEnabled
    public static Result[] getAccounts(String searchString,String[] fields,String sanitizedSObjectAPIName,String searchOn, String distance, String distanceRange){
        //https://releasenotes.docs.salesforce.com/en-us/summer16/release-notes/rn_general_geocodes_aloha.htm
        //https://releasenotes.docs.salesforce.com/en-us/summer16/release-notes/data_dot_com_clean_add_geocode_information_to_all_records.htm
        //https://help.salesforce.com/articleView?id=data_dot_com_clean_admin_clean_rules.htm&type=0&language=en_US
        String sanitizedSearchString = String.escapeSingleQuotes(searchString);
        //String sanitizedSObjectAPIName = 'Account';//String.escapeSingleQuotes(sObjectAPIName);
        //String searchOn='NAME';
        List<Result> results = new List<Result>();
        System.debug('searchString:'+searchString);
        System.debug('fields:'+fields); 
        System.debug('sanitizedSObjectAPIName:'+sanitizedSObjectAPIName);
        System.debug('searchOn:'+searchOn);
        System.debug('searchOn:'+distance);
        
        //List of account to be returned 
        List<Account> resultAcc = new List<Account>();
        
        //In case of distance range
        if(distance != 'choose one...' && distanceRange != 'choose one...') {
            
             /** Finding geocode for selected **/
            String cityState = searchString.remove('*').remove(' ');
            List<String> cityStateArray = cityState.split('AND');
            List<Account> ac = new List<Account>();
            if(cityStateArray.size() == 2)  {
                
                system.debug('@@@@@@@@@@@@@@@@@@@@' + cityStateArray[0] + cityStateArray[1]);
            	ac = [SELECT Id , Location__Latitude__s, Location__Longitude__s FROM Account 
                      WHERE BillingState =: cityStateArray[0]
                      AND BillingCity =: cityStateArray[1] LIMIT 1];
                                                                                                                                                                        
                Decimal disR = Decimal.valueOf(distance);
                String disRR = String.valueOf(distanceRange);
                
                if(ac.size() > 0) { 
                    resultAcc = [SELECT Id,  Name,  BillingCountry, BillingLatitude,  BillingLongitude, 
                                 BillingStreet, BillingCity from Account WHERE DISTANCE(BillingAddress , GEOLOCATION(:ac[0].Location__Latitude__s , :ac[0].Location__Longitude__s), 
                                                                                        'km') < : disR ];
                }   
            }
            for(Account a : resultAcc) {
                
                results.add(new Result((sObject)a));
            }
        }else {
            
            // Build our SOSL query
            String searchQuery = 'FIND \'' + sanitizedSearchString + '\' IN ' +searchOn +' FIELDS RETURNING ' + sanitizedSObjectAPIName + fields + ' Limit 50'; 
            System.debug('searchQuery:'+searchQuery);
            // Execute the Query
            List<List<SObject>> searchList = search.query(searchQuery);            
            for (SObject so : searchList[0])
            {
                results.add(new Result(so));
            }
        }
        
        system.debug('@@@@@@@@@@@@Final results@@@@@@@@@@' + results);
        return results;
        //return [select id, name, BillingLatitude, BillingLongitude from Account where name=:searchString/*BillingLatitude != null and BillingLongitude != null*/];
    }
    @AuraEnabled
    public static List<Contact> getContacts(Id AccountID){
        //https://releasenotes.docs.salesforce.com/en-us/summer16/release-notes/rn_general_geocodes_aloha.htm
        //https://releasenotes.docs.salesforce.com/en-us/summer16/release-notes/data_dot_com_clean_add_geocode_information_to_all_records.htm
        //https://help.salesforce.com/articleView?id=data_dot_com_clean_admin_clean_rules.htm&type=0&language=en_US
        return [select id, name, MailingLatitude, MailingLongitude from Contact where AccountId=:AccountID];
    }
    /**
* Inner class to wrap up an SObject Label and its Id
*/
    public class Result
    {
        @AuraEnabled public SObject objRecords {get; set;}
        
        public Result(SObject obj)
        {
            this.objRecords = obj;
        }
    }
}