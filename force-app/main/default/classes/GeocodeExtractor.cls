Public class GeocodeExtractor {
    
    public static void findGeocodes() {
        
        LIST<Account> accs = [SELECT id,BillingStreet,BillingAddress,BillingCity,
                          BillingCountry,BillingPostalCode,BillingState,Billinglatitude, 
                          billinglongitude  FROM Account limit 50];
                          
                          
        extractGeocode(accs);
    
    }
    public static List<Account> extractGeocode(List<Account> accs ) {
       
        List < Account > modifiedAccounts = new list <Account> ();
        List < Account > modifiedAccountsToReturn = new list <Account> ();
        for (Account a: accs) {
            String address = '';
            String cityCountryAdd = '';
            if (a.BillingStreet != null)
                address += a.BillingStreet + ', ';
            if (a.BillingCity != null) {
                address += a.BillingCity + ', ';
                cityCountryAdd += a.BillingCity + ' , ';
            }
            if (a.BillingState != null) {
                address += a.BillingState + ' ';
                cityCountryAdd +=  a.BillingState + ' ';
            }
            if (a.BillingPostalCode != null)
                address += a.BillingPostalCode + ', ';
            if (a.BillingCountry != null) {
                address += a.BillingCountry;
                cityCountryAdd +=  a.BillingCountry ;
            }
                
            address = EncodingUtil.urlEncode(address, 'UTF-8');
            cityCountryAdd =  EncodingUtil.urlEncode(cityCountryAdd, 'UTF-8');
        
            Try {
                GoogleJSONFormatter gro = callGoogleApex(address);
                System.Debug(gro.results.size());
                if(gro.results.size() > 0) {
                    double lat = gro.results[0].geometry.location.lat;
                    double lon = gro.results[0].geometry.location.lng;
                     a.BillingLatitude = lat;
                     a.BillingLongitude = lon;
                }
                
                GoogleJSONFormatter gro1 = callGoogleApex(cityCountryAdd);
                System.Debug(gro1.results.size());
                if(gro1.results.size() > 0) {
                    
                    double lat = gro1.results[0].geometry.location.lat;
                    double lon = gro1.results[0].geometry.location.lng;
        
                     a.Location__Latitude__s = lat;
                     a.Location__Longitude__s= lon;
                } 
                modifiedAccounts.add(a);
                
              }  catch (Exception e) {
              }
           
        }
        modifiedAccountsToReturn  = modifiedAccounts;
        
        try{
            AccountTriggerHandler.BYPASS_ACCOUNT_TRIGGER = true;
            update modifiedAccounts;
         
         }catch(Exception e) {}
         return modifiedAccountsToReturn  ;
    }
    
    
    public static GoogleJSONFormatter callGoogleApex(string address) {
    
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        GoogleJSONFormatter gro = new GoogleJSONFormatter();
        if (address != null) {
            req.setEndpoint('httpS://maps.googleapis.com/maps/api/geocode/json?address=' + address + '&sensor=false');
            req.setMethod('GET');
            req.setTimeout(6000);

            HttpResponse res = h.send(req);
            System.debug('@@@@@@@@@@@@@@@' + res.getBody());
            JSONParser parser = JSON.createParser(res.getBody());
            while(parser.nextToken() != null) {
                if(parser.getCurrentToken()==JSONToken.START_OBJECT){
                    gro = (GoogleJSONFormatter) parser.readValueAs(GoogleJSONFormatter.class);
                }    
            }    
         }
        return gro;
    }
}