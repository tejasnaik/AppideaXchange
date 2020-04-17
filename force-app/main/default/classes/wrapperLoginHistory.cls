public class wrapperLoginHistory {
     @AuraEnabled
    public List<User> userInfo ; 
     @AuraEnabled
    public List<LoginHistory> logList  ; 
    
    public wrapperLoginHistory()
    {
        this.userInfo = userInfo;
        this.logList = logList;
    }
    
}