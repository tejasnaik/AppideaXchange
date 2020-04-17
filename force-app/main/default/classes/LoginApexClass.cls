public class LoginApexClass 
{
    @AuraEnabled
    public static wrapperLoginHistory searchAll(Integer number_of_rows)
    {
        Integer no_of_rows = Integer.valueOf(number_of_rows);
        System.debug('number_of_rows : '+number_of_rows);
        wrapperLoginHistory wrapperLoginHistoryObj = new wrapperLoginHistory();
        wrapperLoginHistoryObj.logList = [SELECT LoginTime,Status,UserId FROM LoginHistory limit :no_of_rows];
        System.debug('wrapperLoginHistoryObj.logList : '+wrapperLoginHistoryObj.logList);
        List<Id> loginUserIdList = new List<Id>();
        for(LoginHistory LH : wrapperLoginHistoryObj.logList)
        {
            loginUserIdList.add(LH.UserId);
        }
        Map<Id,String> userIdNameMap = new Map<Id,String>();    
        for (User usr : [select id,Name from User where Id IN :loginUserIdList]) 
        {
            userIdNameMap.put(usr.Id , usr.Name);
        }
        
        wrapperLoginHistoryObj.userInfo = [select id,SmallPhotoUrl,Name from User where id IN :loginUserIdList];
        
        for(LoginHistory LogHistory : wrapperLoginHistoryObj.logList)
        {
            System.debug('LoginTime : '+LogHistory.LoginTime+' Status : '+LogHistory.Status+' name : '+userIdNameMap.get(LogHistory.UserId));
        }
        return wrapperLoginHistoryObj;
        
    }
    
    
    @AuraEnabled
    public static wrapperLoginHistory searchSuccess(Integer number_of_rows)
    {
        Integer no_of_rows = Integer.valueOf(number_of_rows);
        wrapperLoginHistory wrapperLoginHistoryObj = new wrapperLoginHistory();
        List<LoginHistory> allLogHistoryList = new List<LoginHistory>();
        List<LoginHistory> successLogHistoryList = new List<LoginHistory>();        
        allLogHistoryList = [SELECT LoginTime,Status,UserId FROM LoginHistory limit :no_of_rows];
        for(LoginHistory LH : allLogHistoryList)
        {
            if(LH.Status=='Success')
            {
                successLogHistoryList.add(LH);
            }        
        }
        wrapperLoginHistoryObj.logList =  successLogHistoryList;
        List<Id> loginUserIdList = new List<Id>();
        for(LoginHistory LH : wrapperLoginHistoryObj.logList)
        {
            loginUserIdList.add(LH.UserId);
        }
        Map<Id,String> userIdNameMap = new Map<Id,String>();    
        for (User usr : [select id,Name from User where Id IN :loginUserIdList]) 
        {
            userIdNameMap.put(usr.Id , usr.Name);
        }
        
        wrapperLoginHistoryObj.userInfo = [select id,SmallPhotoUrl,Name from User where id IN :loginUserIdList];
        
        for(LoginHistory LogHistory : wrapperLoginHistoryObj.logList)
        {
            System.debug('LoginTime : '+LogHistory.LoginTime+' Status : '+LogHistory.Status+' name : '+userIdNameMap.get(LogHistory.UserId));
        }
        return wrapperLoginHistoryObj; 
        
    }
    
    
    @AuraEnabled
    public static wrapperLoginHistory searchFailure(Integer number_of_rows)
    {
        Integer no_of_rows = Integer.valueOf(number_of_rows);
        wrapperLoginHistory wrapperLoginHistoryObj = new wrapperLoginHistory();
        List<LoginHistory> allLogHistoryList = new List<LoginHistory>();
        List<LoginHistory> failureLogHistoryList = new List<LoginHistory>();        
        allLogHistoryList = [SELECT LoginTime,Status,UserId FROM LoginHistory limit :no_of_rows];
        for(LoginHistory LH : allLogHistoryList)
        {
            if(LH.Status!='Success')
            {
                failureLogHistoryList.add(LH);
            }        
        }
        wrapperLoginHistoryObj.logList =  failureLogHistoryList;        
        List<Id> loginUserIdList = new List<Id>();
        for(LoginHistory LH : wrapperLoginHistoryObj.logList)
        {
            loginUserIdList.add(LH.UserId);
        }
        Map<Id,String> userIdNameMap = new Map<Id,String>();    
        for (User usr : [select id,Name from User where Id IN :loginUserIdList]) 
        {
            userIdNameMap.put(usr.Id , usr.Name);
        }
        
        wrapperLoginHistoryObj.userInfo = [select id,SmallPhotoUrl,Name from User where id IN :loginUserIdList];
        
        for(LoginHistory LogHistory : wrapperLoginHistoryObj.logList)
        {
            System.debug('LoginTime : '+LogHistory.LoginTime+' Status : '+LogHistory.Status+' name : '+userIdNameMap.get(LogHistory.UserId));
        }
        return wrapperLoginHistoryObj;
        
    }
}