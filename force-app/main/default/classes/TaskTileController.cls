public class TaskTileController {
    public Static map<String, Schema.SObjectField> fieldMapVar;
    public Static void getFieldMapDetails(String objName){
        Schema.DescribeSObjectResult dsor = Schema.describeSObjects(new String[]{objName})[0];
		fieldMapVar = dsor.fields.getMap();
    }
    @AuraEnabled
    public static list<TileWrapper> getTileDetails(list<String> fields, String objName, 
                                                   String imageField, String taskRange, list<String> fieldsLabelMap){
        //Populate Field Map
        TaskTileController.getFieldMapDetails(objName);
        //Fetch tasks
        list<AggregateResult> arList;
        String whoIdIs = userInfo.getUserId();
        map<String,String> fieldsLabelMapVar = new map<String,String>();
        for(String rec: fieldsLabelMap){
            fieldsLabelMapVar.put(rec.split(':')[0],rec.split(':')[1]);
        }
                                                       
        if(taskRange=='overdue'){
            arList = [select whoId, count(id) tc from task where ActivityDate < Today and ownerId=:whoIdIs and whoId<>null group by whoId];
        }else if(taskRange=='Today'){
            arList = [select whoId, count(id) tc from task where ActivityDate = Today and ownerId=:whoIdIs and whoId<>null  group by whoId];
        }else if(taskRange=='Tomorrow'){
            arList = [select whoId, count(id) tc from task where ActivityDate = TOMORROW and ownerId=:whoIdIs and whoId<>null  group by whoId];
        }else if(taskRange=='ThisWeek'){
            arList = [select whoId, count(id) tc from task where ActivityDate > TOMORROW and ActivityDate = This_Week group by whoId];
        }else if(taskRange=='NextWeek'){
            arList = [select whoId, count(id) tc from task where ActivityDate = Next_Week group by whoId];
        }

        System.debug('**t range:'+taskRange);
        System.debug('**t arList:'+arList);
        
        map<Id,Integer> taskIdMap = new map<Id,Integer>();
        for(AggregateResult agRec: arList){
            taskIdMap.put((Id)agRec.get('whoId'),(Integer)agRec.get('tc'));
        }
        
        String fieldsAre='';
        for(String rec: fields){
         fieldsAre+=rec+',';   
        }
        SET<ID> keys = taskIdMap.keyset();
        fieldsAre=fieldsAre.removeEnd(',');
        String queryIs = 'select Id,'+fieldsAre+','+imageField+' from '+objName+' where Id IN ';
        queryIs+=':keys order by Name';
        
        list<TileWrapper> twList = new list<TileWrapper>();
        for(SObject rec: Database.query(queryIs)){
            //Set photo URL
            String imageLink=(String)rec.get(imageField);
            if(imageLink != null && imageLink.contains('</img>')){
                imageLink  = imageLink.substring(imageLink.indexOf('<img'));
                imageLink  = imageLink.substring(imageLink.indexOf('src="')+5,imageLink.indexOf('">'));
                imageLink  = imageLink.replace('&amp;','&');
            }else{
                imageLink = URL.getSalesforceBaseUrl().toExternalForm() + '/profilephoto/005/F';
            }
            //Populate Tile Wrapper records
            list<TileWrapperRecord> tempTwrList = new list<TileWrapperRecord>();
            for(String fieldRec: fields){
				String valueIs, labelIs;
                if(fieldMapVar.get(fieldRec)!=null && String.valueOf(fieldMapVar.get(fieldRec).getDescribe().getType())=='DATE'){
                    if(rec.get(fieldRec)!=null){
                    	Date dateValue = Date.valueOf(rec.get(fieldRec));
                        Integer day = dateValue.day(); 
                        Integer month = dateValue.month();
                        Integer year = dateValue.year();
                        DateTime dt = DateTime.newInstance(year,month,day);
                        valueIs = dt.format('dd MMM yyyy');
                    }
                }else{
                    valueIs = String.valueOf(rec.get(fieldRec));
                }
                tempTwrList.add(new TileWrapperRecord(fieldRec, 
                                                      (fieldsLabelMapVar.get(fieldRec)==null)?fieldMapVar.get(fieldRec).getDescribe().getLabel():fieldsLabelMapVar.get(fieldRec),
                                                      valueIs,
                               						  String.valueOf(fieldMapVar.get(fieldRec).getDescribe().getType())));
            }
            
            TileWrapper temptw = new TileWrapper(tempTwrList, taskIdMap.get(rec.Id), imageLink, (String) rec.get('Id'));
            twList.add(temptw);
        }
        return twList;
    }
    //Define wrapper to store Patient Information
    public class TileWrapper{
        @AuraEnabled
        public list<TileWrapperRecord> twr;
        @AuraEnabled
        public String recordId;
        @AuraEnabled
        public Integer taskCount;
         @AuraEnabled
        public String imageURL;
        public TileWrapper(list<TileWrapperRecord> twr, Integer taskCount, String imageLink, String recordId){
            this.twr=twr;
            this.taskCount=taskCount;
            imageURL = imageLink;
            this.recordId = recordId;
        }
    }
    public class TileWrapperRecord{
        @AuraEnabled
        public String key;
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;
        @AuraEnabled
        public String typeIs;
        public TileWrapperRecord(String key, String label, String value, String typeIs){
            this.key = key;
            this.label = label;
            this.value = value;
            this.typeIs = typeIs;
        }
    }
    @AuraEnabled
    public Static UserContextWrapper getUserContext(){
        String con = UserInfo.getUiThemeDisplayed();
        boolean isPortal = [select isPortalEnabled from User where Id = :userInfo.getUserId()].isPortalEnabled;
        UserContextWrapper uc = new UserContextWrapper();
        uc.userContext=con;
        uc.isPortal=isPortal;
        return uc;
    }
    public class UserContextWrapper{
        @AuraEnabled
        public String userContext;
        @AuraEnabled
        public boolean isPortal;
    }
}