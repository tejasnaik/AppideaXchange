public class CTS_UtilityMethods {

    
    public static List<string> findObjectWithfield(String way,String finder,string fieldName,String Ftype){
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        List<string> AvailablePicklist = new List<string>();
        for(String sObj : gd.keySet())
        {
            Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();
            String objectName =r.getName(); 
            String keyprefix = r.getKeyPrefix();
            if((way=='Keyprefix' && keyprefix == finder)|| ( objectName.toLowerCase() == finder.toLowerCase()) ){
                Map<String, Schema.SObjectField> FsMap = r.fields.getMap();
                if(FsMap.containsKey(fieldName.toLowerCase())){
                    Schema.DescribeFieldResult dfr = FsMap.get(fieldName.toLowerCase()).getDescribe();
                    //AvailablePicklist = new List<String>();
                    if( String.valueOf(dfr.getType()).equalsIgnoreCase(Ftype)){
                        for(Schema.PicklistEntry p :dfr.getPicklistValues()){
                            if(p.isActive()) AvailablePicklist.add(p.getValue());
                        }
                    }
                }
                break;
            }
            
            
        }
        return AvailablePicklist;
    }

}