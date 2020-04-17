/**
 * Written By : Ashlekh Gera
 * 
 * */
public class MultiSelectorController {
    
    @AuraEnabled
    public static OutPutWrapper onInit(String recordId,String objectName ,String fieldName )
    {
        String findTrough ='';
        String finder = '';
        if(recordId != null && recordId !='' ){
            findTrough = 'Keyprefix';
            finder = recordId.substring(0,3);
        }else {
            findTrough = 'object';
            finder = objectName;
        }
        
        OutPutWrapper opw = findObjectWithfield(findTrough,finder,fieldName);
        if(recordId != null &&  recordId != '')
        {
            List<sObject> objRes = Database.query('select id,'+ fieldName +' from '+opw.objectName +' where id=:recordId' );
            if(objRes != null && objRes.size()>0){
                String s = objRes[0].get(fieldName)!=null?''+ objRes[0].get(fieldName):'';
                if(s != null && s !=''){
                    opw.SelectedPicklist = s.split(';');
                    opw.adjustMent();
                }
            }
        }
        return opw;
        
    }
    
    
    private static OutPutWrapper findObjectWithfield(String way,String finder,string fieldName){
        
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        OutPutWrapper opw = new OutPutWrapper();
        for(String sObj : gd.keySet())
        {
            Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();
            opw.objectName =r.getName(); 
            String keyprefix = r.getKeyPrefix();
            if((way=='Keyprefix' && keyprefix == finder)|| ( opw.objectName.toLowerCase() == finder.toLowerCase()) ){
                Map<String, Schema.SObjectField> FsMap = r.fields.getMap();
                if(FsMap.containsKey(fieldName.toLowerCase())){
                    Schema.DescribeFieldResult dfr = FsMap.get(fieldName.toLowerCase()).getDescribe();
                    opw.AvailablePicklist = new List<String>();
                    if( dfr.getType() == Schema.DisplayType.MultiPicklist){
                        for(Schema.PicklistEntry p :dfr.getPicklistValues()){
                            if(p.isActive()) opw.AvailablePicklist.add(p.getValue());
                        }
                        
                    }
                }
                break;
            }
            
        }
        return opw;
    }
    
    @AuraEnabled
    public static string savePickList(String recordId, String fieldName, String objectName, List<String> vals){
        string err;
        try{
            string value ='';
            for(String l:vals)
                value += value==''?l:';'+l; 
            
            List<sObject> s = Database.query('select id,'+fieldName+' from '+objectName+' where id=:recordId');
            if(s.size()>0){
                s[0].put(fieldName,value);
                update s[0];
                return 'SUCCESS';
            }
        }catch(Exception e){ err +=e.getMessage();}
        
        return 'FAILED-'+err;
    } 
    
    public class OutPutWrapper{
        @AuraEnabled
        public List<string> AvailablePicklist;
        @AuraEnabled
        public List<string> SelectedPicklist;
        @AuraEnabled
        public String objectName;
        @AuraEnabled
        public String errorMsg;
        public OutPutWrapper(){
            
        }
        
        public void adjustMent(){
            List<String> local = new List<String>();
            if(AvailablePicklist !=null){
            for(String s : AvailablePicklist){
                Boolean f = false;
                for(String ins : SelectedPicklist){
                    if(ins ==s) f = true;
                }
                if(!f) local.add(s);
            }
            }
            AvailablePicklist = local;
        }
    }
}