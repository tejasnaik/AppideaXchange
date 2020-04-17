/**
 * Apex Controller for looking up an SObject via SOSL
 */
public with sharing class LookupSObjectController 
{
    /**
     * Aura enabled method to search a specified SObject for a specific string
     */
    @AuraEnabled
    public static Result[] lookup(String searchString, String sObjectAPIName,String[] fields,String searchOn)
    {	system.debug('searchString------------->'+searchString);
     	system.debug('sObjectAPIName------------->'+sObjectAPIName);
     	system.debug('fields------------->'+fields);
     	system.debug('searchOn------------->'+searchOn);
        // Sanitze the input
        String sanitizedSearchString = String.escapeSingleQuotes(searchString);
        String sanitizedSObjectAPIName = String.escapeSingleQuotes(sObjectAPIName);
 
        List<Result> results = new List<Result>();
 
        // Build our SOSL query
        String searchQuery = 'FIND \'' + sanitizedSearchString + '*\' IN ' +searchOn +' FIELDS RETURNING ' + sanitizedSObjectAPIName + fields + 'Limit 50'; 
 		system.debug('------------------>'+searchQuery);
        // Execute the Query
        List<List<SObject>> searchList = search.query(searchQuery);
 
        // Create a list of matches to return
        for (SObject so : searchList[0])
        {
            results.add(new Result(so));
        }
         
        return results;
    }
     
    /**
     * Inner class to wrap up an SObject Label and its Id
     */
    public class Result
    {
        @AuraEnabled public SObject objRecords {get; set;}
         
        public Result(SObject obj)
        {
            this.objRecords = obj;
        }
    }
}