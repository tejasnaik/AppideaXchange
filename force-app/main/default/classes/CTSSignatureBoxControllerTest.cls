@isTest
public class CTSSignatureBoxControllerTest {
	
    private static testmethod void  unitTest(){
        Map<String,object> returnMap = CTSSignatureBoxController.signDocument( null, 'fileName', 'base64Data',  'jpg' ,'');
        system.assertEquals(returnMap.get('isSuccess'),false);
        Account acc = new Account();
        acc.name ='TESt';
        insert acc;
        returnMap = CTSSignatureBoxController.signDocument( acc.id, 'fileName', 'base64Data',  'jpg' ,'');
    }
    
}