global class TreeViewController{
	
    @AuraEnabled
    public static List<Sobject> getData(String parent,String child) { 
        String queryStr = 'Select name, (SELECT name FROM '+child+' ) FROM '+parent+' LIMIT 5';
      	return Database.query(queryStr);
    }
}