@isTest
global class GetAddressCoordinateControllerMOCK  implements HttpCalloutMock{
    
    global HTTPResponse respond(HTTPRequest req) {
        if(req.getEndpoint().contains('googleapis')){
            // Create a fake response
            HttpResponse res = new HttpResponse();
            system.debug('------mock- g---');
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"results" : [ { "address_components" : [ { "long_name" : "7323", "short_name" : "7323", "types" : [ "subpremise" ] }, { "long_name" : "8401", "short_name" : "8401", "types" : [ "street_number" ] }, { "long_name" : "Memorial Lane", "short_name" : "Memorial Ln", "types" : [ "route" ] }, { "long_name" : "The Tribeca - Apartments", "short_name" : "The Tribeca - Apartments", "types" : [ "neighborhood", "political" ] }, { "long_name" : "Plano", "short_name" : "Plano", "types" : [ "locality", "political" ] }, { "long_name" : "Collin County", "short_name" : "Collin County", "types" : [ "administrative_area_level_2", "political" ] }, { "long_name" : "Texas", "short_name" : "TX", "types" : [ "administrative_area_level_1", "political" ] }, { "long_name" : "United States", "short_name" : "US", "types" : [ "country", "political" ] }, { "long_name" : "75024", "short_name" : "75024", "types" : [ "postal_code" ] } ], "formatted_address" : "8401 Memorial Ln #7323, Plano, TX 75024, USA", "geometry" : { "location" : { "lat" : 33.0924829, "lng" : -96.7974798 }, "location_type" : "ROOFTOP", "viewport" : { "northeast" : { "lat" : 33.0938318802915, "lng" : -96.79613081970851 }, "southwest" : { "lat" : 33.0911339197085, "lng" : -96.79882878029152 } } }, "place_id" : "Eiw4NDAxIE1lbW9yaWFsIExuICM3MzIzLCBQbGFubywgVFggNzUwMjQsIFVTQQ", "types" : [ "subpremise" ] } ], "status" : "OK" }');
            res.setStatusCode(200);
            return res;
            
        }else if(req.getEndpoint().contains('shippingapis')){
            HttpResponse res = new HttpResponse();
            system.debug('------mock----');
            res.setHeader('Content-Type', 'application/xml');
            res.setBody('<?xml version="1.0" encoding="UTF-8"?><AddressValidateResponse><Address><Address1>APT 7323</Address1><Address2>8401 MEMORIAL LN</Address2><City>PLANO</City><State>TX</State><Zip5>75024</Zip5><Zip4>2291</Zip4></Address></AddressValidateResponse>');
            res.setStatusCode(200);
            return res;
        }
        
         return null;
    }
}