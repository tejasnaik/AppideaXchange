public class HC_ScheduleListController {
	/*This method get the schedule for today and tommorow*/
    @auraEnabled
    public Static String getScheduleList(List<String> lstFieldName,String whatType,Integer addDay){
       String strQuery = 'Select ';        
        for(String str: lstFieldName){ 
            strQuery += str + ',';
        }
        strQuery = strQuery.substring(0, strQuery.length()-1);
        Date activityDate = System.TODAY().AddDays(Integer.valueOf(addDay));
        system.debug('Dtae--'+activityDate);
        //String typeCondition = (String.isNotBlank(whatType))?'And what.type =:whatType':'';
       	strQuery += ' from Task where ActivityDate =:activityDate Order by lastmodifieddate DESC limit 5';
        //strQuery += ' from Task Order by lastmodifieddate DESC limit 5';
        system.debug('Strquery--'+strQuery);
        ScheduleWrapper objSchedule = new ScheduleWrapper();
        objSchedule.lstObject = Database.query(strQuery);
        return JSON.serialize(objSchedule);
        
    }//End
    
    public class ScheduleWrapper{
        public List<Object> lstObject {get;set;}
    }
}