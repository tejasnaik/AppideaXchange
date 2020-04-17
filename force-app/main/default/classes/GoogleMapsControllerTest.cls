@isTest
public class GoogleMapsControllerTest {
	
    static testMethod void testFunctionality(){
        
        String res = GoogleMapsController.getAddressAutoComplete('jaipur', 'city');
		System.assert(res == '');
    }  
}