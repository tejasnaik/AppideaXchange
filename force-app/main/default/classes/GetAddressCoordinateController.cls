/*
    Written By : Ashlekh Gera
    Description : This is a controller of image Map component to proivde functionality.
*/

public class GetAddressCoordinateController {
    
    //User id of USPS Account to validate the address.
    private static string USPS_UserId =system.label.USPS_UserId;
    private static string USPS_endpointURL ='http://production.shippingapis.com/ShippingAPI.dll?API=Verify&XML=';
    //Google API key to hit google API to get the coordinates 
    private static string  Google_API_Key = system.label.Google_API_Key1;
    private static string Google_EndPointURl ='https://maps.googleapis.com/maps/api/geocode/json?address=';
    
    //Deprecated method
    @AuraEnabled
    public static String initMe1(String AddressJSON) {return '';}
    
    
    /*
    *   Method Name - initMe
    *   Parameter  - String - AddressJSON ( contiain the address line 1 , address line 2 and so on. in JSON format)
    *   Description - COmponent call this function to show Map. 
    *   return - String - return a json which contain the coordinates to populate the MAP in component.
    */
    
    @AuraEnabled
    public static String initMe(String AddressJSON) {
        GetAddressCoordinateController.AddressWrapper enteredAddress = (GetAddressCoordinateController.AddressWrapper)JSON.deserialize(AddressJSON, GetAddressCoordinateController.AddressWrapper.class);
        AddressWrapper standartAddress =  verifyUSPS(enteredAddress);
        if (standartAddress == null || !String.isEmpty(standartAddress.errorMsg))      return null;
        
        if ( String.isEmpty(standartAddress.AddressLine2) ) {
            standartAddress.description = standartAddress.AddressLine1 + ', ' + standartAddress.city + ', ' + standartAddress.state + ', ' + standartAddress.postalCode;
        } else {
            standartAddress.description = standartAddress.AddressLine1 + ', ' + standartAddress.AddressLine2 + ', ' + standartAddress.city + ', ' + standartAddress.state + ', ' + standartAddress.postalCode;
        }
        
        
        //standartAddress.street = standartAddress.address1;
        
        String endpointURL = Google_EndPointURl + standartAddress.AddressLine1.replace(' ', '+') + ',+' + standartAddress.AddressLine2.replace(' ', '+') + ',+' + standartAddress.city.replace(' ', '+') + ',+' + standartAddress.state.replace(' ', '+') + '&key=' +Google_API_Key;
        String resJSONStr = invokeGoogle(endpointURL, 'GET');
        system.debug('resJSONStr>>>'+resJSONStr);
        Map< String, Object > resMap = (Map< String, Object >) JSON.deserializeUntyped(resJSONStr);
        String status = (String) resMap.get('status');

        if (!status.equals('OK')) {
            return null;
        }

        List< Object > results = (List< Object >) resMap.get('results');
        Map< String, Object > geometry = (Map< String, Object >) ((Map< String, Object >) results[0]).get('geometry');
        Map< String, Object > location = (Map< String, Object >) (geometry.get('location'));

        standartAddress.latitude = (Decimal) location.get('lat');
        standartAddress.longitude = (Decimal) location.get('lng');

        return  JSON.serialize(standartAddress);
        //return String.valueOf(standartAddress);
        
        //return '';
    } 
    
    /*
    *   Method Name - verifyUSPS
    *   Parameter  - AddressWrapper - address ( contiain the address line 1 , address line 2 and so on. in wrapper class format)
    *   Description - This fuction hit the USPS system to validate the address.
    *   return - AddressWrapper - return a correct address in wrapper class format.
    */
    
    
    public static AddressWrapper verifyUSPS(AddressWrapper address ) {
        System.debug('>>>01');
        String endpointURL = USPS_endpointURL +
            '<AddressValidateRequest USERID="' + USPS_UserId + '"> ' +
                '<Address> ' +
                    '<Address1>' + address.AddressLine1 + '</Address1> ' +
                    '<Address2>' + address.AddressLine2 + '</Address2> ' +
                    '<City>' + address.city + '</City> ' +
                    '<State>' + address.state + '</State> ' +
                    '<Zip5>' + address.postalCode + '</Zip5> ' +
                    '<Zip4></Zip4> ' +
                '</Address> ' +
            '</AddressValidateRequest>';
        String reqMethod = 'GET';
        
        Dom.Document xmlResDoc = invokeUSPS( endpointURL, reqMethod );
        
        system.debug('>>>>>'+xmlResDoc);
        if ( xmlResDoc == null ) {
            return null;
        }
        
        Dom.XMLNode xmlAddressValidateRequest = xmlResDoc.getRootElement();
        if ( xmlAddressValidateRequest == null ) {
            return null;
        }

        String errorMsg = checkErrorMsg( xmlAddressValidateRequest );
        if ( !String.isEmpty( errorMsg ) ) {
            AddressWrapper stardartizedAddress = new AddressWrapper();
            stardartizedAddress.errorMsg = errorMsg;
            return stardartizedAddress;
        }
        
        Dom.XMLNode xmlAddress = xmlAddressValidateRequest.getChildElement( 'Address', null );
        if ( xmlAddress == null ) {
            return null;
        }

        errorMsg = checkErrorMsg( xmlAddress.getChildElement( 'Error', null ) );
        if ( !String.isEmpty( errorMsg ) ) {
           AddressWrapper stardartizedAddress = new AddressWrapper();
            stardartizedAddress.errorMsg = errorMsg;
            return stardartizedAddress;
        }
        
        String validAddress1 = ( xmlAddress.getChildElement( 'Address1', null ) == null ) ? '' : xmlAddress.getChildElement( 'Address1', null ).getText();
        String validAddress2 = xmlAddress.getChildElement( 'Address2', null ).getText();
        String validCity = xmlAddress.getChildElement( 'City', null ).getText();
        String validState = xmlAddress.getChildElement( 'State', null ).getText();
        String validZipCode = xmlAddress.getChildElement( 'Zip5', null ).getText();
        
        AddressWrapper stardartizedAddress = new AddressWrapper();
        stardartizedAddress.AddressLine1 = validAddress2;
        stardartizedAddress.AddressLine2 = validAddress1;
        stardartizedAddress.city = validCity;
        stardartizedAddress.state = validState;
        stardartizedAddress.postalCode = validZipCode;
        
       
        return stardartizedAddress;
    }
    
    
     /*
    *   Method Name - invokeUSPS
    *   Parameter   -  endpointURL -  End point for the HTTP request.
                    -  method - Method type POST OR GEt for HTTP request.
    *   Description - This fuction help above method to hit the USPS system to validate the address.
    *   return - Dom.Document - return the result in Dom.Document format of request.
    */
    
    private static Dom.Document invokeUSPS( String endpointURL, String method ) {
        endpointURL = endpointURL.replace( '"', '%22' ).replace( ' ', '%20' ).replace( '<', '%3C' ).replace( '>', '%3E' );
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint( endpointURL );
        req.setMethod( method );
        
        Http http = new Http();
        HttpResponse res = http.send( req );
        Integer resStatus = res.getStatusCode();
        if ( resStatus < 200 || resStatus > 299 ) {
              return null;
        }
        return res.getBodyDocument();
    }
    
    //This is internal function to check the DOM elements of http response
    private static String checkErrorMsg( Dom.XMLNode xmlNode ) {
        if ( xmlNode == null ) {
            return '';
        } else if ( xmlNode.getName().equals( 'Error' ) ) {
            String errorDescription = xmlNode.getChildElement( 'Description', null ).getText();
            System.debug( '>>> ERROR - ' + errorDescription );
            return errorDescription;
        } else {
            return '';
        }
    }
    
    /*
    *   Method - invokeGoogle 
    *   Params - endpointURL -String - End points for google api.
    *            Method - String - methd type of http request.
    *   return - string - return the result of http request.
    *   Description - This function hit the GOOGLe API to get the coordinate of standard address.
    */
    public static String invokeGoogle( String endpointURL, String method ) {
        //endpointURL = endpointURL.replace( '"', '%22' ).replace( ' ', '%20' ).replace( '<', '%3C' ).replace( '>', '%3E' );
        HttpRequest req = new HttpRequest();
        req.setEndpoint( endpointURL );
        req.setMethod( method );
        
        Http http = new Http();
            HttpResponse res = http.send( req );
            Integer resStatus = res.getStatusCode();
            if ( resStatus < 200 || resStatus > 299 )   return '';
             
          return res.getBody();
    }
    
    //Wrapper class to hold the address
    public class AddressWrapper{
        public String AddressLine1;
        public String AddressLine2;
        public String City;
        public String State;
        public String CountryCode;
        public String PostalCode;
        public string errorMsg; 
        public Decimal latitude;
        public Decimal longitude;   
        public String description;
        public AddressWrapper(String AddressLine1,String AddressLine2,String City,String State,String CountryCode,String PostalCode){
            this.AddressLine1   = AddressLine1;
            this.AddressLine2   = AddressLine2;
            this.state = state;
            this.City = City;
            this.CountryCode = CountryCode;
            this.PostalCode = PostalCode;
            
        }
        
        public  AddressWrapper(){}
        
    }
}