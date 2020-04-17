/*
	Created by Ashlekh Gera
	Method of this class has been used in other class.
*/
 
public class Cts_AppXUtility {
	
	//Method is being used by Notification V1 service to store the user rating of component.
	@TestVisible public static String submitRating(String listingId,String userId,String body){
        try{
            Integer ratingValue = 0;
            if(body != null && body.isNumeric())
                ratingValue = Integer.valueOf(body);
            return Cts_pvtAppXlandingController.submitRating(ratingValue,listingId,userId ,'API');
        }catch(Exception e){
			throw new AuraHandledException('submitRating : Getting Error : '+e.getLineNumber()+e.getMessage());
            return '{ "isSuccess":false,"message":"'+e.getMessage()+'"}';
        } 
    }
	
	//Method is being used by Notification V1 Service to log user comment.
	@TestVisible public static String logComment(String listingId,String userId,String body){
        try{
            return Cts_CommentController.createComment(listingId, userId , body);
        }catch(Exception e){ return '{ "isSuccess":false,"message":"'+e.getMessage()+'"}'; }
    } 
    
    public static REST_API_Setting__mdt getCustomMetadata(String DeveloperName)
    {
    	try
    	{	
    		REST_API_Setting__mdt restAPISetting = [SELECT 	MasterLabel, DeveloperName, 
    														REST_Endpoint__c, Is_Active__c 
                                                            FROM REST_API_Setting__mdt
                                                            WHERE DeveloperName =:DeveloperName ];
			return  restAPISetting;                                                       
    	}
    	catch(Exception e){return null;}                                                
    }
    
    public static HttpRequest getRequest(String endPoint, String verb, String header, String body ){
    		HttpRequest request = new HttpRequest();
    		request.setEndpoint(endPoint); 	
    		request.setHeader('Content-Type',header); 
    		request.setMethod(verb); 
    		request.setBody(body);
    		return request;
    }
	

}