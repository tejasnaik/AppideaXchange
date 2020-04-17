@isTest
public class HeatMapClassTest {
    
    static testMethod void newListTest(){
        List<String> objNames = HeatMapClass.newList();
        for(Integer i=0;i<objNames.size();i++){
            System.debug('Object List '+objNames);
        }
        List<String> selString = new List<String>();
        for(String selObj :objNames){
            if(selObj.equals('Account')){
                selString.add(selObj);
            }
            if(selObj.equals('Contact')){
                selString.add(selObj);
            }
            if(selObj.equals('Lead')){
                selString.add(selObj);
            }
        }
        Account acc = new Account(Name='Acc1',BillingCountry='USA',BillingState='NC',BillingLatitude=35.383045,BillingLongitude=-80.001141);
        insert acc;
        Contact cont = new Contact(LastName='Cont1', MailingCountry='USA',MailingState='NC',MailingLatitude=35.383045,MailingLongitude=-80.001141);
        insert cont;
        Lead ld = new Lead(LastName='Lead1', Company='CTS', Country='USA', State='NC', Latitude=35.383045, Longitude=-80.001141);
        insert ld;
        String ac = 'Account';
        String con = 'Contact';
        String lea = 'Lead';
        
        List<String> billCountryList = new List<String>();
        List<Account> billCountry = new List<Account>();
        if(selString[0].equals('Account')){
            billCountry = [Select BillingCountry from Account where BillingCountry!=null and id =:acc.Id];
            for(Account a : billCountry){
                String s = a.BillingCountry;
                billCountryList.add(s);
            }
        }
        List<Contact> mailCountry = new List<Contact>();
        if(selString[0].equals('Contact')){
            mailCountry = [Select MailingCountry from Contact where MailingCountry!=null and id =:cont.Id];
            for(Contact c : mailCountry){
                String s = c.MailingCountry;
                billCountryList.add(s);
            }
        }
        List<Lead> Country = new List<Lead>();
        if(selString[0].equals('Lead')){
            Country = [Select Country from Lead where Country!=null and id =:ld.Id];
            for(Lead l : Country){
                String s = l.Country;
                billCountryList.add(s);
            }
        }
        system.debug('billCountryList: '+billCountryList);
        
        List<String> billStateList = new List<String>();
        List<Account> billState = new List<Account>();
        if(selString[0].equals('Account')){
            billState = [Select BillingState from Account where BillingState!=null and id =:acc.Id];
            for(Account a : billState){
                String s = a.BillingState;
                billStateList.add(s);
            }
        }
        List<Contact> mailState = new List<Contact>();
        if(selString[0].equals('Contact')){
            mailState = [Select MailingState from Contact where MailingState!=null and id =:cont.Id];
            for(Contact c : mailState){
                String s = c.MailingState;
                billStateList.add(s);
            }
        }
        List<Lead> State = new List<Lead>();
        if(selString[0].equals('Lead')){
            State = [Select State from Lead where State!=null and id =:ld.Id];
            for(Lead l : State){
                String s = l.State;
                billStateList.add(s);
            }
        }
        system.debug('billStateList: '+billStateList);
        
        List<Account> sObjLis = new List<Account>();
        if(selString[0].equals('Account')){
            sObjLis = [select id, name, BillingLatitude, BillingLongitude from Account WHERE BillingLatitude != NULL AND BillingLongitude != NULL AND BillingCountry =:billCountryList[0] AND BillingState =:billStateList[0] and id =:acc.Id];
        }
        system.debug('sObjLis: '+sObjLis);
        
        List<String> objCountryA = HeatMapClass.showFields(ac);
        List<String> objCountryC = HeatMapClass.showFields(con);
        List<String> objCountryL = HeatMapClass.showFields(lea);
       /* List<String> objStateA = HeatMapClass.showFieldState(ac);
        List<String> objStateC = HeatMapClass.showFieldState(con);
        List<String> objStateL = HeatMapClass.showFieldState(lea);*/
        List<SObject> objAllA = HeatMapClass.findAll(ac,'USA');
        List<SObject> objAllC = HeatMapClass.findAll(con,'USA');
        List<SObject> objAllL = HeatMapClass.findAll(lea,'USA');
    }
    
    static testMethod void fetchVfPageUrlTest(){
        String vfUrl = HeatMapClass.fetchVfPageUrl();
    }
    
}