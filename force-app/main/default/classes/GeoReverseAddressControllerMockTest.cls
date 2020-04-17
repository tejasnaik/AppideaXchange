global class GeoReverseAddressControllerMockTest  implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        System.assert(req.getEndpoint().contains('google'));
        System.assertEquals('GET', req.getMethod());
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(getdata());
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
    
    private static string getdata(){
        String b = '{"results" : [{"address_components" : [{"long_name" : "Ratan Dugad Marg","short_name" : "Ratan Dugad Marg","types" : ';
        b += '[ "route" ]},{"long_name" : "Sector 6","short_name" : "Sector 6","types" : [ "political", "sublocality", ';
        b += '"sublocality_level_2" ]},{"long_name" : "Jawahar Nagar","short_name" : "Jawahar Nagar",';
        b += '"types" : [ "political", "sublocality", "sublocality_level_1" ]},{"long_name" : "Jaipur","short_name" : "Jaipur",';
        b += '"types" : [ "locality", "political" ]},{"long_name" : "Jaipur","short_name" : "Jaipur",';
        b += '"types" : [ "administrative_area_level_2", "political" ]';
        b += '},{"long_name" : "Rajasthan","short_name" : "RJ","types" : [ "administrative_area_level_1", "political" ]},';
        b += '{"long_name" : "India","short_name" : "IN","types" : [ "country", "political" ]},{"long_name" : "302004","short_name"';
        b += ': "302004","types" : [ "postal_code" ]}],"formatted_address" : "Ratan Dugad Marg, Sector 6, Jawahar Nagar, Jaipur, Rajasthan 302004, India",';
        b += '"geometry" : {"bounds" : {"northeast" : {"lat" : 26.889618,"lng" : 75.8363774},';
        b += '"southwest" : {"lat" : 26.8892814,"lng" : 75.83604219999999}},"location" : {"lat" : 26.8894505,"lng" : 75.83620879999999},';
        b += '"location_type" : "GEOMETRIC_CENTER","viewport" : {"northeast" : {"lat" : 26.8907986802915,"lng" : 75.8375587802915},';
        b += '"southwest" : {"lat" : 26.8881007197085,"lng" : 75.8348608197085}}},"place_id" : "ChIJl4HYC-62bTkRiI6oEjPRkoQ","types" : [ "route" ]},{"address_components" : [{"long_name" : "Sector 4","short_name" : "Sector 4","types" : [ "political", "sublocality", "sublocality_level_2" ]},{"long_name" : "Jawahar Nagar","short_name" : "Jawahar Nagar","types" : [ "political", "sublocality", "sublocality_level_1" ]},{"long_name" : "Jaipur","short_name" : "Jaipur",';
        b += '"types" : [ "locality", "political" ]},{"long_name" : "Jaipur","short_name" : "Jaipur","types" : [ "administrative_area_level_2", "political" ]},';
        b += '{"long_name" : "Rajasthan","short_name" : "RJ","types" : [ "administrative_area_level_1", "political" ]},{"long_name" : "India",';
        b += '"short_name" : "IN","types" : [ "country", "political" ]},{"long_name" : "302004","short_name" : "302004","types" : ';
        b += '[ "postal_code" ]}],"formatted_address" : "Sector 4, Jawahar Nagar, Jaipur, Rajasthan 302004, India","geometry" :';
        b += '{"bounds" : {"northeast" : {"lat" : 26.8908227,"lng" : 75.8378551},"southwest" : {"lat" : 26.882263,"lng" : 75.8293132}},';
        b += '"location" : {"lat" : 26.8859553,"lng" : 75.8335417},"location_type" : "APPROXIMATE","viewport" : {"northeast" : ';
        b += '{"lat" : 26.8908227,"lng" : 75.8378551},"southwest" : {"lat" : 26.882263,"lng" : 75.8293132}}},"place_id" : "ChIJ_4jcq_O2bTkRbxnF8MUhGKA",';
        b += '"types" : [ "political", "sublocality", "sublocality_level_2" ]}],"status" : "OK"}';
        return b;
    }
}