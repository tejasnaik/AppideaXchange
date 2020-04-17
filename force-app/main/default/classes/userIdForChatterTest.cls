@isTest
public class userIdForChatterTest {
    private static testMethod void userIDTest(){
        User userObj = FlashUtilityClass.createUser(true);
        System.runAs(userObj){
            System.assert(userIdForChatter.userID()!=null);
        }
    }
}