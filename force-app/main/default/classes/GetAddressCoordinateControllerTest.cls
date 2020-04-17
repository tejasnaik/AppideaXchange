@isTest
public class GetAddressCoordinateControllerTest {
   
    public static TestMethod void Unit()
    {
        String json='{"AddressLine1":"8401 MEMORIAL LN","AddressLine2": "APT 7323","City": "TX","State": "PLANO","CountryCode": "USA","PostalCode": "75024","latitude":51.505,"longitude":-0.09}';
        Test.setMock(HttpCalloutMock.class, new GetAddressCoordinateControllerMOCK());
        Test.startTest();
        GetAddressCoordinateController.initMe(json);
        Test.stopTest();
    }
}