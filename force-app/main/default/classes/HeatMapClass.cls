public class HeatMapClass {
    
    //Retrieve list of custom objects
    @AuraEnabled
    public static List<String> newList() {
        List<String> objList = new List<String>();
        String ObjName = null;
        try{
            objList.add('---None---');
            List<Heat_Map_Object_Setup__mdt> customMetaObjList = [Select Object_Name__c from Heat_Map_Object_Setup__mdt where Object_Name__c!=null];
            if(customMetaObjList.size()>0){
                for(Heat_Map_Object_Setup__mdt hmos : customMetaObjList){
                    objList.add(hmos.Object_Name__c);
                }
            }
        }catch(Exception e){
            system.debug(e.getStackTraceString());   
        }
        return objList;
    }
    
    // Retrieve country from record
    @AuraEnabled
    public static List<String> showFields(String selectedObject){
        List<String> fieldCountryList = new List<String>();
        List<SObject> sObjList = new List<SObject>();
        Set<String> countryList = new Set<String>();
        String sObjectCountry = null;
        try{
            fieldCountryList.add('---None---');
            if(selectedObject.equalsIgnoreCase('Account')){
                sObjectCountry = 'Select BillingCountry from '+selectedObject+ ' where BillingCountry!=null';
            }
            else if(selectedObject.equalsIgnoreCase('Contact')){
                sObjectCountry = 'Select MailingCountry from '+selectedObject+ ' where MailingCountry!=null';
            }
            else if(selectedObject.equalsIgnoreCase('Lead')){
                sObjectCountry = 'Select Country from '+selectedObject+ ' where Country!=null';
            }
            sObjList = Database.query(sObjectCountry);
            String s = null;
            for(sObject sObj :sObjList){
                if(selectedObject.equalsIgnoreCase('Account')){
                    s = (String)sObj.get('BillingCountry');
                }else if(selectedObject.equalsIgnoreCase('Contact')){
                    s = (String)sObj.get('MailingCountry');
                }else if(selectedObject.equalsIgnoreCase('Lead')){
                    s = (String)sObj.get('Country');
                }
                countryList.add(s);
            }
            fieldCountryList.addAll(countryList);
        }catch(Exception e){
            system.debug(e.getStackTraceString());   
        }
        return fieldCountryList;
    }
    
    // Retrieve state from records
   /* @AuraEnabled
    public static List<String> showFieldState(String selectedObject){
        List<String> fieldStateList = new List<String>();
        List<SObject> sObjList = new List<SObject>();
        Set<String> stateList = new Set<String>();
        String sObjectState = null;
        try{
            fieldStateList.add('---None---');
            if(selectedObject.equalsIgnoreCase('Account')){
                sObjectState = 'Select BillingState from '+selectedObject+ ' where BillingState!=null';
            }
            else if(selectedObject.equalsIgnoreCase('Contact')){
                sObjectState = 'Select MailingState from '+selectedObject+ ' where MailingState!=null';
            }
            else if(selectedObject.equalsIgnoreCase('Lead')){
                sObjectState = 'Select State from '+selectedObject+ ' where State!=null';
            }
            sObjList = Database.query(sObjectState);
            String s = null;
            for(sObject sObj :sObjList){
                if(selectedObject.equalsIgnoreCase('Account')){
                    s = (String)sObj.get('BillingState');
                }
                else if(selectedObject.equalsIgnoreCase('Contact')){
                    s = (String)sObj.get('MailingState');
                }
                else if(selectedObject.equalsIgnoreCase('Lead')){
                    s = (String)sObj.get('State');
                }
                stateList.add(s);
            }
            fieldStateList.addAll(stateList);
        }catch(Exception e){
            system.debug(e.getStackTraceString());   
        }
        return fieldStateList;
    }
    */
    @AuraEnabled
    public static List<sObject> findAll(String selectedObjectA,String selectedCountryA /*, String selectedStateA*/) {
        List<sObject> sObjList = new List<sObject>();
        String sobjString = null;
        try{
            if(selectedCountryA!=null){
              //  if(selectedStateA!=null){
                    if(selectedObjectA!=null){
                        if(selectedObjectA.equalsIgnoreCase('Account')){
                            //sobjString = 'select id, name, BillingLatitude, BillingLongitude from ' +selectedObjectA+ ' WHERE BillingLatitude != NULL AND BillingLongitude != NULL AND BillingCountry = \''+selectedCountryA+ '\' AND BillingState =\''+selectedStateA + '\'';
                            sobjString = 'select id, name, BillingLatitude, BillingLongitude, NumberOfEmployees, BillingState from ' +selectedObjectA+ ' WHERE BillingLatitude != NULL AND BillingLongitude != NULL AND BillingCountry = \''+selectedCountryA+ '\' AND NumberOfEmployees != NULL ORDER BY NumberOfEmployees ASC';
                        }
                        else if(selectedObjectA.equalsIgnoreCase('Contact')){
                            sobjString = 'select id, name, MailingLatitude, MailingLongitude, MailingState from ' +selectedObjectA+ ' WHERE MailingLatitude != NULL AND MailingLongitude != NULL AND MailingCountry = \''+selectedCountryA+ '\'';
                        }
                        else if(selectedObjectA.equalsIgnoreCase('Lead')){
                            sobjString = 'select id, name, Latitude, Longitude, NumberOfEmployees, State from ' +selectedObjectA+ ' WHERE Latitude != NULL AND Longitude != NULL AND Country = \''+selectedCountryA+ '\' AND NumberOfEmployees != NULL ORDER BY NumberOfEmployees ASC';
                        }
                    }
                //}
            }
            sObjList = Database.query(sobjString);
        }catch(Exception e){
            system.debug(e.getStackTraceString());   
        }
        return sObjList;
    }
    
    @AuraEnabled
    public static String fetchVfPageUrl(){
        List<String> sVf = new List<String>();
        String sVfUrl = null;
        List<Heat_Map_VF_URL__mdt> vfPageUrl = [Select VF_Page_URL__c from Heat_Map_VF_URL__mdt where VF_Page_URL__c!=null];
        if(vfPageUrl.size()>0){
            for(Heat_Map_VF_URL__mdt hmvf : vfPageUrl){
                sVf.add(hmvf.VF_Page_URL__c);
            }
        }
        sVfUrl = sVf.get(0);
        return sVfUrl;
    }
}