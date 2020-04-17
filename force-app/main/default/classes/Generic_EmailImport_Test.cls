@isTest(seeAllData=false)
public class Generic_EmailImport_Test{
      public static testMethod void TestGeneric_EmailImport_method1(){
    
        //creating account
        Account acc = new Account();
        acc.Industry='Banking';
        acc.Name='Abc';
        acc.AccountNumber = '123456';
        acc.AccountSource='Other';
        insert acc;
        Account acc1 = new Account();
        acc1.Industry='Banking';
        acc1.Name='Abc';
        acc1.AccountNumber = '123457';
        acc1.AccountSource='Other';
        insert acc1;
     
        // create a new email 
       Generic_EmailImport emilImport= new Generic_EmailImport();
       Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

       // setup the data for the email
      email.subject = 'Account Test Class Load';
      email.fromAddress = 'testaddress@email.com';
      email.fromname = 'FirstName LastName';
      
      // add an Binary attachment
      Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
           
      
      String data = 'Account Name,Account Source,Account Number,End Date,Account Industry\n'+PARSER.CRLF+ 'Abc,Other,123457,20/2016/07,Banking\n'+PARSER.CRLF;
      attachment.body = blob.valueOf(data);
      attachment.fileName = 'textfileone.csv';
      email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
      
       // call the email service class and test it with the data in the testMethod
       Test.startTest();
       Generic_EmailImport testInbound=new Generic_EmailImport();
       testInbound.handleInboundEmail(email, env);     
     
      Test.stopTest();    
      } 
      
      public static testMethod void TestGeneric_EmailImport_method2(){
    
        //creating account
        Account acc = new Account();
        acc.Industry='Banking';
        acc.Name='Abc';
        acc.AccountNumber = '123456';
        acc.AccountSource='Other';
        insert acc;
        Account acc1 = new Account();
        acc1.Industry='Banking';
        acc1.Name='Abc';
        acc1.AccountNumber = '123457';
        acc1.AccountSource='Other';
        insert acc1;
     
        // create a new email 
       Generic_EmailImport emilImport= new Generic_EmailImport();
       Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

       // setup the data for the email
      email.subject = 'Account Test Class Load';
      email.fromAddress = 'testaddress@email.com';
      email.fromname = 'FirstName LastName';
      
      // add an Binary attachment
      Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
           
      
      String data = 'Account Name,Account Source,Account Number,End Date,Account Industry\n'+PARSER.CRLF+ 'Abc,Other,123457,20/2016/07,Banking\n'+PARSER.CRLF;
      attachment.body = blob.valueOf(data);
      attachment.fileName = 'textfileone.csv';
      email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
      
       // call the email service class and test it with the data in the testMethod
       Test.startTest();
       Generic_EmailImport testInbound=new Generic_EmailImport();
       testInbound.handleInboundEmail(email, env);     
     
      Test.stopTest();    
      } 
      
      public static testMethod void TestGeneric_EmailImport_method3(){
    
        //creating account
        Account acc = new Account();
        acc.Industry='Banking';
        acc.Name='Abc';
        acc.AccountNumber = '666666';
        acc.AccountSource='';
        insert acc;
        
        Contact con = new Contact();
        con.Account=acc;
        con.FirstName = 'xyzFirst';
        con.LastName = 'XyZLast';
        con.Title='Conference';
        con.Department='TestDept';
        con.Email = 'xyzmail@mail.com';
        insert con;
     
        // create a new email 
       Generic_EmailImport emilImport= new Generic_EmailImport();
       Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
       
       // setup the data for the email
      email.subject = 'Account Test Class Load';
      email.fromAddress = 'testaddress@email.com';
      email.fromname = 'FirstName LastName';
      
      // add an Binary attachment
      Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
      
     
      
      String data = 'Account Name,Account Number,Account Source,End Date,Account Industry\n'+ PARSER.CRLF +'Abc,1234566,Conference,20/10/2017,Banking\n'+PARSER.CRLF;
      
      attachment.body = blob.valueOf(data);
     
      attachment.fileName = 'textfileone.csv';
      email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
     

       // call the email service class and test it with the data in the testMethod
       Test.startTest();
       Generic_EmailImport testInbound=new Generic_EmailImport();
       testInbound.handleInboundEmail(email, env);     
     
      Test.stopTest();    
      }   
       public static testMethod void TestGeneric_EmailImport_method4(){
    
        //creating account
        Account acc = new Account();
        acc.Industry='Banking';
        acc.Name='Abc';
        acc.AccountNumber = '666667';
        acc.AccountSource='';
        insert acc;
        
        Contact con = new Contact();
        con.Account=acc;
        con.FirstName = 'xyzFirst';
        con.LastName = 'XyZLast';
        con.Title='Conference';
        con.Department='TestDept';
        con.Email = 'xyzmail@mail.com';
        insert con;
     
        // create a new email 
       Generic_EmailImport emilImport= new Generic_EmailImport();
       Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
       
       // setup the data for the email
      email.subject = 'Account Test Class Load';
      email.fromAddress = 'testaddress@email.com';
      email.fromname = 'FirstName LastName';
      
      // add an Binary attachment
      Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
      
     
      
      String data = 'Account Name,Account Number,Account Source,End Date,Account Industry\n'+ PARSER.CRLF+'Abc,1234566,Conference,2016/07/08,Banking\n' +PARSER.CRLF;
      
      attachment.body = blob.valueOf(data);
     
      attachment.fileName = 'textfileone.csv';
      email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
     

       // call the email service class and test it with the data in the testMethod
       Test.startTest();
       Generic_EmailImport testInbound=new Generic_EmailImport();
       testInbound.handleInboundEmail(email, env);     
     
      Test.stopTest();    
      }   
     
     public static testMethod void readIETFRFC4180CSVValueTest() {
        String data = null;  // Placeholder for data to use in testing.
        
        System.debug(data = Parser.CRLF);
        new CSVReader.CSVValue('', false, Parser.CRLF)
                .assertEquals(CSVReader.readIETFRFC4180CSVValue(data));
        
        System.debug(data = '""' + Parser.CRLF);
        new CSVReader.CSVValue('', true, Parser.CRLF)
                .assertEquals(CSVReader.readIETFRFC4180CSVValue(data));
        
        System.debug(data = '"",asdf' + Parser.CRLF);
        new CSVReader.CSVValue('', true, Parser.COMMA)
                .assertEquals(CSVReader.readIETFRFC4180CSVValue(data));
        
        System.debug(data = ',asdf' + Parser.CRLF);
        new CSVReader.CSVValue('', false, Parser.COMMA)
                .assertEquals(CSVReader.readIETFRFC4180CSVValue(data));
        
        System.debug(data = '"' + Parser.CRLF + '",blah' + Parser.CRLF);
        new CSVReader.CSVValue(Parser.CRLF, true, Parser.COMMA)
                .assertEquals(CSVReader.readIETFRFC4180CSVValue(data));
        
        System.debug(data = '"""marty""","""chang"""' + Parser.CRLF);
        new CSVReader.CSVValue('"marty"', true, Parser.COMMA)
                .assertEquals(CSVReader.readIETFRFC4180CSVValue(data));
        
        System.debug(data = '"com""pli""cate' + Parser.CRLF + 'd"'
                + Parser.CRLF);
        new CSVReader.CSVValue('com"pli"cate' + Parser.CRLF + 'd', true, Parser.CRLF)
                .assertEquals(CSVReader.readIETFRFC4180CSVValue(data));
        
        System.debug(data = 'asdf' + Parser.CRLF);
        new CSVReader.CSVValue('asdf', false, Parser.CRLF)
                .assertEquals(CSVReader.readIETFRFC4180CSVValue(data));
    }
    public static testMethod void readIETFRFC4180CSVFileTest() {
      String data = 'abc,"def","g""h""i"' + Parser.CRLF + '"j' + Parser.CRLF
             + 'kl","m' + Parser.CRLF + 'n""o""",';
      
      List<List<String>> fileValues =
             CSVReader.readIETFRFC4180CSVFile(Blob.valueOf(data));
    }


}