/*
* Created By : Ashlekh Gera 
* This Class has been expose on site to provide API method for Chatter APPXChange aplication.
* Currenly only having POST verb to insert the Page and Install hit functionality. 
*/
@RestResource(urlMapping='/notificationservice/v1/*')
global without sharing class CTS_PvtAppXChangeNotificationV1 {
    
    @HttpPost
    global static String doPost(String listingId, String userId, String body, String type, String extraData){
        
		if( type != null && type.equalsIgnoreCase('comments')){
            return Cts_AppXUtility.logComment(listingId,userId,body);      
        }else if(type != null && type.equalsIgnoreCase('submitRating')){
            return Cts_AppXUtility.submitRating(listingId,userId,body);      
        }
        return '';
    }
}