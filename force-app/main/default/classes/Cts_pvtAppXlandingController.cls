/* 
*   Created By : Ashlekh Gera
*  Purpose - To get the genric component for custom app exchange application.  
*/

public without sharing class Cts_pvtAppXlandingController {
    
    
    /* Get the Options of the field by describe call*/
    @AuraEnabled
    public static OptionsWrapper getfieldOptions()
    {
        OptionsWrapper ow = new OptionsWrapper();
        try
        {
            List<Schema.PicklistEntry> picklistEntries = asb_App__c.Categories__c.getDescribe().getPicklistValues();
            
            for (Schema.PicklistEntry ple : picklistEntries){ 
                if(ple.getLabel() !=null && ple.getLabel() !='')
                ow.Categories.add(ple.getLabel());
            }
            
            PicklistEntries = asb_App__c.AppType__c.getDescribe().getPicklistValues();
            for (Schema.PicklistEntry ple : picklistEntries) {
                if(ple.getLabel() !=null && ple.getLabel() !='')
                ow.types.add(ple.getLabel());
            }
        
        }catch(Exception e){
            throw new AuraHandledException('getfieldOptions : Getting Error : '+e.getLineNumber()+e.getMessage());
        }
        return ow;
    }
    
    /*
    *   Method - getAppList() 
    *   Purpose - Get all the published applications based on category, types.
    *   Pagination is also achive by this.
    */
    @AuraEnabled
    public static string getAppList(String category,
                                    String types,
                                    String sortOrder, 
                                    Integer offSet,
                                    Integer limitNo,
                                    String searchKeyWord,
                                    String ComponentStatus)
    { 
        
        try
        {
            String query = 'SELECT AppType__c,Categories__c,DefaultListing__c,'
                +'FirstListedDate__c,InstallUrl__c,isActive__c,Languages__c,'
                +'LiveListings__c,LogoUrl__c,PageViewsAllTime__c,PageViews__c,'
                +'PopularityAllTime__c,Popularity__c,Status__c,Store__c,Id,Name,Store__r.Name'
                +' FROM asb_App__c where Status__c = \''+String.escapeSingleQuotes(ComponentStatus)+'\' ';
            
            String countQuery = 'Select count() from asb_App__c where Status__c = \'Published\'';
            
            string whereClaue = '';
            
            if(searchKeyWord != null && searchKeyWord !='')
                whereClaue = ' and Name like \'%'+String.escapeSingleQuotes(searchKeyWord)+'%\'';
            if(category != null && category !=''){
                whereClaue += ' and Categories__c includes (\''+String.escapeSingleQuotes(category)+'\')';
				//whereClaue += ' and Categories__c =:category ';
			}
            
            if(types != null && types !='')
                whereClaue += ' and AppType__c =:types';
            
            if(whereClaue != null && whereClaue !=''){
                query = query + ' '+ whereClaue;
                countQuery = countQuery + ' '+ whereClaue;
            }
           
            if(sortOrder != null && sortOrder !='') {
               
                if(sortOrder.contains('#')){
                   List<string> fld =   sortOrder.split('#');
                   String fldName   =   fld[1];
                   String fldValue  =   fld[0];
                   query +=' ORDER BY '+ fldName +' '+ fldValue; 
                }else{
                	query +=' ORDER BY name '+ sortOrder ; 
                }
            }
            
            
            Integer totalRecords = Database.countQuery(countQuery);
            query += ' limit '+limitNo+' OFFSET '+offSet;
            
            List<asb_App__c> res = Database.query(query);
            //List<String> attId = new List<String>();
            
            if(res ==null || res.size()==0)
                return null;
            
            Map<String,String> appAttIds = new Map<String,String>();
            for(asb_App__c d: res){
                if(d.LogoUrl__c != null && d.LogoUrl__c.trim() !='' && d.LogoUrl__c.contains('file=')){
                    String rid = d.LogoUrl__c.split('file=')[1];
                    appAttIds.put(d.id,rid);
                    //attId.add(rid);
                }
            }
            
            List<applicationWrapper> awReturn = new List<applicationWrapper>();
            
            Map<String,Attachment> mapatt = new Map<string,Attachment>();
            if(appAttIds != null && appAttIds.size()>0)
                mapatt = new Map<string,Attachment>([select id,Body from Attachment where id in:appAttIds.values()]);
            
            for(asb_App__c ap : res){
                ApplicationWrapper awLocal = new ApplicationWrapper();
                awLocal.res = ap;
                if(appAttIds.containsKey(ap.id)){
                    string atid = appAttIds.get(ap.id);
                    if(mapatt.containsKey(atid)){
                        awLocal.bl =mapatt.get(atid).body;
                    }
                }
                awReturn.add(awLocal);
            }
            
            ApplicationHolderWrapper ahw = new ApplicationHolderWrapper();
            ahw.queryTEST = query;
            ahw.awReturn = awReturn;
            ahw.totalRecords = totalRecords;
            return  JSON.serialize(ahw);   
            
        }catch(Exception e){
            throw new AuraHandledException('getAppList : Getting Error : '+e.getLineNumber()+e.getMessage());
        }
        return 'ERROR';
    }
    
    
    @AuraEnabled
    public static string submitRating(Decimal ratingValue, String listingId,String UserId, String comingFrom){
        
        //return 'SUCCESS';
        if(listingId instanceOf id && ratingValue !=null )
        {
            try
            {
                UserId = (UserId == null || UserId =='')?UserInfo.getUserId():UserId;
                if(comingFrom == 'COMPONENT'){
                    return submitRatingAPI(ratingValue,listingId,UserId);
                }
                else
                {
                    CogniAppEx__APP_Rating__c ratingInstance = new CogniAppEx__APP_Rating__c(CogniAppEx__Listing_App__c = listingId,
                                                                                                 CogniAppEx__User__c = UserId,
                                                                                                 CogniAppEx__User_Rating__c =ratingValue );
                    insert ratingInstance;
                }
                
            }
            catch(Exception e)
            {
                throw new AuraHandledException('submitRating : Getting Error : '+e.getLineNumber()+e.getMessage()+listingId+'--'+ratingValue+UserId);
            }
        }
        else
        {
            return 'ERROR';
        }
        return 'SUCCESS';        
    }
    
    
     private static string submitRatingAPI(Decimal ratingValue, String listingId,String UserId)
     {
        
        REST_API_Setting__mdt restAPISetting = Cts_AppXUtility.getCustomMetadata('Notification_REST_API_Config');
        if(restAPISetting != null && restAPISetting.Is_Active__c) 
        {
            try
            {
                String body = '{"listingId":"'+listingId+'","userId":"'+UserId+'","body":"'+ratingValue+'","type":"submitRating","extraData":""}';
                HttpRequest hr = Cts_AppXUtility.getRequest(restAPISetting.REST_Endpoint__c + '/v1/submitRating','POST', 'application/json', body);
                Http htp = new Http();
                if(!Test.isRunningTest()){
                    HttpResponse res = htp.send(hr);
                    return res.getStatus()=='OK'?'SUCCESS':res.getBody(); 
                    //return res.getBody();
                }else{
                    return '';
                }
            }
            catch(Exception e){}
        }
        return 'SUCCESS'; 
     }
    
    //Get Listing record to show detail of the component
    @AuraEnabled
    public static string getListing(String AppId, String ListingId)
    {   
        try
        {
            
            String query = 'SELECT Name,asb_App__c,asb_App__r.CogniAppEx__Hours_Saved__c,Description__c,isDefaultAppListing__c,'
                +'Language__c,ListedDate__c,PageViews__c,PopularityAllTime__c,Popularity__c,Requirements__c,Status__c,Tagline__c,Id,'
                +' (select id, Name, Location__c from ListingAssets__r ),(select CogniAppEx__User__c,CogniAppEx__User_Rating__c from App_Ratings__r) FROM asb_Listing__c';
            query += ' Where asb_App__c =:AppId and Id =:ListingId ';
            List<sObject> resultData = Database.query(query);
            
            /*Here we are creating activity history record*/
            if(ListingId instanceof Id ){
                //inserting log activities for page hits here 
                logActivity(ListingId,'PageView');
            }
             
            return JSON.serialize(resultData);
        }catch(Exception e){
            throw new AuraHandledException('getListing : Getting Error : '+e.getLineNumber()+e.getMessage());
        }
    }
    
    
    
    
    @AuraEnabled
    public static string recordInstallActivity(String AppId, String ListingId){
        try{
            logActivity(ListingId,'Install');
            return 'SUCCESS';
        }catch(Exception e){}
        return 'BYPASS';    
    }
    
    
    
    /*
        Call out to create activities for page hit.
        Chatter user is not able to perform DML so call out is required.
        activityType = PageView or Install
    */
    private static string logActivity(Id listingId, String activityType)
    {
        REST_API_Setting__mdt restAPISetting = Cts_AppXUtility.getCustomMetadata('Notification_REST_API_Config');
        if(restAPISetting != null && restAPISetting.Is_Active__c) {
            try{
                String body = '{"listingId":"'+listingId+'","userId":"'+UserInfo.getUserId()+'"}';
                HttpRequest hr =Cts_AppXUtility.getRequest(restAPISetting.REST_Endpoint__c + '/'+activityType,'POST', 'application/json',body);
                Http htp = new Http();
                if(!Test.isRunningTest()){
                    HttpResponse res = htp.send(hr);
                    return res.getBody();
                }else{
                    return '';
                }
                
            }catch(Exception e){}
        }
        return '';
        
    }
    
    public class ApplicationHolderWrapper{
        @AuraEnabled
        public List<applicationWrapper> awReturn ;
        @AuraEnabled
        public Integer totalRecords;
         @AuraEnabled
        public String  queryTEST;
        public ApplicationHolderWrapper(){
             awReturn = new List<applicationWrapper>();
             totalRecords = 0;
        }
    }
    
    public class ApplicationWrapper{
        @AuraEnabled
        public asb_App__c res;
        @AuraEnabled
        public string atthBase;
        @AuraEnabled
        public blob bl;
       
        
        
        public applicationWrapper(){}    
    }
    
    /* Filter option list */
    public class OptionsWrapper{
        @AuraEnabled
        public List<String> Categories;
        @AuraEnabled
        public List<String> types;
        @AuraEnabled
        public String userId;
        
        public optionsWrapper(){
            Categories = new List<String>();
            types = new List<String>();
            userId = UserInfo.getUserId();
        }
    }
    
}