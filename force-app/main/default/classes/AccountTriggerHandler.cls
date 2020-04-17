public class AccountTriggerHandler {
    
    //Constant to avoid recusrsion
    public static Boolean BYPASS_ACCOUNT_TRIGGER = FALSE;
    //Method to populate geolocation of accounts
    public static void getAccountGeolocations(List<Account> accounts) {
        
        List<Account> pAcc = [select Id, Name , BillingStreet ,BillingState , BillingCity , BillingCountry , BillingPostalCode , BillingLatitude , BillingLongitude From 
                        Account where id in : accounts];
                        
                        
        Batch_CalculateAccountGeocodes  bc = new Batch_CalculateAccountGeocodes  (pAcc);
        Database.executeBatch(bc, 50);        
    }
}