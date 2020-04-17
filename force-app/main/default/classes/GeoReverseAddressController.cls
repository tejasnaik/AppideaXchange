/*
 *  Created By - 
 *  Des : Based on Latitue & Longitude hit the google api to found the address.
 */ 
public class GeoReverseAddressController {

    @AuraEnabled
    public static Map<String,String> getAddressData(String latitude,String longitude, String recrodId, 
                                                    boolean isShortName, String FieldAPI){
        Map<String,String> returnMap = new Map<String,String>();
        String finalAddress;
        try
        {
            if(latitude != null && Longitude != null && latitude != '' && Longitude != '' ){
                HttpRequest req = new HttpRequest();
                req.setMethod('GET');
                GeoLocationToAddress__c CS = GeoLocationToAddress__c.getOrgDefaults();
                String key = (cs !=null && cs.Key__c !=null)? cs.Key__c:'';
                String endPoint  = 'https://maps.googleapis.com/maps/api/geocode/json?key='+key+'&latlng='+latitude+','+longitude+'&sensor=true' ; 
                req.setEndpoint(endPoint);
                Http ht = new Http();
               // if(!Test.isRunningTest())
                //{ 
                    HttpResponse res = ht.send(req);
                    if(res.getStatus() == 'OK'){
                        if(res.getBody() != null && res.getBody() != '' && res.getBody().contains('formatted_address')){
                            returnMap.put('body',res.getBody());
                            Map<String, Object> meta = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                            List<Object>  m2=(List<Object>)meta.get('results');
                            List<Map<String, Object>> myMaps = new List<Map<String, Object>>();
                            for (Object obj : m2) {
                                myMaps.add((Map<String, Object>)obj);
                            }
                            if(myMaps != null && myMaps.size()>0 && myMaps[0].containsKey('formatted_address'))
                                finalAddress = ''+myMaps[0].get('formatted_address');
                            List<Object>  m22 =(List<Object>)myMaps[0].get('address_components');	                            
                            String addressF = '';
                            for(object x:m22){
                                String typeName =  isShortName?'short_name':'long_name';
                                String s = ''+((Map<String, Object>)x).get(typeName);
                                addressF += addressF==''? s:','+s;
                            }
                            returnMap.put('addressfull',addressF);
                            returnMap.put('address',finalAddress);
                            String returnString = saveAddress(recrodId,addressF,FieldAPI,latitude,Longitude);
                            if(returnString=='SAVED'){
                                returnMap.put('RECORDUPDATE', 'true');
                            }
                        }
                   // }   
                }
            }else{
                returnMap.put('MethodCall', 'true');
                returnMap.put('validInputs', 'false');
            }
        }catch(Exception e){
            throw new AuraHandledException('NSFW name detected.'+e.getMessage());
			returnMap.put('Exception e', e.getMessage()+'---'+e.getLineNumber());
        }
        return returnMap;
    }
    
    public static String saveAddress(String recrodId,String AddressValue,String FieldAPI,String latitude,String longitude){
        if(recrodId instanceOf Id){
            
            Id recrodIdActual = recrodId;
            String sObjName = recrodIdActual.getSObjectType().getDescribe().getName();
            sObject myObject = recrodIdActual.getSObjectType().getDescribe().getSObjectType().newSObject();
            
            myObject.put('Id', recrodIdActual);
            
            if(FieldAPI != null && FieldAPI !='')
            	myObject.put(FieldAPI, AddressValue);
            
            List<String> nowAddres = AddressValue.split(',');
            String street = '';
            if(nowAddres.size()>4){
                Integer loopV = nowAddres.size()-4;
                for(String s :  nowAddres){
                    if(loopV<1) break;
                    loopV--;
                    street +=street==''?s:','+s; 
                }
            }
            if(sObjName.equalsIgnoreCase('lead')){
                myObject.put('Street',street);
                if(nowAddres.size()>4){
                    myObject.put('city', nowAddres[nowAddres.size()-4]);
                    myObject.put('State', nowAddres[nowAddres.size()-3]);
                    myObject.put('Country',  nowAddres[nowAddres.size()-2]);
                    myObject.put('PostalCode', nowAddres[nowAddres.size()-1]);
                }
            }
            if(sObjName.equalsIgnoreCase('account')){
                myObject.put('BillingStreet',street);
                if(nowAddres.size()>4){
                    myObject.put('BillingCity', nowAddres[nowAddres.size()-4]);
                    myObject.put('BillingState', nowAddres[nowAddres.size()-3]);
                    myObject.put('BillingCountry',  nowAddres[nowAddres.size()-2]);
                    myObject.put('BillingPostalCode', nowAddres[nowAddres.size()-1]);
                    myObject.put('BillingLatitude',  Decimal.valueOf(latitude));
                    myObject.put('BillingLongitude', Decimal.valueOf(longitude));
                    
                }
            }
            update myObject;
            return 'SAVED';
        }else{
            return 'Record id is not valid Id.';
        }
        return '';
    }
    

    
}