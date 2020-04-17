global class Batch_CalculateAccountGeocodes implements Database.Batchable<sObject> , Database.Stateful,  Database.AllowsCallouts {


    List<Account> accsToProcess = new List<Account>();
    
    global Batch_CalculateAccountGeocodes (List<Account> accounts){
    
        accsToProcess = accounts;
    }
    
     global Iterable<sObject> start(Database.BatchableContext BC){
        return accsToProcess ;
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        
        GeocodeExtractor.extractGeocode(scope);
    }
    
    global void finish(Database.BatchableContext BC){
    }
}