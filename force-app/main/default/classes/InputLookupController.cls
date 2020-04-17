/*
 * Author		: Sachin Chavan
 * Date			: March 2017
 * Description	: Apex controller for Input Lookup Component.
 */
global with sharing class InputLookupController {

    @AuraEnabled
    global static String lookupSearch(String objectName, String keyword) {
        keyword = '\'%' + keyword + '%\'';
        String query = 'SELECT Id, Name FROM ' + objectName + ' WHERE Name LIKE ' + keyword + ' LIMIT 5';
        List<SObject> recordList = Database.query(query);
        
        return JSON.serialize(recordList);
    }
    
}