/*--------------------------------------------------------------------------
   Class: Generic_EmailImport 
    
   Class Description: 
   Email service class. Hanldles inbound email. Based on the configuration
   setting it process the attached csv file in batches and upsert records in data base.
      
      Date          Whom        Change #    
   ===========    ========    ============ 
   14-Nov-2017      Ayan      This class is implemented for dynamic email load.
                 
--------------------------------------------------------------------------*/
global class Generic_EmailImport implements Messaging.InboundEmailHandler {

  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope env) {

    Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
    //Get attached content on email
    Messaging.InboundEmail.BinaryAttachment[] emailAttachment = email.binaryAttachments;
    //Process through email attachment
    if (emailAttachment != null) { 
    
        Database.executeBatch(new EmailLoadBatch(emailAttachment[0].Body.toString(),email));
                        
    } // End "if (emailAttachment != null)"
    else{
          Database.executeBatch(new EmailLoadBatch(null,email));
     }
    return result;
  } // End "global Messaging.InboundEmailResult"
       
} // End "Generic_EmailImport"