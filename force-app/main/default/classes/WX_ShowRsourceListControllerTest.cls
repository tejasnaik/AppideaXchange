@isTest
public class WX_ShowRsourceListControllerTest {
    public static testMethod void WX_ShowRsourceListControllerTestMethod(){
        WX_ShowResourceListController.getResourceListOnDate('2017-06-07');
        WX_ShowResourceListController.getResourceListOnDate('');
        
    }

}