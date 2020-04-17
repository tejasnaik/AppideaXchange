@isTest
public class GeoReverseAddressControllerTest {
	
    private static TestMethod void  unitTest1(){
        Lead l1 = new Lead(lastName='test',Company='test');
        insert l1;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GeoReverseAddressControllerMockTest());
        GeoReverseAddressController.getAddressData('10.2586','-45.5852',l1.id,true,null);
 		Test.stopTest();
    }
}