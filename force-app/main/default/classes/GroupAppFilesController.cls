public class GroupAppFilesController {
    //To generate files URL
    @AuraEnabled
    public static Map<String, String> getFile(String appID, List<ContentVersion> iconFiles){
        Map<String, String> fileList = new Map<String, String>();
        for(ContentVersion cv :iconFiles){
            String urlDownload = URL.getSalesforceBaseUrl().toExternalForm()+'/sfc/servlet.shepherd/version/download/'+cv.Id;
            String filtType = cv.FileType;
            String title = cv.Title+'#'+filtType;
            fileList.put(urlDownload, title);
        }
        return fileList;
    }
}