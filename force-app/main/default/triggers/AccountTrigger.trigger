trigger AccountTrigger on Account   (after insert,after update) {
     
    if(AccountTriggerHandler.BYPASS_ACCOUNT_TRIGGER )
        return;
        
    //checking for action type
    if(Trigger.isAfter) {
        
        //Checking for event
        if(Trigger.isInsert || Trigger.isUpdate) {
           
            AccountTriggerHandler.getAccountGeolocations(Trigger.New);
        }
    } 
}