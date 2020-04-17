public class userIdForChatter {
    @AuraEnabled
    public static User userID()
    {
        //User us = new User();
        User us = [select id,SmallPhotoUrl,Name from User where id =:UserInfo.getUserId()];
        return us;
    }

}