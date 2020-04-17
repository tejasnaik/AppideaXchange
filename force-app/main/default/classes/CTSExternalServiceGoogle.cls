@RestResource(urlMapping='/googleApigetAddress/*')
global without sharing class CTSExternalServiceGoogle {
    
    @HttpPost
    global static String doPost(String Latitude, String Longitude , String googleKey , String isFilter, String isShortName,String getAllBody){
        RestRequest req = RestContext.request;
        String postRedirectPath = (req ==null)?'Install':req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        String returnString = getAddress(Latitude,Longitude,googleKey,isFilter,isShortName,getAllBody);
        return returnString;
    }
    
    @HttpGet
    global static String doGet(){
       // return 'hello';
        RestRequest req = RestContext.request;
        String Latitude  = RestContext.request.params.get('Latitude');
        String Longitude = RestContext.request.params.get('Longitude');
        String googleKey = RestContext.request.params.get('googleKey');
        String isFilter  = ''+RestContext.request.params.get('isFilter');
        String isShortName = ''+RestContext.request.params.get('isShortName');
        String getAllBody = ''+RestContext.request.params.get('getAllBody');
        String postRedirectPath = (req ==null)?'custom':req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        //return Latitude;
        String returnString = getAddress(Latitude,Longitude,googleKey,isFilter,isShortName,getAllBody);
        return returnString;
    }
    
    
    private static String getAddress(String Latitude, String Longitude , String googleKey , String isFilter, String isShortName,String getAllBody){
        	String returnString = '';
        	String endPoint  = 'https://maps.googleapis.com/maps/api/geocode/json?key='+googleKey+'&latlng='+Latitude+','+Longitude+'&sensor=true' ; 
	        HttpRequest req = new HttpRequest();
            req.setMethod('GET');
         	req.setEndpoint(endPoint);
            Http ht = new Http();
        	HttpResponse res = ht.send(req);
            if(res.getStatus() == 'OK'){
				   if(res.getBody() != null && res.getBody() != '' && res.getBody().contains('formatted_address')){
                          Map<String, Object> meta = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                          List<Object>  m2=(List<Object>)meta.get('results');
                          List<Map<String, Object>> myMaps = new List<Map<String, Object>>();
                          for (Object obj : m2) {
                                myMaps.add((Map<String, Object>)obj);
                          }
                       	  String finalAddress;
                          if(myMaps != null && myMaps.size()>0 && myMaps[0].containsKey('formatted_address'))
                                finalAddress = ''+myMaps[0].get('formatted_address');
                          List<Object>  m22 =(List<Object>)myMaps[0].get('address_components');	                            
                          String addressF = '';
                            for(object x:m22){
                                String typeName =  (isShortName != null && isShortName=='true')?'short_name':'long_name';
                                String s = ''+((Map<String, Object>)x).get(typeName);
                                addressF += addressF==''? s:','+s;
                            }
                       		if(getAllBody != null && getAllBody =='true'){
                       			returnString = 'BODYSTART='+res.getBody()+'BODYEND';
                           		returnString += 'ADDRESSFULLSTART'+addressF+'ADDRESSFULLEND';
                                returnString += 'FINALADDRESSFULLSTART'+finalAddress+'FINALADDRESSFULLSTART';
                       		}else
								returnString = ''+finalAddress+'';
                    }
            }else{
                returnString = 'ERROR';
            }
        
        	return returnString;
    }
    
	
}